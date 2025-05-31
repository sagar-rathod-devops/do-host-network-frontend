import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:video_player/video_player.dart';

import 'package:do_host/bloc/user_video_get_bloc/user_video_get_bloc.dart';
import 'package:do_host/configs/color/color.dart';

class UserVideoGetWidget extends StatefulWidget implements PreferredSizeWidget {
  final String? userId;
  UserVideoGetWidget({Key? key, required this.userId}) : super(key: key);

  @override
  State<UserVideoGetWidget> createState() => _UserVideoGetWidgetState();

  @override
  Size get preferredSize => const Size.fromHeight(220);
}

class _UserVideoGetWidgetState extends State<UserVideoGetWidget> {
  VideoPlayerController? _controller;
  bool _isLoading = false;
  String? _currentVideoUrl;

  @override
  void initState() {
    super.initState();
    // Trigger video fetch from server
    if (widget.userId != null) {
      context.read<UserVideoGetBloc>().add(
        UserVideoGetFetch(userId: widget.userId!),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _initializeControllerWithUrl(String url) async {
    setState(() {
      _isLoading = true;
    });

    await _controller?.dispose();
    final newController = VideoPlayerController.network(url);
    await newController.initialize();

    newController.setLooping(true);
    if (!mounted) return;

    setState(() {
      _controller = newController;
      _currentVideoUrl = url;
      _isLoading = false;
    });

    newController.play();
  }

  void _togglePlayPause() {
    if (_controller == null || !_controller!.value.isInitialized) return;
    setState(() {
      _controller!.value.isPlaying ? _controller!.pause() : _controller!.play();
    });
  }

  Widget _buildVideoWidget() {
    // // Check if video URL is null or empty
    // if (_currentVideoUrl == null || _currentVideoUrl!.isEmpty) {
    //   return Container(
    //     color: Colors.black,
    //     child: const Center(
    //       child: Text(
    //         "No interview video available",
    //         style: TextStyle(color: Colors.white, fontSize: 18),
    //       ),
    //     ),
    //   );
    // }

    // If still loading, show loader
    if (_isLoading) {
      return const Center(
        child: SpinKitSpinningLines(color: AppColors.buttonColor, size: 50.0),
      );
    }

    // When video controller is initialized
    if (_controller != null && _controller!.value.isInitialized) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AspectRatio(
          aspectRatio: _controller!.value.aspectRatio,
          child: VideoPlayer(_controller!),
        ),
      );
    }

    // If nothing is initialized (fallback)
    return Container(
      color: Colors.black,
      child: const Center(
        child: Text(
          "No interview video available",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = _controller?.value.isPlaying ?? false;

    return BlocListener<UserVideoGetBloc, UserVideoGetState>(
      listenWhen: (previous, current) =>
          previous.userVideoGetList.data?.videoUrl !=
          current.userVideoGetList.data?.videoUrl,
      listener: (context, state) {
        final videoUrl = state.userVideoGetList.data?.videoUrl;

        if (videoUrl != null && videoUrl != _currentVideoUrl) {
          _initializeControllerWithUrl(videoUrl);
        }
      },
      child: AppBar(
        automaticallyImplyLeading: true, // Show back button
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.white, // White background color
        flexibleSpace: Stack(
          fit: StackFit.expand,
          children: [
            _buildVideoWidget(),
            if (_controller != null && _controller!.value.isInitialized)
              Positioned(
                bottom: 10,
                right: 10,
                child: ElevatedButton.icon(
                  onPressed: _togglePlayPause,
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors
                        .white, // Change icon color for contrast on white background
                  ),
                  label: Text(
                    isPlaying ? "Pause" : "Play",
                    style: const TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(
                      0.7,
                    ), // Slight transparent white button
                    elevation: 0,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
