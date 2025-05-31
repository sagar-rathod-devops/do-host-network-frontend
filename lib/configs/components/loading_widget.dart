import 'package:do_host/configs/color/color.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  final double size;
  const LoadingWidget({super.key, this.size = 36.0});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // Web platform - use Material spinner
      return Center(
        child: SizedBox(
          width: size,
          height: size,
          child: const Center(
            child: SpinKitSpinningLines(
              color: AppColors.whiteColor,
              size: 50.0,
            ),
          ),
        ),
      );
    }

    // For mobile/desktop platforms, check the platform using defaultTargetPlatform
    final bool isIOS = defaultTargetPlatform == TargetPlatform.iOS;

    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: isIOS
            ? const CupertinoActivityIndicator()
            : const Center(
                child: SpinKitSpinningLines(
                  color: AppColors.whiteColor,
                  size: 50.0,
                ),
              ),
      ),
    );
  }
}
