import 'package:do_host/bloc/post_all_job_get_bloc/post_all_job_get_bloc.dart';
import 'package:do_host/configs/color/color.dart';
import 'package:do_host/configs/components/internet_exception_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/response/status.dart';
import '../../dependency_injection/locator.dart';

class JobsScreen extends StatefulWidget {
  final String? userId;
  const JobsScreen({super.key, required this.userId});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen>
    with AutomaticKeepAliveClientMixin {
  late final PostAllJobGetBloc postAllJobGetBloc;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List _filteredJobs = [];

  @override
  void initState() {
    super.initState();
    postAllJobGetBloc = PostAllJobGetBloc(postAllJobGetApiRepository: getIt())
      ..add(PostAllJobGetFetch());
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.toLowerCase();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    postAllJobGetBloc.close();
    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open the URL')));
    }
  }

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Needed for AutomaticKeepAliveClientMixin

    return Scaffold(
      key: const PageStorageKey('JobsScreen'),
      body: BlocProvider(
        create: (_) => postAllJobGetBloc,
        child: BlocBuilder<PostAllJobGetBloc, PostAllJobGetState>(
          buildWhen: (previous, current) =>
              previous.postAllJobGetList != current.postAllJobGetList,
          builder: (context, state) {
            if (state.postAllJobGetList.status == Status.loading) {
              return const Center(
                child: SpinKitSpinningLines(
                  color: AppColors.buttonColor,
                  size: 50.0,
                ),
              );
            } else if (state.postAllJobGetList.status == Status.error) {
              return InterNetExceptionWidget(
                onPress: () {
                  // Add the logic to retry the API call or reload the content
                  context.read<PostAllJobGetBloc>().add(PostAllJobGetFetch());
                },
              );
            } else if (state.postAllJobGetList.status == Status.completed) {
              final jobs = state.postAllJobGetList.data?.data ?? [];
              final today = DateTime.now();

              final activeJobs = jobs.where((job) {
                final lastDate = job.lastDateToApply;
                return lastDate.isAfter(today) || _isSameDate(lastDate, today);
              }).toList();

              _filteredJobs = _searchQuery.isEmpty
                  ? activeJobs
                  : activeJobs.where((job) {
                      return job.jobTitle.toLowerCase().contains(_searchQuery);
                    }).toList();

              return LayoutBuilder(
                builder: (context, constraints) {
                  // Responsive width logic for different platforms:
                  double contentWidth = constraints.maxWidth;
                  double maxCardWidth;

                  if (contentWidth < 600) {
                    maxCardWidth = contentWidth; // Mobile - full width
                  } else if (contentWidth < 1100) {
                    maxCardWidth = 600; // Tablet/Web Small
                  } else {
                    maxCardWidth = 800; // Desktop/Web Large
                  }

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: maxCardWidth,
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search by job title...',
                              prefixIcon: const Icon(
                                Icons.search,
                                color: AppColors.buttonColor,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: AppColors.buttonColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: AppColors.buttonColor,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: _filteredJobs.isEmpty
                            ? const Center(child: Text("No job posts found."))
                            : Center(
                                child: ListView.builder(
                                  key: const PageStorageKey("JobsListView"),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  itemCount: _filteredJobs.length,
                                  itemBuilder: (context, index) {
                                    final job = _filteredJobs[index];
                                    final postDate = DateFormat(
                                      'dd MMM yyyy',
                                    ).format(job.postDate);
                                    final lastDate = DateFormat(
                                      'dd MMM yyyy',
                                    ).format(job.lastDateToApply);

                                    return Center(
                                      child: Container(
                                        constraints: BoxConstraints(
                                          maxWidth: maxCardWidth,
                                        ),
                                        child: Card(
                                          color: Colors.white,
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 2,
                                          ),
                                          elevation: 3,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  job.jobTitle,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.business,
                                                      size: 16,
                                                      color: Colors.grey,
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Flexible(
                                                      child: Text(
                                                        job.companyName,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    const Icon(
                                                      Icons.location_on,
                                                      size: 16,
                                                      color: Colors.grey,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Flexible(
                                                      child: Text(
                                                        job.location,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                ReadMoreText(
                                                  job.jobDescription,
                                                  trimLines: 3,
                                                  trimMode: TrimMode.Line,
                                                  trimCollapsedText:
                                                      'Show more',
                                                  trimExpandedText: 'Show less',
                                                  colorClickableText:
                                                      AppColors.buttonColor,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                  moreStyle: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        AppColors.buttonColor,
                                                  ),
                                                  lessStyle: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        AppColors.buttonColor,
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                                Wrap(
                                                  spacing: 12,
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const Icon(
                                                          Icons.calendar_today,
                                                          size: 16,
                                                          color: Colors.grey,
                                                        ),
                                                        const SizedBox(
                                                          width: 6,
                                                        ),
                                                        Text(
                                                          "Posted: $postDate",
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const Icon(
                                                          Icons
                                                              .hourglass_bottom,
                                                          size: 16,
                                                          color: Colors.grey,
                                                        ),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                          "Apply by: $lastDate",
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 12),
                                                Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: ElevatedButton.icon(
                                                    onPressed: () async {
                                                      final url =
                                                          job.jobApplyUrl;
                                                      if (url != null &&
                                                          url.isNotEmpty) {
                                                        await _launchURL(url);
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                              'Invalid application URL',
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    },
                                                    icon: const Icon(
                                                      Icons.open_in_new,
                                                    ),
                                                    label: const Text(
                                                      "Apply Now",
                                                    ),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          AppColors.buttonColor,
                                                      foregroundColor:
                                                          Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                      ),
                    ],
                  );
                },
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
