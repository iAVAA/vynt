import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddPostWidget extends StatefulWidget {
  const AddPostWidget({super.key});

  @override
  State<AddPostWidget> createState() => _AddPostWidgetState();
}

class _AddPostWidgetState extends State<AddPostWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  final TextEditingController _captionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _captionController.dispose();
    super.dispose();
  }

  void _dismiss() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      // Dismiss when tapping the backdrop
      onTap: _dismiss,
      behavior: HitTestBehavior.opaque,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: MediaQuery.of(context).size.height * 0.08,
            bottom: 16,
          ),
          child: SlideTransition(
            position: _slideAnimation,
            child: GestureDetector(
              // Prevent dismissal when tapping inside the sheet
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.all(Radius.circular(28)),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withOpacity(0.15),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Handle bar
                      Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: colorScheme.secondary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      // Title
                      Text(
                        'New Post',
                        style: TextStyle(
                          color: textTheme.titleLarge?.color,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Vinyl art preview
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/arts/vinyl_art.png',
                            width: 180,
                            height: 250,
                          ),
                          Image.asset(
                            'assets/arts/cover_art.png',
                            width: 165,
                            height: 250,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Choose music label
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          Icons.music_note_rounded,
                          color: colorScheme.tertiary,
                          size: 18,
                        ),
                        label: Text(
                          'Choose a track',
                          style: TextStyle(
                            color: colorScheme.tertiary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Caption field
                      TextField(
                        controller: _captionController,
                        maxLines: 3,
                        minLines: 1,
                        style: TextStyle(color: textTheme.bodyMedium?.color),
                        decoration: InputDecoration(
                          hintText: 'Write a caption...',
                          hintStyle:
                              TextStyle(color: textTheme.bodySmall?.color),
                          filled: true,
                          fillColor: colorScheme.secondary,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Post button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            _dismiss();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.primary,
                            foregroundColor: colorScheme.onPrimary,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Share Post',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: colorScheme.secondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
