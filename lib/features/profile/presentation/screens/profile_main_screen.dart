import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app1/core/language/app_localizations.dart';

import 'package:library_app1/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:library_app1/features/profile/presentation/bloc/profile_state.dart';
import 'package:library_app1/features/profile/presentation/bloc/purchase_history_bloc.dart';
import 'package:library_app1/features/profile/domain/entities/profile_entity.dart';
import 'package:library_app1/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:library_app1/features/profile/presentation/screens/purchase_history_screen.dart';
import 'package:library_app1/features/interests/presentation/bloc/interests_bloc.dart';
import 'package:library_app1/features/interests/presentation/screens/interests_screen.dart';
import 'package:library_app1/features/library/presentation/bloc/library_bloc.dart';
import 'package:library_app1/features/library/presentation/screens/library_screen.dart';
import 'package:library_app1/features/points/presentation/bloc/points_bloc.dart';
import 'package:library_app1/features/points/presentation/bloc/points_state.dart';
import 'package:library_app1/features/points/presentation/screens/points_screen.dart'
    as points_feature;
import 'package:library_app1/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:library_app1/features/settings/presentation/bloc/settings_state.dart';
import 'package:library_app1/features/settings/presentation/screens/settings_screen.dart';
import 'package:library_app1/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:library_app1/features/wallet/presentation/screens/wallet_screen.dart'
    as wallet_feature;
import 'package:library_app1/features/wins/presentation/bloc/wins_bloc.dart';
import 'package:library_app1/features/wins/presentation/screens/wins_screen.dart';
import 'package:library_app1/features/quotes/presentation/screens/my_quotes_screen.dart';

const String _profileImageBaseUrl = 'http://10.66.254.50:8000/storage/';

bool _isLocalImagePath(String path) {
  return path.startsWith('/') ||
      path.startsWith('file://') ||
      RegExp(r'^[A-Za-z]:[\\/]').hasMatch(path);
}

String _resolveProfileImageUrl(String path) {
  if (path.startsWith('http://') || path.startsWith('https://')) return path;

  final normalized = path.startsWith('/') ? path.substring(1) : path;

  return '$_profileImageBaseUrl$normalized';
}

class ProfileMainScreen extends StatelessWidget {
  const ProfileMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsState = context.watch<SettingsBloc>().state;

    final lang = settingsState is SettingsLoaded
        ? settingsState.language
        : 'en';

    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            title: Text(
              context.tr('my_profile', lang),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            actions: [
              if (state is ProfileLoaded)
                IconButton(
                  icon: const Icon(Icons.settings, color: Color(0xfffbc4db)),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<SettingsBloc>(),
                        child: const SettingsScreen(),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          body: _buildBody(context, state, lang),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ProfileState state, String lang) {
    if (state is ProfileLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ProfileError) {
      return Center(child: Text(state.message, style: const TextStyle()));
    }

    if (state is ProfileLoaded) {
      return _buildProfileContent(context, state.profile, lang);
    }

    if (state is ProfileUpdateSuccess) {
      return _buildProfileContent(context, state.profile, lang);
    }

    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildProfileContent(
    BuildContext context,
    ProfileEntity profile,
    String lang,
  ) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(profile),
            const SizedBox(height: 24),
            _buildStatsCard(profile, lang),
            const SizedBox(height: 20),
            _buildQuickLinksSection(context, lang),
            const SizedBox(height: 24),
            _buildProfileEditButton(profile, lang),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ProfileEntity profile) {
    return Builder(
      builder: (context) {
        final pointsState = context.watch<PointsBloc>().state;

        final livePoints = pointsState is PointsLoaded
            ? pointsState.totalPoints
            : profile.points;

        return Column(
          children: [
            Hero(
              tag: 'profile_pic',
              child: GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FullScreenImage(
                      imagePath: profile.imagePath,
                      name: profile.name,
                    ),
                  ),
                ),
                child: Container(
                  width: 132,
                  height: 132,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xfffbc4db).withValues(alpha: 0.85),
                        const Color(0xfffbc4db).withValues(alpha: 0.0),
                      ],
                      stops: const [0.35, 1.0],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xfffbc4db).withValues(alpha: 0.55),
                        blurRadius: 30,
                        spreadRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor: const Color(0xfffbc4db),
                    child: ClipOval(
                      child: _buildProfileAvatarContent(
                        imagePath: profile.imagePath,
                        diameter: 96,
                        fallback: Text(
                          profile.name.isNotEmpty
                              ? profile.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              profile.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(profile.email, style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 10),
            _buildLevelBadge(ProfileEntity.levelForPoints(livePoints)),
          ],
        );
      },
    );
  }

  Widget _buildLevelBadge(String level) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xffd4c5f9).withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        level,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Color(0xff7c5cbf),
        ),
      ),
    );
  }

  Widget _buildProfileAvatarContent({
    required String? imagePath,
    required double diameter,
    required Widget fallback,
  }) {
    if (imagePath == null || imagePath.trim().isEmpty) {
      return SizedBox(
        width: diameter,
        height: diameter,
        child: Center(child: fallback),
      );
    }

    if (_isLocalImagePath(imagePath)) {
      return Image.file(
        File(imagePath),
        width: diameter,
        height: diameter,
        fit: BoxFit.cover,
      );
    }

    return Image.network(
      _resolveProfileImageUrl(imagePath),
      width: diameter,
      height: diameter,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return SizedBox(
          width: diameter,
          height: diameter,
          child: const Center(child: Icon(Icons.person, size: 42)),
        );
      },
    );
  }

  Widget _buildProfileEditButton(ProfileEntity profile, String lang) {
    return Builder(
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: SizedBox(
          width: double.infinity,
          height: 44,
          child: OutlinedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<ProfileBloc>(),
                  child: EditProfileScreen(profile: profile),
                ),
              ),
            ),
            icon: const Icon(Icons.edit_outlined, size: 20),
            label: Text(
              context.tr('edit_profile', lang),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xfff9aabf), width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard(ProfileEntity profile, String lang) {
    return Builder(
      builder: (context) {
        final pointsState = context.watch<PointsBloc>().state;

        final livePoints = pointsState is PointsLoaded
            ? pointsState.totalPoints
            : profile.points;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          elevation: 0,
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color.fromARGB(255, 82, 2, 89).withOpacity(0.5)
              : const Color.fromARGB(255, 236, 212, 186).withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _statItem(
                  Icons.stars,
                  '$livePoints',
                  context.tr('points', lang),
                  const Color.fromARGB(255, 182, 61, 93),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<PointsBloc>(),
                        child: const points_feature.PointsScreen(),
                      ),
                    ),
                  ),
                ),
                _statItem(
                  Icons.menu_book,
                  '${profile.booksCount}',
                  context.tr('books', lang),
                  const Color.fromARGB(255, 87, 16, 128),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<LibraryBloc>(),
                        child: const LibraryScreen(),
                      ),
                    ),
                  ),
                ),
                _statItem(
                  Icons.account_balance_wallet,
                  '${profile.walletBalance} ${context.tr('syp', lang)}',
                  context.tr('wallet', lang),
                  const Color.fromARGB(255, 54, 159, 47),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: context.read<WalletBloc>(),
                        child: const wallet_feature.WalletScreen(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _statItem(
    IconData icon,
    String value,
    String label,
    Color color, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickLinksSection(BuildContext context, String lang) {
    final links = [
      _QuickLink(
        context.tr('my_purchases', lang),
        Icons.receipt_long,
        const Color(0xff2d2d2d),
        const Color(0xffd4c5f9),
      ),
      _QuickLink(
        context.tr('my_quotes', lang),
        Icons.format_quote,
        const Color(0xff2d2d2d),
        const Color.fromARGB(255, 234, 156, 215),
      ),
      _QuickLink(
        context.tr('my_wins', lang),
        Icons.emoji_events,
        const Color(0xff2d2d2d),
        const Color.fromARGB(255, 192, 238, 188),
      ),
      _QuickLink(
        context.tr('my_interests', lang),
        Icons.local_activity,
        const Color(0xff2d2d2d),
        const Color.fromARGB(255, 118, 173, 227),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              context.tr('quick_links', lang),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: links.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.6,
            ),
            itemBuilder: (context, index) {
              final link = links[index];

              return Container(
                decoration: BoxDecoration(
                  color: link.backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        80,
                        79,
                        79,
                      ).withValues(alpha: 0.55),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        92,
                        92,
                        92,
                      ).withValues(alpha: 0.35),
                      blurRadius: 1,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      if (index == 0) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<PurchaseHistoryBloc>(),
                              child: const PurchaseHistoryScreen(),
                            ),
                          ),
                        );
                      } else if (index == 1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MyQuotesScreen(),
                          ),
                        );
                      } else if (index == 2) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<WinsBloc>(),
                              child: const WinsScreen(),
                            ),
                          ),
                        );
                      } else if (index == 3) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<InterestsBloc>(),
                              child: const InterestsScreen(),
                            ),
                          ),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(link.icon, color: link.color, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          link.label,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff2d2d2d),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _QuickLink {
  final String label;
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  const _QuickLink(this.label, this.icon, this.color, this.backgroundColor);
}

class PointsScreen extends StatelessWidget {
  final int points;

  const PointsScreen({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffcfbfa),
      appBar: AppBar(
        backgroundColor: const Color(0xfffcfbfa),
        elevation: 0,
        title: const Text('Points', style: TextStyle(color: Color(0xff2d2d2d))),
      ),
      body: Center(
        child: Text(
          'Your Points: $points',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}

class ReadBooksScreen extends StatelessWidget {
  final int booksCount;

  const ReadBooksScreen({super.key, required this.booksCount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffcfbfa),
      appBar: AppBar(
        backgroundColor: const Color(0xfffcfbfa),
        elevation: 0,
        title: const Text(
          'Read Books',
          style: TextStyle(color: Color(0xff2d2d2d)),
        ),
      ),
      body: Center(
        child: Text(
          'Books Read: $booksCount',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}

class WalletScreen extends StatelessWidget {
  final double walletBalance;

  const WalletScreen({super.key, required this.walletBalance});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffcfbfa),
      appBar: AppBar(
        backgroundColor: const Color(0xfffcfbfa),
        elevation: 0,
        title: const Text('Wallet', style: TextStyle(color: Color(0xff2d2d2d))),
      ),
      body: Center(
        child: Text(
          'Your Balance: $walletBalance SYP',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String? imagePath;
  final String name;

  const FullScreenImage({
    super.key,
    required this.imagePath,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(name, style: const TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: imagePath != null && imagePath!.trim().isNotEmpty
            ? InteractiveViewer(
                child: _isLocalImagePath(imagePath!)
                    ? Image.file(File(imagePath!), fit: BoxFit.contain)
                    : Image.network(
                        _resolveProfileImageUrl(imagePath!),
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.broken_image_outlined,
                                color: Colors.white70,
                                size: 64,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Image unavailable',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: const Color(0xfff9aabf),
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff2d2d2d),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No profile image set',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
      ),
    );
  }
}
