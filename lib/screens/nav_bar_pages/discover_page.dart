import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

import '../../widgets/nav_bar_pages_widgets/example_candidate_model.dart';
import '../../widgets/nav_bar_pages_widgets/example_card.dart';

class Discover extends StatefulWidget {
  const Discover({super.key});

  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  final CardSwiperController controller = CardSwiperController();
  late final List<ExampleCard> cards;

  @override
  void initState() {
    super.initState();
    cards = candidates.map(ExampleCard.new).toList();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  Text(
                    'Discover',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: textTheme.bodyLarge?.color,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    CupertinoIcons.slider_horizontal_3,
                    color: textTheme.bodyLarge?.color,
                  ),
                ],
              ),
            ),
            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: CupertinoSearchTextField(
                backgroundColor: colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
                placeholder: 'Search artists, albums, genres...',
                placeholderStyle: TextStyle(
                  color: textTheme.bodySmall?.color,
                ),
                itemColor: textTheme.bodyMedium?.color ?? Colors.grey,
                style: TextStyle(color: textTheme.bodyMedium?.color),
              ),
            ),
            // Card swiper
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: CardSwiper(
                  controller: controller,
                  cardsCount: cards.length,
                  backCardOffset: const Offset(0, 12),
                  scale: 0.95,
                  onSwipe: _onSwipe,
                  onUndo: _onUndo,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 16),
                  cardBuilder: (
                    context,
                    index,
                    horizontalThresholdPercentage,
                    verticalThresholdPercentage,
                  ) =>
                      cards[index],
                ),
              ),
            ),
            // Control buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildControlButton(
                    context,
                    icon: CupertinoIcons.arrow_uturn_left,
                    onPressed: controller.undo,
                    label: 'Undo',
                  ),
                  _buildControlButton(
                    context,
                    icon: CupertinoIcons.xmark,
                    onPressed: () =>
                        controller.swipe(CardSwiperDirection.left),
                    label: 'Skip',
                    accent: Colors.red[400]!,
                  ),
                  _buildControlButton(
                    context,
                    icon: CupertinoIcons.heart_fill,
                    onPressed: () =>
                        controller.swipe(CardSwiperDirection.right),
                    label: 'Like',
                    accent: colorScheme.tertiary,
                    isLarge: true,
                  ),
                  _buildControlButton(
                    context,
                    icon: CupertinoIcons.music_note,
                    onPressed: () =>
                        controller.swipe(CardSwiperDirection.top),
                    label: 'Save',
                    accent: Colors.blue[400]!,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
    required String label,
    Color? accent,
    bool isLarge = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = isLarge ? 64.0 : 52.0;
    final iconSize = isLarge ? 28.0 : 20.0;
    final effectiveAccent = accent ?? textTheme.bodyMedium?.color ?? Colors.grey;

    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.secondary,
              boxShadow: [
                BoxShadow(
                  color: effectiveAccent.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: effectiveAccent, size: iconSize),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: textTheme.bodySmall?.color,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  bool _onSwipe(
    int previousIndex,
    int? currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint(
      'The card $previousIndex was swiped to the ${direction.name}. Now the card $currentIndex is on top',
    );
    return true;
  }

  bool _onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    debugPrint(
      'The card $currentIndex was undone from the ${direction.name}',
    );
    return true;
  }
}
