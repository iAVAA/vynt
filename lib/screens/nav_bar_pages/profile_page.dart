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
import 'package:vynt/constants/constants.dart' as constants;
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
    http.Response resp = await helper
        .get('https://api.spotify.com/v1/me/player/currently-playing');

    http.Response previewTrack = await helper
        .get('https://api.spotify.com/v1/tracks/51eSHglvG1RJXtL3qI5trr');

    print(resp.body);
    var json = jsonDecode(previewTrack.body);
    String previewUrl = json['id'];
    print('Preview URL: $previewUrl');
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
    final scrollMonitor = Provider.of<ScrollMonitor>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
        actions: [
          IconButton(
            icon: Icon(CupertinoIcons.settings,
                color: Theme.of(context).textTheme.bodyLarge?.color),
            onPressed: () => {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const SettingsPage(),
                ),
              )
            },
          ),
        ],
      ),
      body: CustomScrollView(
        key: const PageStorageKey('profile'),
        controller: scrollMonitor.scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[700],
                    child: Icon(
                      Icons.person,
                      color: Colors.grey[500],
                      size: 50,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<String>(
                    future: _getUsername(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text(
                          'Error: ${snapshot.error}',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontSize: 24,
                          ),
                        );
                      } else {
                        return Text(
                          snapshot.data ?? 'Unknown User',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontSize: 24,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: _spotifyLogin,
                    child: Text('Login with Spotify'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
