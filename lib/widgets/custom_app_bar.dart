import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'CareSathi',
          style: TextStyle(
            color: Color(0xFF07569b), // Nice blue color
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications, color: Color(0xFF07569b)),
          onPressed: () {
            // Handle notification icon tap
          },
        ),
        IconButton(
          icon: const Icon(Icons.warning, color: Colors.red),
          onPressed: () async {
            final Uri emergencyUri = Uri.parse('tel:112');
            final bool shouldDial = await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Emergency Call'),
                  content: const Text('Are you sure you want to dial the emergency number 112?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Dial'),
                    ),
                  ],
                );
              },
            );

            if (shouldDial) {
              if (await canLaunchUrl(emergencyUri)) {
                await launchUrl(emergencyUri, mode: LaunchMode.externalApplication);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Could not launch emergency dialer')),
                );
              }
            }
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: Colors.grey[300],
          height: 1.0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1.0);
}