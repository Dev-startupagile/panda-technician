import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIcons {
  static SvgPicture get skipIcon => SvgPicture.asset(
        'asset/icons/skip_icon.svg',
        height: 21.33.h,
        width: 21.33.w,
      );

  static SvgPicture get googleIcon => SvgPicture.asset(
        'assets/google_logo.svg',
        height: 32,
        width: 32,
      );

  static SvgPicture get facebookIcon => SvgPicture.asset(
        'assets/facebook_logo.svg',
        height: 32,
        width: 32,
      );
  static SvgPicture get appleIcon => SvgPicture.asset(
        'assets/apple_logo.svg',
        height: 32,
        width: 32,
      );
}
