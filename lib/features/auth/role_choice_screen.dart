import 'package:flutter/material.dart';
import 'package:ma3adna/core/theme/app_icons.dart';
import 'package:go_router/go_router.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/router/routes.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/models.dart';

/// Splash (brief brand moment) that reveals the role choice.
class RoleChoiceScreen extends StatefulWidget {
  const RoleChoiceScreen({super.key});

  @override
  State<RoleChoiceScreen> createState() => _RoleChoiceScreenState();
}

class _RoleChoiceScreenState extends State<RoleChoiceScreen> {
  bool _showChoice = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) setState(() => _showChoice = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutCubic,
                alignment:
                    _showChoice ? const Alignment(0, .2) : Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      // The ball rolls in once when the app opens.
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: const Duration(milliseconds: 900),
                        curve: Curves.easeOutBack,
                        builder: (_, v, child) => Transform.rotate(
                          angle: (1 - v) * -6.283,
                          child:
                              Transform.scale(scale: .4 + .6 * v, child: child),
                        ),
                        child: Icon(AppIcons.ball,
                            size: 60, color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(S.appName,
                        style: t.headlineMedium
                            ?.copyWith(color: Colors.white, fontSize: 28)),
                    Text(S.appTagline,
                        style: t.bodyLarge?.copyWith(color: Colors.white70)),
                  ],
                ),
              ),
            ),
            AnimatedSlide(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              offset: _showChoice ? Offset.zero : const Offset(0, 1),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: _showChoice ? 1 : 0,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(32)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(S.welcome,
                          style: t.titleLarge, textAlign: TextAlign.center),
                      Text(S.chooseRole,
                          style:
                              t.bodyLarge?.copyWith(color: AppColors.inkMuted),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 20),
                      _RoleCard(
                        icon: AppIcons.player,
                        title: S.iAmPlayer,
                        subtitle: S.iAmPlayerHint,
                        onTap: () =>
                            context.push(Routes.login(UserRole.player)),
                      ),
                      const SizedBox(height: 12),
                      _RoleCard(
                        icon: AppIcons.owner,
                        title: S.iAmOwner,
                        subtitle: S.iAmOwnerHint,
                        onTap: () => context.push(Routes.login(UserRole.owner)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: AppColors.border, width: 1.5),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, size: 24, color: AppColors.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: t.titleLarge),
                    Text(subtitle,
                        style:
                            t.bodyMedium?.copyWith(color: AppColors.inkMuted)),
                  ],
                ),
              ),
              Icon(AppIcons.forward, size: 20, color: AppColors.inkFaint),
            ],
          ),
        ),
      ),
    );
  }
}
