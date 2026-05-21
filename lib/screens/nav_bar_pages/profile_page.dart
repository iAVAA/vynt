import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:oauth2_client/spotify_oauth2_client.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vynt/controllers/scroll_monitor.dart';
import 'package:vynt/screens/login_pages/main_login_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../subscreens/profile_subscreens/settings.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainLoginPage()),
    );
  }

  Future<void> _spotifyLogin() async {
    SpotifyOAuth2Client client = SpotifyOAuth2Client(
      customUriScheme: 'com.app.vynt',
      redirectUri: dotenv.env['SPOTIFY_REDIRECT_URI'].toString(),
    );

    OAuth2Helper helper = OAuth2Helper(
      client,
      grantType: OAuth2Helper.authorizationCode,
      clientId: dotenv.env['SPOTIFY_CLIENT_ID'].toString(),
      clientSecret: dotenv.env['SPOTIFY_CLIENT_SECRET'].toString(),
      scopes: dotenv.env['SPOTIFY_SCOPE'].toString().split(' '),
    );
    await helper
        .get('https://api.spotify.com/v1/me/player/currently-playing');

    http.Response previewTrack = await helper
        .get('https://api.spotify.com/v1/tracks/51eSHglvG1RJXtL3qI5trr');

    var json = jsonDecode(previewTrack.body);
    String previewUrl = json['id'];
    debugPrint('Preview URL: $previewUrl');
  }

  Future<String> _getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedUsername = prefs.getString('username');
    if (cachedUsername != null) {
      return cachedUsername;
    }

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      String username = userDoc['name'];
      await prefs.setString('username', username);
      return username;
    }
    return 'Unknown User';
  }

  @override
  Widget build(BuildContext context) {
    final scrollMonitor = Provider.of<ScrollMonitor>(context, listen: false);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        forceMaterialTransparency: true,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(
            color: textTheme.bodyLarge?.color,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              CupertinoIcons.settings,
              color: textTheme.bodyLarge?.color,
            ),
            onPressed: () => Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const SettingsPage(),
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        key: const PageStorageKey('profile'),
        controller: scrollMonitor.getScrollController('profile'),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Avatar with gradient border
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.tertiary,
                        colorScheme.primary,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  padding: const EdgeInsets.all(3),
                  child: CircleAvatar(
                    radius: 52,
                    backgroundColor: colorScheme.secondary,
                    child: Icon(
                      Icons.person_rounded,
                      color: colorScheme.primary.withOpacity(0.5),
                      size: 56,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                // Username
                FutureBuilder<String>(
                  future: _getUsername(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.tertiary,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        'Error loading profile',
                        style: TextStyle(
                          color: textTheme.bodySmall?.color,
                          fontSize: 16,
                        ),
                      );
                    } else {
                      return Text(
                        snapshot.data ?? 'Unknown User',
                        style: TextStyle(
                          color: textTheme.bodyLarge?.color,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 6),
                Text(
                  '@username · Music lover 🎵',
                  style: TextStyle(
                    color: textTheme.bodySmall?.color,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 20),
                // Stats row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatItem(count: '248', label: 'Posts'),
                      _StatDivider(),
                      _StatItem(count: '1.2K', label: 'Followers'),
                      _StatDivider(),
                      _StatItem(count: '384', label: 'Following'),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Spotify connect button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: OutlinedButton.icon(
                    onPressed: _spotifyLogin,
                    icon: const Icon(
                      CupertinoIcons.music_note_2,
                      size: 18,
                    ),
                    label: const Text('Connect Spotify'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1DB954),
                      side: const BorderSide(color: Color(0xFF1DB954)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Divider(
                  color: colorScheme.secondary.withOpacity(0.5),
                  thickness: 0.5,
                ),
              ],
            ),
          ),
          // Grid of posts placeholder
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  margin: const EdgeInsets.all(1),
                  color: colorScheme.secondary,
                  child: Image.asset(
                    'assets/test_pictures/cover_art/${(index % 10) + 1}.jpeg',
                    fit: BoxFit.cover,
                  ),
                );
              },
              childCount: 12,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 2,
              mainAxisSpacing: 2,
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 90)),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String count;
  final String label;

  const _StatItem({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodySmall?.color,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 30,
      color: Theme.of(context).colorScheme.secondary,
    );
  }
}
