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
              // User Name
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'danielebusinesscompagnoni',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Followers
                  Column(
                    children: [
                      Text(
                        'Followers',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      Text(
                        '1.2K',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(width: 32),
                  // Profile Picture
                  CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        AssetImage('assets/test_pictures/daniele_pfp.png'),
                  ),
                  SizedBox(width: 32),
                  // Following
                  Column(
                    children: [
                      Text(
                        'Following',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      Text(
                        '500',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Daniele Compagnoni',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Business and entrepreneur computer science student.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Follow'),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('Edit Profile'),
                  ),
                ],
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
                itemCount: 20,
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