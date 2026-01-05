import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

enum ToastType { success, info, error }

class CustomToast extends StatelessWidget {
  final String title;
  final String message;
  final ToastType type;

  const CustomToast({
    Key? key,
    required this.title,
    required this.message,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define cores e ícones baseados no tipo
    Color color;
    IconData icon;

    switch (type) {
      case ToastType.success:
        color = AppColors.successToast;
        icon = Icons.check_circle;
        break;
      case ToastType.info:
        color = AppColors.infoToast;
        icon = Icons.info;
        break;
      case ToastType.error:
        color = AppColors.errorToast;
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(
          16,
        ), 
        boxShadow: [
          
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 20,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Container(
            height: 4,
            width: double.infinity,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(color: color.withOpacity(0.5), blurRadius: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
