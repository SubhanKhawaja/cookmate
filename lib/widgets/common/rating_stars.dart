import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final int? reviewsCount;
  final double iconSize;
  final TextStyle? textStyle;

  const RatingStars({
    super.key,
    required this.rating,
    this.reviewsCount,
    this.iconSize = 16,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.star_rounded,
          size: iconSize,
          color: AppColors.ratingStar,
        ),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: textStyle ??
              const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
        ),
        if (reviewsCount != null) ...[
          const SizedBox(width: 4),
          Text(
            '($reviewsCount)',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).textTheme.bodySmall?.color?.withValues(alpha: 0.7),
            ),
          ),
        ],
      ],
    );
  }
}
