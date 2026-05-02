import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class CaloAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CaloAppBar({
    super.key,
    this.title,
    this.showBack = true,
    this.onBack,
  });

  final String? title;
  final bool showBack;
  final VoidCallback? onBack;

  static const double _circleSize = 44;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: preferredSize.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (title != null)
                Text(title!, style: AppTextStyles.appBarTitle),
              Align(
                alignment: Alignment.centerLeft,
                child: showBack
                    ? _CircleIconButton(
                        icon: Icons.arrow_back,
                        onTap: onBack ?? () => Navigator.of(context).maybePop(),
                        semanticLabel: 'Back',
                      )
                    : const SizedBox(width: _circleSize, height: _circleSize),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: _CircleIconButton(
                  icon: Icons.headset_mic_outlined,
                  onTap: () {},
                  semanticLabel: 'Support',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.icon,
    required this.onTap,
    required this.semanticLabel,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      child: Material(
        color: AppColors.circleButtonBg,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: CaloAppBar._circleSize,
            height: CaloAppBar._circleSize,
            child: Icon(
              icon,
              size: 20,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
