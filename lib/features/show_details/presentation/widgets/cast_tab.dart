import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/poster_image.dart';
import '../../domain/entities/cast_member.dart';

/// Tab 3: list of actors and their characters.
class CastTab extends StatelessWidget {
  final List<CastMember> cast;

  const CastTab({super.key, required this.cast});

  @override
  Widget build(BuildContext context) {
    if (cast.isEmpty) {
      return const EmptyView(
        icon: Icons.people_outline,
        title: 'No cast information',
        message: 'Cast details are not available for this show.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: cast.length,
      separatorBuilder: (context, index) =>
          const Divider(height: 1, indent: 16, color: AppColors.border),
      itemBuilder: (context, index) {
        final member = cast[index];
        return ListTile(
          onTap: () => _showMember(context, member),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 2,
          ),
          leading: PosterImage(
            imageUrl: member.imageUrl,
            width: 46,
            height: 46,
            borderRadius: 6,
            placeholderIcon: Icons.person,
          ),
          title: Text(
            member.personName,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          subtitle: Text(
            member.characterName,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: AppColors.textSecondary,
          ),
        );
      },
    );
  }

  /// Bigger photo of the actor in a bottom sheet.
  void _showMember(BuildContext context, CastMember member) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            PosterImage(
              imageUrl: member.imageUrl,
              width: 90,
              height: 120,
              placeholderIcon: Icons.person,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.personName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'as ${member.characterName}',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
