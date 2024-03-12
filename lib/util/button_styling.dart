import 'package:flutter/material.dart';
import 'package:lightbulb/util/colors.dart';

class ButtonStyling {
  static get lsButton => BoxDecoration(
        gradient: const RadialGradient(
          colors: [AppColors.secondaryDark, AppColors.secondaryLight],
          center: Alignment.topLeft,
          radius: 8,
        ),
        borderRadius: BorderRadius.circular(10),
      );
}

class ButtonStylingAlter {
  static get lsButton => BoxDecoration(
        gradient: const RadialGradient(
          colors: [
            AppColors.grey,
            AppColors.white,
          ],
          center: Alignment.topLeft,
          radius: 8,
        ),
        borderRadius: BorderRadius.circular(10),
      );
}

class FollowerFollowingStyle {
  static get lsButton => BoxDecoration(
        border: Border.all(
          width: 1,
          color: AppColors.white,
        ),
        borderRadius: BorderRadius.circular(10),
      );
}

class CreateButtonStyling {
  static get lsButton => BoxDecoration(
        gradient: const RadialGradient(
          colors: [AppColors.secondaryDark, AppColors.secondaryLight],
          center: Alignment.topLeft,
          radius: 8,
        ),
        borderRadius: BorderRadius.circular(20),
      );
}

class CancelButtonStyling {
  static get lsButton => BoxDecoration(
        gradient: const RadialGradient(
          colors: [
            AppColors.grey,
            AppColors.greyDarker,
          ],
          center: Alignment.topLeft,
          radius: 8,
        ),
        borderRadius: BorderRadius.circular(20),
      );
}
