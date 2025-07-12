import 'dart:io' show File;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import 'package:do_host/configs/color/color.dart';
import 'package:do_host/data/response/status.dart';
import 'package:do_host/services/session_manager/session_controller.dart';
import 'package:do_host/repository/response_api_repository.dart';
import 'package:do_host/utils/app_url.dart';
import 'package:do_host/data/network/network_api_services.dart';
import 'package:do_host/bloc/user_video_bloc/user_video_bloc.dart';
import 'package:do_host/bloc/user_video_get_bloc/user_video_get_bloc.dart';
import 'package:do_host/model/user_video_get/user_video_model.dart';

extension FirstOrNullExtension<T> on List<T> {
  T? get firstOrNull => isNotEmpty ? first : null;
}

class VideoAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? userId;
  const VideoAppBar({Key? key, required this.userId}) : super(key: key);

  @override
  State<VideoAppBar> createState() => _VideoAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(220);
}

class _VideoAppBarState extends State<VideoAppBar> {
  XFile? _videoFile;
  VideoPlayerController? _controller;
  final ImagePicker _picker = ImagePicker();
  String? _fetchedVideoUrl;
  bool _isLoading = false;
  String? _currentVideoId;

  final NetworkApiService _apiService = NetworkApiService();
  final responseApi = ResponseApiRepository();

  @override
  void initState() {
    super.initState();
    context.read<UserVideoGetBloc>().add(
      UserVideoGetFetch(userId: widget.userId!),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initializeControllerWithFile(File file) async {
    await _controller?.dispose();

    final newController = VideoPlayerController.file(file);
    await newController.initialize();
    newController.setLooping(true);

    if (!mounted) return;

    setState(() {
      _videoFile = XFile(file.path);
      _controller = newController;
      _fetchedVideoUrl = null;
      _currentVideoId = null;
    });

    newController.play();
  }

  Future<void> _initializeControllerWithUrl(String url) async {
    setState(() => _isLoading = true);
    await _controller?.dispose();

    final newController = VideoPlayerController.network(url);

    try {
      await newController.initialize();
      newController.setLooping(true);

      if (!mounted) return;

      setState(() {
        _videoFile = null;
        _controller = newController;
        _fetchedVideoUrl = url;
        _isLoading = false;
      });

      newController.play();
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to load video: $e")));
    }
  }

  Future<void> _pickVideo(BuildContext context) async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Video picking not supported on Web.")),
      );
      return;
    }

    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      await _initializeControllerWithFile(file);

      final userId = await SessionController().getUserId();
      if (userId != null) {
        final bloc = context.read<UserVideoBloc>();
        bloc.add(UserIdChanged(userId: userId));
        bloc.add(VideoFileChanged(videoFile: file));
        bloc.add(const SubmitUserVideo());
      }
    }
  }

  Future<void> _deleteUserVideo(String videoId) async {
    try {
      final token = await SessionController().getToken();
      if (token == null) throw Exception('No token found');

      final url = "${AppUrl.baseUrl}/user/video/$videoId";
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      await _apiService.deleteApi(url, headers: headers);

      setState(() {
        _videoFile = null;
        _controller?.dispose();
        _controller = null;
        _fetchedVideoUrl = null;
        _currentVideoId = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Video deleted successfully.")),
      );

      context.read<UserVideoGetBloc>().add(
        UserVideoGetFetch(userId: widget.userId!),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to delete video: $e")));
    }
  }

  void _togglePlayPause() {
    if (_controller == null || !_controller!.value.isInitialized) return;
    setState(() {
      _controller!.value.isPlaying ? _controller!.pause() : _controller!.play();
    });
  }

  void _updateCurrentVideoId(String? videoId) {
    _currentVideoId = videoId;
  }

  Widget _buildVideoWidget() {
    if (_isLoading) {
      return const Center(
        child: SpinKitSpinningLines(color: AppColors.buttonColor, size: 50.0),
      );
    }

    if (_controller != null && _controller!.value.isInitialized) {
      return ClipRRect(
        child: AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: VideoPlayer(_controller!),
        ),
      );
    }

    return Container(
      color: Colors.black,
      child: const Center(
        child: Text(
          "Add interview video",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = _controller?.value.isPlaying ?? false;

    return BlocListener<UserVideoGetBloc, UserVideoGetState>(
      listenWhen: (prev, curr) =>
          prev.userVideoGetList.data?.firstOrNull?.videoUrl !=
              curr.userVideoGetList.data?.firstOrNull?.videoUrl ||
          prev.userVideoGetList.data?.firstOrNull?.id !=
              curr.userVideoGetList.data?.firstOrNull?.id,
      listener: (context, getState) {
        final video = getState.userVideoGetList.data?.firstOrNull;

        if (video != null && video.videoUrl != _fetchedVideoUrl) {
          _updateCurrentVideoId(video.id);
          _initializeControllerWithUrl(video.videoUrl);
        }
      },
      child: BlocConsumer<UserVideoBloc, UserVideoState>(
        listener: (context, state) {
          if (state.userVideoApi.status == Status.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Error: ${state.userVideoApi.message ?? 'Unknown error'}",
                ),
              ),
            );
          } else if (state.userVideoApi.status == Status.completed &&
              state.userVideoApi.message == "Video uploaded successfully") {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Video uploaded successfully")),
            );
            context.read<UserVideoGetBloc>().add(
              UserVideoGetFetch(userId: widget.userId!),
            );
          }
        },
        builder: (context, _) {
          return AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: Stack(
              fit: StackFit.expand,
              children: [
                _buildVideoWidget(),
                Positioned(
                  top: 10,
                  right: 10,
                  child: (_videoFile != null || _fetchedVideoUrl != null)
                      ? ElevatedButton.icon(
                          onPressed: () {
                            if (_currentVideoId != null) {
                              _deleteUserVideo(_currentVideoId!);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("No video to delete"),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.delete),
                          label: const Text("Delete"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        )
                      : ElevatedButton.icon(
                          onPressed: () => _pickVideo(context),
                          icon: const Icon(Icons.video_call),
                          label: const Text("Add"),
                        ),
                ),
                if ((_videoFile != null || _fetchedVideoUrl != null) &&
                    _controller != null &&
                    _controller!.value.isInitialized)
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: ElevatedButton.icon(
                      onPressed: _togglePlayPause,
                      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                      label: Text(isPlaying ? "Pause" : "Play"),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
