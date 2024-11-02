import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Picture
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          AssetImage('assets/test_pictures/daniele_pfp.png'),
                    ),
                    const SizedBox(width: 16),
                    // User Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'danielebusinesscompagnoni',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Daniele Compagnoni',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Business and entrepreneur computer science student.', // Bio
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Follow and Edit Profile Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                child: const Text('Follow'),
                              ),
                              OutlinedButton(
                                onPressed: () {},
                                child: const Text('Edit Profile'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Divider
              Divider(color: Colors.grey[800]),
              const SizedBox(height: 16),
              // Posts Grid
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 2.0,
                  mainAxisSpacing: 2.0,
                  childAspectRatio: 1.0,
                ),
                itemCount: 9, // Number of posts
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.grey[800],
                    child: Image.asset('assets/test_pictures/daniele_pfp.png',
                        fit: BoxFit.cover),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
