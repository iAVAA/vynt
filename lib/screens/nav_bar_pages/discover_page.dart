import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:modular_ui/modular_ui.dart';
import 'package:vynt/constants/constants.dart' as constants;

import '../../widgets/nav_bar_pages_widgets/example_candidate_model.dart';
import '../../widgets/nav_bar_pages_widgets/example_card.dart';

class Discover extends StatefulWidget {
  const Discover({super.key});

  @override
  State<Discover> createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  final CardSwiperController controller = CardSwiperController();

  final cards = candidates.map(ExampleCard.new).toList();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 70.0),
              child: Text(
                'Discover',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
              child: CupertinoSearchTextField(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(10),
                placeholder: 'Search',
                placeholderStyle: TextStyle(
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withOpacity(0.7)),
                itemColor: (Theme.of(context).textTheme.bodyMedium?.color ??
                        Colors.black)
                    .withOpacity(0.7),
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyMedium?.color),
              ),
            ),
            SizedBox(
              height: 500.0,
              child: CardSwiper(
                controller: controller,
                cardsCount: cards.length,
                backCardOffset: const Offset(0, 0),
                onSwipe: _onSwipe,
                onUndo: _onUndo,
                cardBuilder: (
                  context,
                  index,
                  horizontalThresholdPercentage,
                  verticalThresholdPercentage,
                ) =>
                    cards[index],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MUISecondaryButton(
                  text: 'Undo',
                  onPressed: controller.undo,
                ),
                FloatingActionButton(
                  onPressed: () => controller.swipe(CardSwiperDirection.left),
                  child: const Icon(Icons.keyboard_arrow_left),
                ),
                FloatingActionButton(
                  onPressed: () => controller.swipe(CardSwiperDirection.top),
                  child: const Icon(Icons.keyboard_arrow_up),
                ),
                FloatingActionButton(
                  onPressed: () => controller.swipe(CardSwiperDirection.right),
                  child: const Icon(Icons.keyboard_arrow_right),
                ),
              ],
            ),
          ],
        ),
      ),
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
      'The card $currentIndex was undod from the ${direction.name}',
    );
    return true;
  }
}
