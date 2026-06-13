import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AvatarData {
  final String id;
  final String name;
  final Color bgColor;
  final IconData icon;
  final String emoji;

  const AvatarData({
    required this.id,
    required this.name,
    required this.bgColor,
    required this.icon,
    required this.emoji,
  });
}

final List<AvatarData> avatarOptions = [
  AvatarData(
    id: 'natural',
    name: 'Natural',
    bgColor: const Color(0xFFFFE4D6),
    icon: Icons.face_3,
    emoji: '👩',
  ),
  AvatarData(
    id: 'hijab',
    name: 'Hijab',
    bgColor: const Color(0xFFE8E0F0),
    icon: Icons.face_4,
    emoji: '🧕',
  ),
  AvatarData(
    id: 'short_hair',
    name: 'Short Hair',
    bgColor: const Color(0xFFFFF0E0),
    icon: Icons.face_5,
    emoji: '👩‍🦰',
  ),
  AvatarData(
    id: 'long_curly',
    name: 'Long Curly',
    bgColor: const Color(0xFFFCE4EC),
    icon: Icons.face_6,
    emoji: '👩‍🦱',
  ),
  AvatarData(
    id: 'glasses',
    name: 'Glasses',
    bgColor: const Color(0xFFE0F2FE),
    icon: Icons.face,
    emoji: '👓',
  ),
  AvatarData(
    id: 'afro',
    name: 'Afro',
    bgColor: const Color(0xFFFFE0B2),
    icon: Icons.face_2,
    emoji: '👩🏾',
  ),
  AvatarData(
    id: 'ponytail',
    name: 'Ponytail',
    bgColor: const Color(0xFFF3E5F5),
    icon: Icons.face_3,
    emoji: '👩‍🦳',
  ),
  AvatarData(
    id: 'bob_cut',
    name: 'Bob Cut',
    bgColor: const Color(0xFFE8F5E9),
    icon: Icons.face_4,
    emoji: '👩',
  ),
  AvatarData(
    id: 'braids',
    name: 'Braids',
    bgColor: const Color(0xFFFFF3E0),
    icon: Icons.face_5,
    emoji: '👩🏽',
  ),
  AvatarData(
    id: 'wavy',
    name: 'Wavy Hair',
    bgColor: const Color(0xFFFCE4EC),
    icon: Icons.face_6,
    emoji: '👩‍🦰',
  ),
  AvatarData(
    id: 'pixie',
    name: 'Pixie Cut',
    bgColor: const Color(0xFFE1F5FE),
    icon: Icons.face,
    emoji: '👩🏻',
  ),
  AvatarData(
    id: 'bun',
    name: 'Bun Style',
    bgColor: const Color(0xFFFFF8E1),
    icon: Icons.face_2,
    emoji: '👩‍🦳',
  ),
];

class AvatarPicker extends StatelessWidget {
  final String? selectedId;
  final ValueChanged<String> onSelected;

  const AvatarPicker({super.key, this.selectedId, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Text('🎀', style: TextStyle(fontSize: 18)),
              SizedBox(width: 6),
              Text(
                'Choose your avatar',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            itemCount: avatarOptions.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final avatar = avatarOptions[index];
              final isSelected = selectedId == avatar.id;
              return GestureDetector(
                onTap: () => onSelected(avatar.id),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutBack,
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        avatar.bgColor,
                        avatar.bgColor.withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.crimsonHeart
                          : Colors.transparent,
                      width: 3,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.crimsonHeart.withValues(
                                alpha: 0.3,
                              ),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Center(
                        child: Transform.scale(
                          scale: isSelected ? 1.1 : 1.0,
                          child: Text(
                            avatar.emoji,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                      if (isSelected)
                        Positioned(
                          right: -4,
                          bottom: -4,
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                              color: AppColors.crimsonHeart,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class AvatarCircle extends StatelessWidget {
  final String? avatarId;
  final double size;
  final bool showOnlineDot;
  final bool showEditBadge;
  final VoidCallback? onEdit;

  const AvatarCircle({
    super.key,
    this.avatarId,
    this.size = 42,
    this.showOnlineDot = false,
    this.showEditBadge = false,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = avatarOptions.where((a) => a.id == avatarId).firstOrNull;

    return SizedBox(
      width: size + 4,
      height: size + 4,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.roseBlush, AppColors.crimsonHeart],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.roseBlush.withValues(alpha: 0.3),
                  blurRadius: 8,
                ),
              ],
            ),
            padding: const EdgeInsets.all(2),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: avatar?.bgColor ?? AppColors.cardSoft,
              ),
              child: Center(
                child: avatar != null
                    ? Text(
                        avatar.emoji,
                        style: TextStyle(fontSize: size * 0.45),
                      )
                    : Icon(
                        Icons.person_rounded,
                        color: AppColors.textLight,
                        size: size * 0.5,
                      ),
              ),
            ),
          ),
          if (showOnlineDot)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.goldenGlow,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.cardSurface, width: 2),
                ),
              ),
            ),
          if (showEditBadge)
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: onEdit,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: AppColors.crimsonHeart,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
