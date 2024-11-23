import 'package:flutter/material.dart';

import 'package:vynt/constants/constants.dart' as constants;

class ListeningPartyPage extends StatelessWidget {
  const ListeningPartyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: constants.bgColor,
      appBar: AppBar(
        backgroundColor: constants.bgColor,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(color: constants.primaryTextColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Spotify",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildListeningSection(
              context,
              title: "Join Spotify Party",
              description: "Sync and enjoy tracks together.",
              iconPath: "assets/test_pictures/icons/spotify.webp",
              buttonLabel: "Join Now",
              buttonColor: Colors.green,
              onTap: () {
                // Add Spotify party functionality
              },
            ),
            const SizedBox(height: 30),
            const Text(
              "Apple Music",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildListeningSection(
              context,
              title: "Start Apple Music Party",
              description: "Listen to your favorite albums together.",
              iconPath: "assets/test_pictures/icons/apple_music.png",
              buttonLabel: "Start Now",
              buttonColor: Colors.red,
              onTap: () {
                // Add Apple Music party functionality
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListeningSection(
    BuildContext context, {
    required String title,
    required String description,
    required String iconPath,
    required String buttonLabel,
    required Color buttonColor,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.grey[850],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.grey[800],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  iconPath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Text(buttonLabel),
            ),
          ],
        ),
      ),
    );
  }
}
