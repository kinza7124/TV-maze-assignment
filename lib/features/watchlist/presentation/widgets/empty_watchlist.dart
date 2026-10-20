import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Empty watchlist: purple box with a heart, text and "Explore Shows" button.
class EmptyWatchlist extends StatelessWidget {
  final VoidCallback onExploreTap;

  const EmptyWatchlist({super.key, required this.onExploreTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Simple illustration made from two icons.
            const Icon(Icons.favorite, size: 36, color: AppColors.primary),
            const Icon(
              Icons.inventory_2_rounded,
              size: 110,
              color: AppColors.primary,
            ),
            const SizedBox(height: 20),
            const Text(
              'Your watchlist is empty',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Discover amazing shows and save\nthem here to watch later.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onExploreTap,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 36,
                  vertical: 12,
                ),
              ),
              child: const Text('Explore Shows'),
            ),
          ],
        ),
      ),
    );
  }
}
