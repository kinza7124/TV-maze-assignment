import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Shows a network image with rounded corners.
/// If the url is missing or the image fails, a placeholder icon is shown.
class PosterImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final double borderRadius;
  final IconData placeholderIcon;

  const PosterImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius = 10,
    this.placeholderIcon = Icons.tv,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: width,
        height: height,
        child: imageUrl == null
            ? _placeholder()
            : Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) =>
                    progress == null ? child : Container(color: AppColors.card),
                errorBuilder: (context, error, stackTrace) => _placeholder(),
              ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.card,
      child: Icon(placeholderIcon, color: AppColors.textSecondary),
    );
  }
}
