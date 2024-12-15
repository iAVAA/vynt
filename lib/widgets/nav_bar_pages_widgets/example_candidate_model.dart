import 'package:flutter/cupertino.dart';

class ExampleCandidateModel {
  final String name;
  final String job;
  final String city;
  final AssetImage image;

  ExampleCandidateModel({
    required this.name,
    required this.job,
    required this.city,
    required this.image,
  });
}

final List<ExampleCandidateModel> candidates = [
  ExampleCandidateModel(
    name: 'Daniele, 20',
    job: 'Developer',
    city: 'Areado',
    image: AssetImage('assets/test_pictures/test_post.webp'),
  ),
  ExampleCandidateModel(
    name: 'Danielone, 26',
    job: 'Manager',
    city: 'New York',
    image: AssetImage('assets/test_pictures/test_post.webp'),
  ),
  ExampleCandidateModel(
    name: 'Muflone Bianco, 80',
    job: 'Engineer',
    city: 'London',
    image: AssetImage('assets/test_pictures/test_post.webp'),
  ),
  ExampleCandidateModel(
    name: 'Muflone Nero, 40',
    job: 'Designer',
    city: 'Tokyo',
    image: AssetImage('assets/test_pictures/test_post.webp'),
  ),
];