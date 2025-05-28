import 'package:do_host/bloc/post_all_job_get_bloc/post_all_job_get_bloc.dart';
import 'package:do_host/configs/color/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class _JobsScreenState extends State<JobsScreen> {
  late PostAllJobGetBloc postAllJobGetBloc;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List _filteredJobs = [];

  // helper function
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    postAllJobGetBloc = PostAllJobGetBloc(postAllJobGetApiRepository: getIt());
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

  bool _isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => postAllJobGetBloc..add(PostAllJobGetFetch()),
        child: BlocBuilder<PostAllJobGetBloc, PostAllJobGetState>(
          buildWhen: (previous, current) =>
              previous.postAllJobGetList != current.postAllJobGetList,
          builder: (context, state) {
            switch (state.postAllJobGetList.status) {
              case Status.loading:
                return const Center(child: CircularProgressIndicator());
              case Status.error:
                return const Center(child: Text("Failed to load jobs."));
              case Status.completed:
                final jobs = state.postAllJobGetList.data?.data ?? [];
                final today = DateTime.now();

                // Filter jobs by expiration date
                final activeJobs = jobs.where((job) {
                  final lastDate = job.lastDateToApply;
                  return lastDate.isAfter(today) ||
                      _isSameDate(lastDate, today);
                }).toList();

                // Apply search filter
                _filteredJobs = _searchQuery.isEmpty
                    ? activeJobs
                    : activeJobs
                          .where(
                            (job) => job.jobTitle.toLowerCase().contains(
                              _searchQuery,
                            ),
                          )
                          .toList();

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
                    Expanded(
                      child: _filteredJobs.isEmpty
                          ? const Center(child: Text("No job posts found."))
                          : ListView.builder(
                              itemCount: _filteredJobs.length,
                              itemBuilder: (context, index) {
                                final job = _filteredJobs[index];
                                final postDate = DateFormat(
                                  'dd MMM yyyy',
                                ).format(job.postDate);
                                final lastDate = DateFormat(
                                  'dd MMM yyyy',
                                ).format(job.lastDateToApply);

                                return Card(
                                  color: Colors.white,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 2,
                                  ),
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Job Title
                                        Text(
                                          job.jobTitle,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),

                                        // Company & Location
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.business,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                            const SizedBox(width: 6),
                                            Flexible(
                                              flex: 1,
                                              child: Text(
                                                job.companyName,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                                overflow: TextOverflow.ellipsis,
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
                                              flex: 1,
                                              child: Text(
                                                job.location,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 8),

                                        // Description with ReadMore
                                        ReadMoreText(
                                          job.jobDescription,
                                          trimLines: 3,
                                          trimMode: TrimMode.Line,
                                          trimCollapsedText: 'Show more',
                                          trimExpandedText: 'Show less',
                                          colorClickableText:
                                              AppColors.buttonColor,
                                          style: const TextStyle(fontSize: 14),
                                          moreStyle: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.buttonColor,
                                          ),
                                          lessStyle: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.buttonColor,
                                          ),
                                        ),

                                        const SizedBox(height: 12),

                                        // Dates
                                        Wrap(
                                          spacing: 12,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons.calendar_today,
                                                  size: 16,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(width: 6),
                                                Text("Posted: $postDate"),
                                              ],
                                            ),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(
                                                  Icons.hourglass_bottom,
                                                  size: 16,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(width: 4),
                                                Text("Apply by: $lastDate"),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),

                                        // Apply Button
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: ElevatedButton.icon(
                                            onPressed: () async {
                                              final url = job.jobApplyUrl;
                                              if (url != null &&
                                                  url.isNotEmpty) {
                                                try {
                                                  await _launchURL(url);
                                                } catch (e) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Could not open the URL',
                                                      ),
                                                    ),
                                                  );
                                                }
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
                                            icon: const Icon(Icons.open_in_new),
                                            label: const Text("Apply Now"),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.buttonColor,
                                              foregroundColor: Colors
                                                  .white, // <-- This sets text and icon color to white
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                );
              default:
                return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
