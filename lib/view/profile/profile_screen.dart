import 'package:do_host/bloc/user_experience_get_bloc/user_experience_get_bloc.dart';
import 'package:do_host/bloc/user_profile_bloc/user_profile_bloc.dart';
import 'package:do_host/bloc/user_video_bloc/user_video_bloc.dart';
import 'package:do_host/bloc/user_video_get_bloc/user_video_get_bloc.dart';
import 'package:do_host/configs/color/color.dart';
import 'package:do_host/configs/routes/routes_name.dart';
import 'package:do_host/repository/response_api_repository.dart';
import 'package:do_host/services/session_manager/session_controller.dart';
import 'package:do_host/view/profile/user_education/user_education_widget.dart';
import 'package:do_host/view/profile/user_experience/user_experience_widget.dart';
import 'package:do_host/view/profile/user_profile/user_profile_update_widget.dart';
import 'package:do_host/view/profile/user_profile/user_profile_widget.dart';
import 'package:do_host/view/profile/user_stats_widgets.dart';
import 'package:do_host/view/profile/user_video/user_video_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

import '../../bloc/user_education_get_bloc/user_education_get_bloc.dart';
import '../../bloc/user_profile_get_bloc/user_profile_get_bloc.dart';
import '../../data/response/status.dart';
import '../../dependency_injection/locator.dart';
import '../../model/user_education_get/user_education_get_model.dart';
import '../../model/user_experience_get/user_experience_get_model.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // File? _videoFile;
  VideoPlayerController? _controller;
  final responseApi = ResponseApiRepository();
  List<UserEducation> educationList = [];
  List<UserExperience> experiences = [];

  late UserProfileGetBloc userProfileGetBloc;
  late UserEducationGetBloc userEducationGetBloc;
  late UserExperienceGetBloc userExperienceGetBloc;
  late UserVideoGetBloc userVideoGetBloc;
  late UserVideoBloc userVideoBloc;

  @override
  void initState() {
    super.initState();
    userProfileGetBloc = UserProfileGetBloc(
      userProfileGetApiRepository: getIt(),
    );
    userEducationGetBloc = UserEducationGetBloc(
      userEducationGetApiRepository: getIt(),
    );
    userExperienceGetBloc = UserExperienceGetBloc(
      userExperienceGetApiRepository: getIt(),
    );
    userVideoGetBloc = UserVideoGetBloc(userVideoGetApiRepository: getIt());
    userVideoBloc = UserVideoBloc(userVideoApiRepository: getIt());

    userVideoGetBloc.add(UserVideoGetFetch(userId: widget.userId!));
  }

  void _handleDeleteSuccess(String id) async {
    try {
      await responseApi.deleteUserEducation(id); // Call the API

      setState(() {
        educationList.removeWhere(
          (edu) => edu.id == id,
        ); // Update UI immediately
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Education deleted successfully.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to delete: $e")));
    }
  }

  void _onExperienceDelete(String id) async {
    try {
      await responseApi.deleteUserExperience(id); // Call the API
      setState(() {
        experiences.removeWhere((exp) => exp.id == id); // Update UI
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Experience deleted successfully.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to delete: $e")));
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    userProfileGetBloc.close();
    userEducationGetBloc.close();
    userExperienceGetBloc.close();
    userVideoGetBloc.close();
    userVideoBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double contentWidth = MediaQuery.of(context).size.width;

    // Responsive width for different platforms
    double maxContentWidth = contentWidth < 600
        ? contentWidth // Mobile
        : contentWidth < 1100
        ? 600 // Tablet/Web Small
        : 800; // Desktop/Web Large

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              userProfileGetBloc..add(UserProfileGetFetch(widget.userId!)),
        ),
        BlocProvider(
          create: (_) =>
              userEducationGetBloc..add(UserEducationGetFetch(widget.userId!)),
        ),
        BlocProvider(
          create: (_) =>
              userExperienceGetBloc
                ..add(UserExperienceGetFetch(widget.userId!)),
        ),
        BlocProvider(create: (_) => userVideoGetBloc),
        BlocProvider(create: (_) => userVideoBloc),
      ],
      child: Scaffold(
        appBar: VideoAppBar(
          userId: widget.userId,
        ), // ✅ Now has access to both blocs
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  /// USER PROFILE SECTION
                  BlocBuilder<UserProfileGetBloc, UserProfileGetState>(
                    buildWhen: (previous, current) =>
                        previous.userProfile != current.userProfile,
                    builder: (context, state) {
                      final status = state.userProfile.status;
                      final profile = state.userProfile.data;

                      debugPrint("User Profile data: $profile");

                      if (status == Status.loading) {
                        return const Center(
                          child: SpinKitSpinningLines(
                            color: AppColors.buttonColor,
                            size: 50.0,
                          ),
                        );
                      }

                      if (status == Status.error || profile == null) {
                        return _buildAddUserProfileCard(
                          context,
                          "No Profile Data Available",
                          Icons.person_outline,
                        );
                      }

                      return _buildUserProfileCard(profile);
                    },
                  ),

                  const SizedBox(height: 2),
                  UserStatsWidget(userId: widget.userId!),
                  const SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Education",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    UserEducationWidget(userId: widget.userId!),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  BlocBuilder<UserEducationGetBloc, UserEducationGetState>(
                    buildWhen: (previous, current) =>
                        previous.userEducationGetList !=
                        current.userEducationGetList,
                    builder: (context, state) {
                      if (state.userEducationGetList.status == Status.loading) {
                        return const Center(
                          child: SpinKitSpinningLines(
                            color: AppColors.buttonColor,
                            size: 50.0,
                          ),
                        );
                      }

                      final fetchedList =
                          state.userEducationGetList.data?.data ?? [];

                      if (state.userEducationGetList.status == Status.error ||
                          fetchedList.isEmpty) {
                        return _buildAddUserEducationCard(
                          context,
                          "No Education Data Available",
                          Icons.school,
                        );
                      }

                      if (educationList.isEmpty) {
                        educationList = List<UserEducation>.from(fetchedList);
                      }

                      return buildUserEducationCard(
                        educationList,
                        context,
                        _handleDeleteSuccess,
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  /// EXPERIENCE SECTION
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Experience",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => UserExperienceWidget(
                                  userId: widget.userId!,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<UserExperienceGetBloc, UserExperienceGetState>(
                    buildWhen: (previous, current) =>
                        previous.userExperienceGetList !=
                        current.userExperienceGetList,
                    builder: (context, state) {
                      if (state.userExperienceGetList.status ==
                          Status.loading) {
                        return const Center(
                          child: SpinKitSpinningLines(
                            color: AppColors.buttonColor,
                            size: 50.0,
                          ),
                        );
                      }

                      if (state.userExperienceGetList.status == Status.error) {
                        return _buildAddUserExperienceCard(
                          context,
                          "No Experience Data Available",
                          Icons.error_outline,
                        );
                      }

                      final fetchedExperience =
                          state.userExperienceGetList.data?.data ?? [];

                      experiences = fetchedExperience;

                      if (fetchedExperience.isEmpty) {
                        return _buildAddUserExperienceCard(
                          context,
                          "No Experience Data Available",
                          Icons.person_outline,
                        );
                      }

                      return buildUserExperienceCards(
                        context,
                        experiences,
                        _onExperienceDelete,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddUserProfileCard(
    BuildContext context,
    String message,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(icon, size: 40, color: Colors.grey),
                  const SizedBox(width: 12),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserProfileWidget(userId: widget.userId!),
                  ),
                );
              },
              child: const Icon(Icons.add_circle, size: 24, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddUserEducationCard(
    BuildContext context,
    String message,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(icon, size: 40, color: Colors.grey),
                  const SizedBox(width: 12),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserEducationWidget(userId: widget.userId!),
                  ),
                );
              },
              child: const Icon(Icons.add_circle, size: 24, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddUserExperienceCard(
    BuildContext context,
    String message,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(icon, size: 40, color: Colors.grey),
                  const SizedBox(width: 12),
                  Text(
                    message,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        UserExperienceWidget(userId: widget.userId!),
                  ),
                );
              },
              child: const Icon(Icons.add_circle, size: 24, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfileCard(profile) {
    return FutureBuilder<String?>(
      future: SessionController().getFullName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Text("Error loading session");
        }

        final loggedInFullName = snapshot.data ?? "";

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 3,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Profile image and basic info
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundImage:
                                profile.profileImage?.isNotEmpty == true
                                ? NetworkImage(profile.profileImage)
                                : null,
                            child: profile.profileImage?.isEmpty ?? true
                                ? const Icon(Icons.person, size: 50)
                                : null,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  profile.fullName,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.badge,
                                      color: Colors.blue,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        profile.designation,
                                        style: const TextStyle(fontSize: 16),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        profile.location,
                                        style: const TextStyle(fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),

                                /// 👇 Show Logged-in Full Name
                                if (loggedInFullName.isNotEmpty)
                                  Text(
                                    "Logged in as: $loggedInFullName",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Email
                      Row(
                        children: [
                          const Icon(Icons.email, size: 18, color: Colors.blue),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              profile.email,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Phone
                      Row(
                        children: [
                          const Icon(Icons.phone, size: 18, color: Colors.blue),
                          const SizedBox(width: 8),
                          Text(
                            profile.contactNumber,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      const Divider(),

                      const Text(
                        "Professional Summary:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile.professionalSummary,
                        style: const TextStyle(fontSize: 14),
                      ),

                      const SizedBox(height: 12),

                      if (profile.organization.isNotEmpty)
                        Row(
                          children: [
                            const Icon(
                              Icons.business,
                              size: 18,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              profile.organization,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () async {
                    final shouldUpdate = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Update Profile"),
                        content: const Text(
                          "Are you sure you want to update this profile?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context, true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: const Text("Update"),
                          ),
                        ],
                      ),
                    );

                    if (shouldUpdate == true) {
                      // Navigate to the profile update screen with the given userId
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UserProfileUpdateWidget(userId: widget.userId),
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue.withOpacity(0.1),
                    ),
                    child: const Icon(Icons.edit, color: Colors.blue),
                  ),
                ),
              ),

              // Delete button
              // Positioned(
              //   top: 12,
              //   right: 12,
              //   child: GestureDetector(
              //     onTap: () async {
              //       final shouldDelete = await showDialog<bool>(
              //         context: context,
              //         builder: (context) => AlertDialog(
              //           title: const Text("Delete Profile"),
              //           content: const Text(
              //             "Are you sure you want to delete this profile?",
              //           ),
              //           actions: [
              //             TextButton(
              //               onPressed: () => Navigator.pop(context, false),
              //               child: const Text("Cancel"),
              //             ),
              //             ElevatedButton(
              //               onPressed: () => Navigator.pop(context, true),
              //               style: ElevatedButton.styleFrom(
              //                 backgroundColor: Colors.red,
              //               ),
              //               child: const Text("Delete"),
              //             ),
              //           ],
              //         ),
              //       );

              //       if (shouldDelete == true) {
              //         try {
              //           await SessionController().clearFullName();
              //           await responseApi.deleteUserProfile(profile.userId);
              //           setState(() {});
              //           ScaffoldMessenger.of(context).showSnackBar(
              //             const SnackBar(
              //               content: Text("Profile deleted successfully"),
              //             ),
              //           );
              //         } catch (e) {
              //           ScaffoldMessenger.of(context).showSnackBar(
              //             SnackBar(
              //               content: Text(
              //                 "Error deleting profile: ${e.toString()}",
              //               ),
              //             ),
              //           );
              //         }
              //       }
              //     },
              //     child: Container(
              //       padding: const EdgeInsets.all(6),
              //       decoration: BoxDecoration(
              //         shape: BoxShape.circle,
              //         color: Colors.red.withOpacity(0.1),
              //       ),
              //       child: const Icon(Icons.delete, color: Colors.red),
              //     ),
              //   ),
              // ),
            ],
          ),
        );
      },
    );
  }

  // Build Education Cards
  Widget buildUserEducationCard(
    List<UserEducation> educationList,
    BuildContext context,
    void Function(String id) onDeleteSuccess,
  ) {
    // Sort by year descending
    educationList.sort((a, b) => b.year.compareTo(a.year));

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: educationList.length,
      itemBuilder: (context, index) {
        final edu = educationList[index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 3,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Degree + Field + Delete
                  Row(
                    children: [
                      const Icon(Icons.school, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "${edu.degree} in ${edu.fieldOfStudy}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Confirm Delete"),
                              content: Text(
                                "Are you sure you want to delete ${edu.degree}?",
                              ),
                              actions: [
                                TextButton(
                                  child: const Text("Cancel"),
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                ),
                                ElevatedButton(
                                  child: const Text("Delete"),
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            onDeleteSuccess(edu.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Deleted: ${edu.degree}")),
                            );
                          }
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// Institution
                  Row(
                    children: [
                      const Icon(
                        Icons.location_city,
                        size: 20,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          edu.institutionName,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// Year + Grade
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Year: ${edu.year}",
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.grade, size: 18, color: Colors.blue),
                      const SizedBox(width: 4),
                      Text(
                        "Grade: ${edu.grade}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Build Experience Cards
  Widget buildUserExperienceCards(
    BuildContext context,
    List<UserExperience> experiences,
    void Function(String id) onDeleteSuccess,
  ) {
    if (experiences.isEmpty) {
      return const Center(child: Text('No Experience Data Available'));
    }

    // Sort by startDate descending
    experiences.sort((a, b) {
      if (a.startDate == null && b.startDate == null) return 0;
      if (a.startDate == null) return 1;
      if (b.startDate == null) return -1;
      return b.startDate!.compareTo(a.startDate!);
    });

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: experiences.length,
      itemBuilder: (context, index) {
        final exp = experiences[index];
        final startDate = exp.startDate != null
            ? DateFormat.yMMM().format(exp.startDate!)
            : 'N/A';
        final endDate = exp.endDate != null
            ? DateFormat.yMMM().format(exp.endDate!)
            : 'Present';

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 3,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title + Delete
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.work,
                              color:
                                  Colors.blue, // optional: customize icon color
                              size: 22,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                exp.jobTitle,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  // color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Confirm Delete"),
                              content: Text(
                                "Are you sure you want to delete ${exp.jobTitle}?",
                              ),
                              actions: [
                                TextButton(
                                  child: const Text("Cancel"),
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                ),
                                ElevatedButton(
                                  child: const Text("Delete"),
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            onDeleteSuccess(exp.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Deleted: ${exp.jobTitle}"),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(Icons.business, size: 18, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        exp.companyName,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  DefaultTextStyle.merge(
                    // style: const TextStyle(color: Colors.black),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 18,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            exp.location,
                            style: const TextStyle(
                              fontSize: 14,
                              // color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.calendar_today,
                          size: 18,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "$startDate - $endDate",
                          style: const TextStyle(
                            fontSize: 14,
                            // color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  const Text(
                    "Job Description:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    exp.jobDescription,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),

                  const SizedBox(height: 16),

                  if (exp.achievements.isNotEmpty) ...[
                    const Text(
                      "Achievements:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      exp.achievements,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
