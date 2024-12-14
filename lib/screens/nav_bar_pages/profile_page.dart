import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2_client/oauth2_helper.dart';
import 'package:oauth2_client/spotify_oauth2_client.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vynt/constants/constants.dart' as constants;
import 'package:vynt/controllers/scroll_monitor.dart';
import 'package:vynt/screens/login_pages/main_login_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const MainLoginPage()),
    );
  }

  void _spotifyLogin() async {
    SpotifyOAuth2Client client = SpotifyOAuth2Client(
      customUriScheme: 'com.app.vynt',
      redirectUri: "com.app.vynt://auth/callback",
    );

    OAuth2Helper helper = OAuth2Helper(
      client,
      grantType: OAuth2Helper.authorizationCode,
      clientId: dotenv.env['SPOTIFY_CLIENT_ID'].toString(),
      clientSecret: dotenv.env['SPOTIFY_CLIENT_SECRET'].toString(),
      scopes: dotenv.env['SPOTIFY_SCOPE'].toString().split(' '),
    );
    http.Response resp =
        await helper.get('https://api.spotify.com/v1/me/player/currently-playing');
    print(resp.body);
  }

  @override
  Widget build(BuildContext context) {
    final scrollMonitor = Provider.of<ScrollMonitor>(context);

    return Scaffold(
      backgroundColor: constants.bgColor,
      appBar: AppBar(
        backgroundColor: constants.bgColor,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(color: constants.primaryTextColor),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: constants.primaryTextColor),
            onPressed: () => _logout(context),
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
                  Text(
                    'User Name',
                    style: TextStyle(
                        color: constants.primaryTextColor, fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Today\'s Post',
                          style: TextStyle(
                            color: constants.primaryTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Description of today\'s post...',
                          style: TextStyle(
                            color: constants.secondaryTextColor,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
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
