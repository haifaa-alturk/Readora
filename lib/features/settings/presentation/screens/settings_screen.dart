// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:library_app1/features/settings/presentation/bloc/settings_bloc.dart';
// import 'package:library_app1/features/settings/presentation/bloc/settings_event.dart';
// import 'package:library_app1/features/settings/presentation/bloc/settings_state.dart';

// class SettingsScreen extends StatefulWidget {
//   const SettingsScreen({super.key});

//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<SettingsBloc>().add(const LoadSettingsEvent());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//             backgroundColor: const Color(0xfffcfbfa),
//             appBar: AppBar(
//               backgroundColor: const Color(0xfffcfbfa),
//               elevation: 0,
//               title: const Text(
//                 'Settings',
//                 style: TextStyle(
//                   color: Color(0xff2d2d2d),
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//             body: BlocConsumer<SettingsBloc, SettingsState>(
//               listenWhen: (previous, current) =>
//                   current is SettingsError || current is LoggedOut,
//               listener: (context, state) {
//                 if (state is SettingsError) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text(state.message)),
//                   );
//                 } else if (state is LoggedOut) {
//                   Navigator.of(context).popUntil((route) => route.isFirst);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Logged out successfully')),
//                   );
//                 }
//               },
//               builder: (context, state) {
//                 if (state is SettingsLoading) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (state is SettingsError) {
//                   return Center(
//                     child: Text(
//                       state.message,
//                       style: const TextStyle(color: Color(0xff2d2d2d)),
//                     ),
//                   );
//                 }
//                 if (state is SettingsLoaded || state is LoggedOut) {
//                   final settings = state is SettingsLoaded ? state.settings : null;

//                   return Center(
//                     child: SingleChildScrollView(
//                       child: Padding(
//                           padding: const EdgeInsets.all(16),
//                           child: Column(
//                             children: [
//                               _buildAccountSection(),
//                               const SizedBox(height: 16),
//                               if (settings != null)
//                                 _buildNotificationsSection(settings.notificationsEnabled),
//                               const SizedBox(height: 16),
//                               _buildPreferencesSection(),
//                               const SizedBox(height: 16),
//                               _buildPrivacySection(),
//                               const SizedBox(height: 24),
//                               _buildLogoutButton(),
//                               const SizedBox(height: 24),
//                             ],
//                           ),
//                         ),
//                       ),
//                   );
//                 }
//                 return const Center(child: CircularProgressIndicator());
//               },
//             ),
//     );
//   }

//   Widget _buildSectionCard(List<Widget> children) {
//     return Container(
//       width: double.infinity,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xff2d2d2d).withValues(alpha: 0.04),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(children: children),
//     );
//   }

//   Widget _buildRowTile({
//     required IconData icon,
//     required String title,
//     String? subtitle,
//     Widget? trailing,
//     VoidCallback? onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(16),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         child: Row(
//           children: [
//             Icon(icon, size: 22, color: const Color(0xff2d2d2d).withValues(alpha: 0.6)),
//             const SizedBox(width: 14),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: const TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w500,
//                       color: Color(0xff2d2d2d),
//                     ),
//                   ),
//                   if (subtitle != null)
//                     Padding(
//                       padding: const EdgeInsets.only(top: 2),
//                       child: Text(
//                         subtitle,
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: const Color(0xff2d2d2d).withValues(alpha: 0.6),
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//             if (trailing != null) trailing,
//             if (onTap != null && trailing == null)
//               Icon(
//                 Icons.chevron_right,
//                 size: 20,
//                 color: const Color(0xff2d2d2d).withValues(alpha: 0.3),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionDivider() {
//     return Divider(
//       height: 1,
//       thickness: 1,
//       indent: 16,
//       endIndent: 16,
//       color: const Color(0xff2d2d2d).withValues(alpha: 0.06),
//     );
//   }

//   Widget _buildAccountSection() {
//     return _buildSectionCard([
//       _buildRowTile(
//         icon: Icons.person_outline,
//         title: 'Account Settings',
//         subtitle: 'Edit your name, email, and profile photo',
//         onTap: () {
//           // TODO: Navigate to EditProfileScreen when Profile feature is available
//         },
//       ),
//     ]);
//   }

//   Widget _buildNotificationsSection(bool enabled) {
//     return _buildSectionCard([
//       _buildRowTile(
//         icon: Icons.notifications_outlined,
//         title: 'Notifications',
//         trailing: Switch(
//           value: enabled,
//           activeTrackColor: const Color(0xffe61b72).withValues(alpha: 0.4),
//           activeThumbColor: const Color(0xffe61b72),
//           onChanged: (_) {
//             context.read<SettingsBloc>().add(const ToggleNotificationsEvent());
//           },
//         ),
//       ),
//     ]);
//   }

//   Widget _buildPreferencesSection() {
//     return _buildSectionCard([
//       _buildRowTile(
//         icon: Icons.language,
//         title: 'Language',
//         subtitle: 'English',
//       ),
//       _buildSectionDivider(),
//       _buildRowTile(
//         icon: Icons.dark_mode_outlined,
//         title: 'Dark Mode',
//         subtitle: 'Coming soon',
//       ),
//     ]);
//   }

//   Widget _buildPrivacySection() {
//     return _buildSectionCard([
//       _buildRowTile(
//         icon: Icons.privacy_tip_outlined,
//         title: 'Privacy Policy',
//       ),
//       _buildSectionDivider(),
//       _buildRowTile(
//         icon: Icons.description_outlined,
//         title: 'Terms of Service',
//       ),
//     ]);
//   }

//   Widget _buildLogoutButton() {
//     return SizedBox(
//       width: double.infinity,
//       height: 50,
//       child: OutlinedButton.icon(
//         onPressed: () {
//           context.read<SettingsBloc>().add(const LogoutRequested());
//         },
//         icon: const Icon(Icons.logout, size: 20),
//         label: const Text(
//           'Logout',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         style: OutlinedButton.styleFrom(
//           foregroundColor: const Color(0xffe61b72),
//           side: const BorderSide(color: Color(0xffe61b72), width: 1.5),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:library_app1/core/language/app_localizations.dart';
import 'package:library_app1/features/auth/presentation/pages/login_page.dart';

// 🔴 استيراد ملف الترجمة
// import 'package:library_app1/core/utils/app_localizations.dart'; // عدلي المسار بحسب موقع الملف لديك

import 'package:library_app1/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:library_app1/features/profile/presentation/bloc/profile_state.dart';
import 'package:library_app1/features/profile/presentation/screens/edit_profile_screen.dart';

import 'package:library_app1/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:library_app1/features/settings/presentation/bloc/settings_event.dart';
import 'package:library_app1/features/settings/presentation/bloc/settings_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(const LoadSettingsEvent());
  }

  @override
  Widget build(BuildContext context) {
    // 💡 الحصول على اللغة الحالية لاستخدامها في الترجمة
    final settingsState = context.watch<SettingsBloc>().state;
    final lang = settingsState is SettingsLoaded ? settingsState.language : 'en';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          context.tr('settings', lang),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listenWhen: (previous, current) =>
            current is SettingsError || current is LoggedOut,
        listener: (context, state) {
          if (state is SettingsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is LoggedOut) {
            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => LoginScreen()),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is SettingsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SettingsLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildAccountSection(lang),
                  const SizedBox(height: 16),
                  _buildNotificationsSection(state.settings.notificationsEnabled, lang),
                  const SizedBox(height: 16),
                  _buildPreferencesSection(state.language, state.isDarkMode, lang),
                  const SizedBox(height: 16),
                  _buildPrivacySection(lang),
                  const SizedBox(height: 24),
                  _buildLogoutButton(lang),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildSectionCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildRowTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                ],
              ),
            ),
            if (trailing != null) trailing,
            if (onTap != null && trailing == null)
              const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSection(String lang) {
    return _buildSectionCard([
      _buildRowTile(
        icon: Icons.person_outline,
        title: context.tr('account_settings', lang),
        subtitle: context.tr('edit_profile_desc', lang),
        onTap: () {
          final profileState = context.read<ProfileBloc>().state;
          if (profileState is ProfileLoaded) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditProfileScreen(profile: profileState.profile),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile data is still loading...')),
            );
          }
        },
      ),
    ]);
  }

  Widget _buildNotificationsSection(bool enabled, String lang) {
    return _buildSectionCard([
      _buildRowTile(
        icon: Icons.notifications_outlined,
        title: context.tr('notifications', lang),
        trailing: Switch(
          value: enabled,
          activeColor: const Color(0xffe61b72),
          onChanged: (_) {
            context.read<SettingsBloc>().add(const ToggleNotificationsEvent());
          },
        ),
      ),
    ]);
  }

  Widget _buildPreferencesSection(String currentLanguage, bool isDarkMode, String lang) {
    return _buildSectionCard([
      _buildRowTile(
        icon: Icons.language,
        title: context.tr('language', lang),
        subtitle: currentLanguage == 'ar' ? 'العربية' : 'English',
        onTap: _showLanguageDialog,
      ),
      const Divider(height: 1, indent: 16, endIndent: 16),
      _buildRowTile(
        icon: Icons.dark_mode_outlined,
        title: context.tr('dark_mode', lang),
        trailing: Switch(
          value: isDarkMode,
          activeColor: const Color(0xffe61b72),
          onChanged: (val) {
            context.read<SettingsBloc>().add(ToggleThemeEvent(val));
          },
        ),
      ),
    ]);
  }

  Widget _buildPrivacySection(String lang) {
    return _buildSectionCard([
      _buildRowTile(
        icon: Icons.privacy_tip_outlined,
        title: context.tr('privacy_policy', lang),
        onTap: () => _showDialog(
          context.tr('privacy_policy', lang),
          'Your data is safe and protected.',
        ),
      ),
      const Divider(height: 1, indent: 16, endIndent: 16),
      _buildRowTile(
        icon: Icons.description_outlined,
        title: context.tr('terms_of_service', lang),
        onTap: () => _showDialog(
          context.tr('terms_of_service', lang),
          'Welcome to Readora App.',
        ),
      ),
    ]);
  }

  Widget _buildLogoutButton(String lang) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: OutlinedButton.icon(
        onPressed: () {
          context.read<SettingsBloc>().add(const LogoutRequested());
        },
        icon: const Icon(Icons.logout, size: 20),
        label: Text(
          context.tr('logout', lang),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xffe61b72),
          side: const BorderSide(color: Color(0xffe61b72), width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Select Language / اختر اللغة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              onTap: () {
                context.read<SettingsBloc>().add(const ChangeLanguageEvent('en'));
                Navigator.pop(dialogContext);
              },
            ),
            ListTile(
              title: const Text('العربية'),
              onTap: () {
                context.read<SettingsBloc>().add(const ChangeLanguageEvent('ar'));
                Navigator.pop(dialogContext);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }
}