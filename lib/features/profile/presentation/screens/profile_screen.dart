import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../watchlist/presentation/bloc/watchlist_bloc.dart';
import '../../../watchlist/presentation/bloc/watchlist_state.dart';

/// Simple profile page. It reads the watchlist count from WatchlistBloc.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 16),
          const CircleAvatar(
            radius: 48,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.person, size: 56, color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            'TV Explorer',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Discover. Explore. Save.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          BlocBuilder<WatchlistBloc, WatchlistState>(
            builder: (context, state) {
              final count = state is WatchlistLoaded ? state.shows.length : 0;
              return _ProfileTile(
                icon: Icons.favorite,
                title: 'Shows in watchlist',
                trailing: '$count',
              );
            },
          ),
          const _ProfileTile(
            icon: Icons.api,
            title: 'Data source',
            trailing: 'TVMaze API',
          ),
          const _ProfileTile(
            icon: Icons.info_outline,
            title: 'App version',
            trailing: '1.0.0',
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String trailing;

  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        trailing: Text(
          trailing,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}
