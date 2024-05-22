import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.imageProfile,
    required this.radius,
  });

  final double radius;
  final String? imageProfile;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey[200],
      child: imageProfile != null
          ? ClipRRect(
        borderRadius: BorderRadius.circular(50.0),
        child: Image.network(
          imageProfile!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Icon(
                Icons.person,
                color: Colors.grey[600],
              ),
            );
          },
        ),
      )
          : Icon(
        Icons.person,
        color: Colors.grey[600],
      ),
    );
  }
}