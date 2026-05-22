import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vynt/controllers/theme_controller.dart';
import 'package:vynt/screens/login_pages/main_login_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// ───────────────────────────────────────────────
// Entry point
// ───────────────────────────────────────────────

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  // ── Notification toggles ──
  bool _notifyLikes = true;
  bool _notifyComments = true;
  bool _notifyFollowers = true;
  bool _notifyMessages = true;
  bool _notifyListeningParty = true;

  // ── Privacy ──
  bool _privateAccount = false;
  bool _showListeningActivity = true;
  bool _allowTagging = true;

  // ── Playback / Music ──
  bool _autoplayVideos = true;
  bool _highQualityStreaming = false;
  bool _showLyrics = true;

  // ── Music services connected ──
  bool _spotifyConnected = false;
  bool _appleMusicConnected = false;

  // ── App appearance ──
  String _selectedLanguage = 'English';

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<String> _languages = [
    'English',
    'Italiano',
    'Español',
    'Français',
    'Deutsch',
    'Português',
    '日本語',
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _notifyLikes = prefs.getBool('notifyLikes') ?? true;
      _notifyComments = prefs.getBool('notifyComments') ?? true;
      _notifyFollowers = prefs.getBool('notifyFollowers') ?? true;
      _notifyMessages = prefs.getBool('notifyMessages') ?? true;
      _notifyListeningParty = prefs.getBool('notifyListeningParty') ?? true;
      _privateAccount = prefs.getBool('privateAccount') ?? false;
      _showListeningActivity =
          prefs.getBool('showListeningActivity') ?? true;
      _allowTagging = prefs.getBool('allowTagging') ?? true;
      _autoplayVideos = prefs.getBool('autoplayVideos') ?? true;
      _highQualityStreaming = prefs.getBool('highQualityStreaming') ?? false;
      _showLyrics = prefs.getBool('showLyrics') ?? true;
      _spotifyConnected = prefs.getBool('spotifyConnected') ?? false;
      _appleMusicConnected = prefs.getBool('appleMusicConnected') ?? false;
      _selectedLanguage = prefs.getString('language') ?? 'English';
    });
  }

  Future<void> _saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  // ────────────────────────────────────────────
  // Logout
  // ────────────────────────────────────────────
  Future<void> _logout() async {
    final confirmed = await _showConfirmDialog(
      title: 'Log Out',
      message: 'Are you sure you want to log out of Vynt?',
      confirmLabel: 'Log Out',
      isDestructive: true,
    );
    if (confirmed != true) return;
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainLoginPage()),
      (_) => false,
    );
  }

  // ────────────────────────────────────────────
  // Delete account with Re-Authentication Flow
  // ────────────────────────────────────────────
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  void _showLoadingDialog(String message) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CupertinoAlertDialog(
        content: Row(
          children: [
            const CupertinoActivityIndicator(),
            const SizedBox(width: 16),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }

  Future<String?> _promptForPassword() async {
    final TextEditingController passwordController = TextEditingController();
    return showCupertinoDialog<String>(
      context: context,
      builder: (ctx) {
        return CupertinoAlertDialog(
          title: const Text('Enter Password'),
          content: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'For security reasons, please confirm your password to delete your account.',
                  style: TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 12),
                CupertinoTextField(
                  controller: passwordController,
                  obscureText: true,
                  placeholder: 'Password',
                  style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                  placeholderStyle: const TextStyle(color: Colors.grey),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(ctx, null),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text('Confirm'),
              onPressed: () => Navigator.pop(ctx, passwordController.text),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _promptGoogleReauth() async {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) {
        return CupertinoAlertDialog(
          title: const Text('Google Sign-In Required'),
          content: const Text('To delete your account, you must re-authenticate using your Google account.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(ctx, false),
            ),
            CupertinoDialogAction(
              child: const Text('Sign In'),
              onPressed: () => Navigator.pop(ctx, true),
            ),
          ],
        );
      },
    );
    return confirmed ?? false;
  }

  Future<bool> _promptAppleReauth() async {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) {
        return CupertinoAlertDialog(
          title: const Text('Apple Sign-In Required'),
          content: const Text('To delete your account, you must re-authenticate using your Apple account.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(ctx, false),
            ),
            CupertinoDialogAction(
              child: const Text('Sign In'),
              onPressed: () => Navigator.pop(ctx, true),
            ),
          ],
        );
      },
    );
    return confirmed ?? false;
  }

  Future<void> _deleteAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final confirmed = await _showConfirmDialog(
      title: 'Delete Account',
      message:
          'This will permanently delete your Vynt account and all your data. This action cannot be undone.',
      confirmLabel: 'Delete Account',
      isDestructive: true,
    );
    if (confirmed != true) return;

    // Identify provider used to log in
    final providers = user.providerData.map((e) => e.providerId).toList();
    AuthCredential? credential;

    try {
      if (providers.contains('password')) {
        final password = await _promptForPassword();
        if (password == null || password.isEmpty) return;

        _showLoadingDialog('Re-authenticating...');
        credential = EmailAuthProvider.credential(
          email: user.email!,
          password: password,
        );
      } else if (providers.contains('google.com')) {
        final googleConfirm = await _promptGoogleReauth();
        if (!googleConfirm) return;

        _showLoadingDialog('Signing in with Google...');
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        if (googleAuth == null) {
          if (mounted) Navigator.pop(context); // dismiss loader
          return;
        }
        credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
      } else if (providers.contains('apple.com')) {
        final appleConfirm = await _promptAppleReauth();
        if (!appleConfirm) return;

        _showLoadingDialog('Signing in with Apple...');
        final rawNonce = generateNonce();
        final nonce = _sha256ofString(rawNonce);

        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: nonce,
        );

        credential = OAuthProvider("apple.com").credential(
          idToken: appleCredential.identityToken,
          rawNonce: rawNonce,
        );
      }

      if (credential != null) {
        await user.reauthenticateWithCredential(credential);
      }

      if (mounted) {
        // Dismiss loader dialog if it's still open
        Navigator.pop(context);
        _showLoadingDialog('Deleting account...');
      }

      await user.delete();

      if (mounted) {
        Navigator.pop(context); // dismiss loader
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your account has been deleted successfully.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MainLoginPage()),
          (_) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        Navigator.pop(context); // dismiss loader if open
        String errorMsg = 'An error occurred. Please try again.';
        if (e.code == 'wrong-password') {
          errorMsg = 'Incorrect password. Please try again.';
        } else if (e.code == 'requires-recent-login') {
          errorMsg = 'This action requires recent authentication. Please log in again.';
        } else if (e.code == 'user-mismatch') {
          errorMsg = 'The credentials entered do not match this account.';
        } else if (e.message != null) {
          errorMsg = e.message!;
        }

        showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
            title: const Text('Authentication Error'),
            content: Text(errorMsg),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(ctx),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // dismiss loader if open
        showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
            title: const Text('Error'),
            content: Text('Error: $e'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(ctx),
              ),
            ],
          ),
        );
      }
    }
  }

  // ────────────────────────────────────────────
  // Helpers
  // ────────────────────────────────────────────
  Future<bool?> _showConfirmDialog({
    required String title,
    required String message,
    required String confirmLabel,
    bool isDestructive = false,
  }) {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(ctx, false),
          ),
          CupertinoDialogAction(
            isDestructiveAction: isDestructive,
            child: Text(confirmLabel),
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker() {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (_) => Container(
        height: 280,
        color: Theme.of(context).colorScheme.secondary,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoButton(
                  child: const Text('Done'),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 40,
                scrollController: FixedExtentScrollController(
                  initialItem: _languages.indexOf(_selectedLanguage),
                ),
                onSelectedItemChanged: (i) {
                  setState(() => _selectedLanguage = _languages[i]);
                  _saveString('language', _languages[i]);
                },
                children:
                    _languages.map((l) => Center(child: Text(l))).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────────
  // Build
  // ────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final themeController = Provider.of<ThemeController>(context);
    final isDark = themeController.isDarkMode;

    // Accent colour taken from the app's tertiary (pink-magenta)
    final accent = colorScheme.tertiary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // ── AppBar ──────────────────────────────
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: textTheme.bodyLarge?.color),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: textTheme.titleLarge?.copyWith(fontSize: 20),
        ),
        centerTitle: true,
      ),
      // ── Body ────────────────────────────────
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── Profile card ──
            SliverToBoxAdapter(
              child: _ProfileCard(accent: accent),
            ),

            // ── Appearance ──
            _SectionHeader(label: 'Appearance', icon: CupertinoIcons.paintbrush_fill, accent: accent),
            SliverToBoxAdapter(
              child: _SettingsGroup(
                children: [
                  // Dark mode
                  _SettingsRow(
                    icon: isDark
                        ? CupertinoIcons.moon_fill
                        : CupertinoIcons.sun_max_fill,
                    iconColor: isDark ? Colors.indigo[300]! : Colors.amber,
                    label: 'Dark Mode',
                    trailing: CupertinoSwitch(
                      value: isDark,
                      activeTrackColor: accent,
                      onChanged: (v) {
                        HapticFeedback.lightImpact();
                        themeController.toggleTheme();
                      },
                    ),
                  ),
                  _Divider(),
                  // Language
                  _SettingsRow(
                    icon: CupertinoIcons.globe,
                    iconColor: Colors.blue[400]!,
                    label: 'Language',
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _selectedLanguage,
                          style: TextStyle(
                              color: textTheme.bodySmall?.color, fontSize: 14),
                        ),
                        const SizedBox(width: 4),
                        Icon(CupertinoIcons.chevron_right,
                            size: 14, color: textTheme.bodySmall?.color),
                      ],
                    ),
                    onTap: _showLanguagePicker,
                  ),
                ],
              ),
            ),

            // ── Music Services ──
            _SectionHeader(label: 'Music Services', icon: CupertinoIcons.music_note_2, accent: accent),
            SliverToBoxAdapter(
              child: _SettingsGroup(
                children: [
                  // Spotify
                  _SettingsRow(
                    customLeading: _ServiceIcon(
                      color: const Color(0xFF1DB954),
                      child: Image.asset(
                        'assets/test_pictures/icons/spotify.webp',
                        fit: BoxFit.contain,
                      ),
                    ),
                    label: 'Spotify',
                    subtitle: _spotifyConnected ? 'Connected' : 'Not connected',
                    trailing: _spotifyConnected
                        ? _ConnectedBadge(accent: const Color(0xFF1DB954))
                        : _ConnectButton(
                            label: 'Connect',
                            color: const Color(0xFF1DB954),
                            onTap: () {
                              HapticFeedback.lightImpact();
                              setState(() => _spotifyConnected = true);
                              _saveBool('spotifyConnected', true);
                            },
                          ),
                  ),
                  _Divider(),
                  // Apple Music
                  _SettingsRow(
                    customLeading: _ServiceIcon(
                      color: Colors.red[400]!,
                      child: Image.asset(
                        'assets/test_pictures/icons/apple_music.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    label: 'Apple Music',
                    subtitle: _appleMusicConnected
                        ? 'Connected'
                        : 'Not connected',
                    trailing: _appleMusicConnected
                        ? _ConnectedBadge(accent: Colors.red[400]!)
                        : _ConnectButton(
                            label: 'Connect',
                            color: Colors.red[400]!,
                            onTap: () {
                              HapticFeedback.lightImpact();
                              setState(() => _appleMusicConnected = true);
                              _saveBool('appleMusicConnected', true);
                            },
                          ),
                  ),
                ],
              ),
            ),

            // ── Playback ──
            _SectionHeader(label: 'Playback', icon: CupertinoIcons.play_circle_fill, accent: accent),
            SliverToBoxAdapter(
              child: _SettingsGroup(
                children: [
                  _SettingsRow(
                    icon: CupertinoIcons.play_rectangle_fill,
                    iconColor: Colors.purple[400]!,
                    label: 'Autoplay Videos',
                    trailing: CupertinoSwitch(
                      value: _autoplayVideos,
                      activeTrackColor: accent,
                      onChanged: (v) {
                        HapticFeedback.lightImpact();
                        setState(() => _autoplayVideos = v);
                        _saveBool('autoplayVideos', v);
                      },
                    ),
                  ),
                  _Divider(),
                  _SettingsRow(
                    icon: CupertinoIcons.hifispeaker_fill,
                    iconColor: Colors.teal[400]!,
                    label: 'High-Quality Streaming',
                    subtitle: 'Uses more data',
                    trailing: CupertinoSwitch(
                      value: _highQualityStreaming,
                      activeTrackColor: accent,
                      onChanged: (v) {
                        HapticFeedback.lightImpact();
                        setState(() => _highQualityStreaming = v);
                        _saveBool('highQualityStreaming', v);
                      },
                    ),
                  ),
                  _Divider(),
                  _SettingsRow(
                    icon: CupertinoIcons.text_quote,
                    iconColor: Colors.orange[400]!,
                    label: 'Show Lyrics',
                    trailing: CupertinoSwitch(
                      value: _showLyrics,
                      activeTrackColor: accent,
                      onChanged: (v) {
                        HapticFeedback.lightImpact();
                        setState(() => _showLyrics = v);
                        _saveBool('showLyrics', v);
                      },
                    ),
                  ),
                ],
              ),
            ),

            // ── Notifications ──
            _SectionHeader(label: 'Notifications', icon: CupertinoIcons.bell_fill, accent: accent),
            SliverToBoxAdapter(
              child: _SettingsGroup(
                children: [
                  _SettingsRow(
                    icon: CupertinoIcons.heart_fill,
                    iconColor: Colors.red[400]!,
                    label: 'Likes',
                    trailing: CupertinoSwitch(
                      value: _notifyLikes,
                      activeTrackColor: accent,
                      onChanged: (v) {
                        HapticFeedback.lightImpact();
                        setState(() => _notifyLikes = v);
                        _saveBool('notifyLikes', v);
                      },
                    ),
                  ),
                  _Divider(),
                  _SettingsRow(
                    icon: CupertinoIcons.chat_bubble_fill,
                    iconColor: Colors.blue[400]!,
                    label: 'Comments',
                    trailing: CupertinoSwitch(
                      value: _notifyComments,
                      activeTrackColor: accent,
                      onChanged: (v) {
                        HapticFeedback.lightImpact();
                        setState(() => _notifyComments = v);
                        _saveBool('notifyComments', v);
                      },
                    ),
                  ),
                  _Divider(),
                  _SettingsRow(
                    icon: CupertinoIcons.person_badge_plus_fill,
                    iconColor: Colors.green[400]!,
                    label: 'New Followers',
                    trailing: CupertinoSwitch(
                      value: _notifyFollowers,
                      activeTrackColor: accent,
                      onChanged: (v) {
                        HapticFeedback.lightImpact();
                        setState(() => _notifyFollowers = v);
                        _saveBool('notifyFollowers', v);
                      },
                    ),
                  ),
                  _Divider(),
                  _SettingsRow(
                    icon: CupertinoIcons.envelope_fill,
                    iconColor: Colors.indigo[400]!,
                    label: 'Direct Messages',
                    trailing: CupertinoSwitch(
                      value: _notifyMessages,
                      activeTrackColor: accent,
                      onChanged: (v) {
                        HapticFeedback.lightImpact();
                        setState(() => _notifyMessages = v);
                        _saveBool('notifyMessages', v);
                      },
                    ),
                  ),
                  _Divider(),
                  _SettingsRow(
                    icon: CupertinoIcons.music_house_fill,
                    iconColor: Colors.pink[400]!,
                    label: 'Listening Parties',
                    trailing: CupertinoSwitch(
                      value: _notifyListeningParty,
                      activeTrackColor: accent,
                      onChanged: (v) {
                        HapticFeedback.lightImpact();
                        setState(() => _notifyListeningParty = v);
                        _saveBool('notifyListeningParty', v);
                      },
                    ),
                  ),
                ],
              ),
            ),

            // ── Privacy ──
            _SectionHeader(label: 'Privacy & Security', icon: CupertinoIcons.lock_fill, accent: accent),
            SliverToBoxAdapter(
              child: _SettingsGroup(
                children: [
                  _SettingsRow(
                    icon: CupertinoIcons.lock_shield_fill,
                    iconColor: Colors.blueGrey[400]!,
                    label: 'Private Account',
                    subtitle: 'Only approved followers see your posts',
                    trailing: CupertinoSwitch(
                      value: _privateAccount,
                      activeTrackColor: accent,
                      onChanged: (v) {
                        HapticFeedback.lightImpact();
                        setState(() => _privateAccount = v);
                        _saveBool('privateAccount', v);
                      },
                    ),
                  ),
                  _Divider(),
                  _SettingsRow(
                    icon: CupertinoIcons.music_note,
                    iconColor: Colors.purple[300]!,
                    label: 'Listening Activity',
                    subtitle: 'Let others see what you\'re playing',
                    trailing: CupertinoSwitch(
                      value: _showListeningActivity,
                      activeTrackColor: accent,
                      onChanged: (v) {
                        HapticFeedback.lightImpact();
                        setState(() => _showListeningActivity = v);
                        _saveBool('showListeningActivity', v);
                      },
                    ),
                  ),
                  _Divider(),
                  _SettingsRow(
                    icon: CupertinoIcons.tag_fill,
                    iconColor: Colors.cyan[400]!,
                    label: 'Allow Tagging',
                    subtitle: 'Friends can tag you in posts',
                    trailing: CupertinoSwitch(
                      value: _allowTagging,
                      activeTrackColor: accent,
                      onChanged: (v) {
                        HapticFeedback.lightImpact();
                        setState(() => _allowTagging = v);
                        _saveBool('allowTagging', v);
                      },
                    ),
                  ),
                  _Divider(),
                  _SettingsRow(
                    icon: CupertinoIcons.nosign,
                    iconColor: Colors.brown[400]!,
                    label: 'Blocked Accounts',
                    trailing: Icon(CupertinoIcons.chevron_right,
                        size: 14, color: textTheme.bodySmall?.color),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // ── Support ──
            _SectionHeader(label: 'Support', icon: CupertinoIcons.question_circle_fill, accent: accent),
            SliverToBoxAdapter(
              child: _SettingsGroup(
                children: [
                  _SettingsRow(
                    icon: CupertinoIcons.info_circle_fill,
                    iconColor: Colors.blue[300]!,
                    label: 'About Vynt',
                    trailing: Icon(CupertinoIcons.chevron_right,
                        size: 14, color: textTheme.bodySmall?.color),
                    onTap: () => _showAboutDialog(context, accent),
                  ),
                  _Divider(),
                  _SettingsRow(
                    icon: CupertinoIcons.doc_text_fill,
                    iconColor: Colors.grey[500]!,
                    label: 'Terms of Service',
                    trailing: Icon(CupertinoIcons.chevron_right,
                        size: 14, color: textTheme.bodySmall?.color),
                    onTap: () async {
                      final uri = Uri.parse('https://vynt.app/terms');
                      if (await canLaunchUrl(uri)) launchUrl(uri);
                    },
                  ),
                  _Divider(),
                  _SettingsRow(
                    icon: CupertinoIcons.shield_fill,
                    iconColor: Colors.grey[500]!,
                    label: 'Privacy Policy',
                    trailing: Icon(CupertinoIcons.chevron_right,
                        size: 14, color: textTheme.bodySmall?.color),
                    onTap: () async {
                      final uri = Uri.parse('https://vynt.app/privacy');
                      if (await canLaunchUrl(uri)) launchUrl(uri);
                    },
                  ),
                  _Divider(),
                  _SettingsRow(
                    icon: CupertinoIcons.star_fill,
                    iconColor: Colors.amber,
                    label: 'Rate Vynt',
                    trailing: Icon(CupertinoIcons.chevron_right,
                        size: 14, color: textTheme.bodySmall?.color),
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // ── Account actions ──
            _SectionHeader(label: 'Account', icon: CupertinoIcons.person_crop_circle_fill, accent: accent),
            SliverToBoxAdapter(
              child: _SettingsGroup(
                children: [
                  _SettingsRow(
                    icon: CupertinoIcons.square_arrow_left_fill,
                    iconColor: Colors.orange[400]!,
                    label: 'Log Out',
                    onTap: _logout,
                    trailing: const SizedBox.shrink(),
                  ),
                ],
              ),
            ),

            // Delete account — red, separate
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 24),
                child: _SettingsGroup(
                  children: [
                    _SettingsRow(
                      icon: CupertinoIcons.trash_fill,
                      iconColor: Colors.red[400]!,
                      label: 'Delete Account',
                      labelColor: Colors.red[400],
                      onTap: _deleteAccount,
                      trailing: const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),

            // ── Version footer ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  children: [
                    Image.asset('assets/icons/logo/vynt_logo.png',
                        height: 32, color: colorScheme.primary.withValues(alpha: 0.35)),
                    const SizedBox(height: 8),
                    Text(
                      'Vynt v1.0.0',
                      style: TextStyle(
                        color: textTheme.bodySmall?.color?.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      'Made with ♪ for music lovers',
                      style: TextStyle(
                        color: textTheme.bodySmall?.color?.withValues(alpha: 0.35),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context, Color accent) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('About Vynt'),
        content: const Text(
          'Vynt is a music-first social media app that lets you share your favorite tracks, '
          'discover new artists, and connect with fellow music enthusiasts.\n\nVersion 1.0.0',
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Close'),
            onPressed: () => Navigator.pop(ctx),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────
// Profile card at the top of settings
// ───────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  final Color accent;
  const _ProfileCard({required this.accent});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final user = FirebaseAuth.instance.currentUser;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.tertiary.withValues(alpha: 0.25),
            colorScheme.primary.withValues(alpha: 0.10),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.tertiary.withValues(alpha: 0.20),
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [colorScheme.tertiary, colorScheme.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(2.5),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: colorScheme.secondary,
              backgroundImage: user?.photoURL != null
                  ? NetworkImage(user!.photoURL!)
                  : null,
              child: user?.photoURL == null
                  ? Icon(Icons.person_rounded,
                      color: colorScheme.primary.withValues(alpha: 0.5), size: 32)
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          // Name + email
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.displayName ?? 'Vynt User',
                  style: textTheme.titleMedium?.copyWith(fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  user?.email ?? '',
                  style: textTheme.bodySmall?.copyWith(fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // Edit profile button
          GestureDetector(
            onTap: () {},
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: accent.withValues(alpha: 0.35)),
              ),
              child: Text(
                'Edit',
                style: TextStyle(
                  color: accent,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────
// Section header with icon + gradient line
// ───────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color accent;

  const _SectionHeader({
    required this.label,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: accent, size: 16),
            ),
            const SizedBox(width: 10),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                color: accent,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────
// Grouped card of settings rows
// ───────────────────────────────────────────────

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;
  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: colorScheme.secondary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

// ───────────────────────────────────────────────
// Individual settings row
// ───────────────────────────────────────────────

class _SettingsRow extends StatefulWidget {
  final IconData? icon;
  final Color? iconColor;
  final Widget? customLeading;
  final String label;
  final Color? labelColor;
  final String? subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingsRow({
    this.icon,
    this.iconColor,
    this.customLeading,
    required this.label,
    this.labelColor,
    this.subtitle,
    required this.trailing,
    this.onTap,
  });

  @override
  State<_SettingsRow> createState() => _SettingsRowState();
}

class _SettingsRowState extends State<_SettingsRow> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTapDown: (_) {
        if (widget.onTap != null) setState(() => _pressed = true);
      },
      onTapUp: (_) {
        if (widget.onTap != null) setState(() => _pressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        color: _pressed
            ? colorScheme.primary.withValues(alpha: 0.08)
            : Colors.transparent,
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            // Leading icon
            if (widget.customLeading != null)
              widget.customLeading!
            else if (widget.icon != null)
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: widget.iconColor?.withValues(alpha: 0.18) ??
                      Colors.grey.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(widget.icon,
                    color: widget.iconColor ?? Colors.grey, size: 18),
              ),
            const SizedBox(width: 14),
            // Label + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.label,
                    style: textTheme.bodyMedium?.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: widget.labelColor,
                    ),
                  ),
                  if (widget.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle!,
                      style: textTheme.bodySmall
                          ?.copyWith(fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            widget.trailing,
          ],
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────
// Thin divider inside groups
// ───────────────────────────────────────────────

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 64),
      child: Divider(
        height: 0.5,
        thickness: 0.5,
        color:
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
      ),
    );
  }
}

// ───────────────────────────────────────────────
// Small service icon widget
// ───────────────────────────────────────────────

class _ServiceIcon extends StatelessWidget {
  final Color color;
  final Widget child;
  const _ServiceIcon({required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(9),
      ),
      padding: const EdgeInsets.all(6),
      child: child,
    );
  }
}

// ───────────────────────────────────────────────
// "Connected" badge chip
// ───────────────────────────────────────────────

class _ConnectedBadge extends StatelessWidget {
  final Color accent;
  const _ConnectedBadge({required this.accent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(CupertinoIcons.checkmark_circle_fill,
              color: accent, size: 13),
          const SizedBox(width: 4),
          Text(
            'Connected',
            style: TextStyle(
              color: accent,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────
// "Connect" button chip
// ───────────────────────────────────────────────

class _ConnectButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ConnectButton(
      {required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
