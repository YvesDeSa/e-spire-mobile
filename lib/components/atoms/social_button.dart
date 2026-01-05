import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class SocialButton extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  final String? imageUrl;
  final VoidCallback? onTap; 

  const SocialButton({
    Key? key,
    this.icon,
    this.iconColor,
    this.imageUrl,
    this.onTap, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(onTap == null ? 0.5 : 1.0),
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.border.withOpacity(onTap == null ? 0.5 : 1.0)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap, 
          borderRadius: BorderRadius.circular(50),
          child: Center(
            child: imageUrl != null
                ? Image.network(imageUrl!, width: 24, height: 24)
                : Icon(icon, color: iconColor, size: 24),
          ),
        ),
      ),
    );
  }
}