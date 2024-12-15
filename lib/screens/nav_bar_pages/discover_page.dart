import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
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
      backgroundColor: constants.bgColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 70.0),
                child: Text(
                  'Discover',
                  style: GoogleFonts.poppins(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: CupertinoSearchTextField(
                  backgroundColor: constants.secondaryBgColor,
                  borderRadius: BorderRadius.circular(10),
                  placeholder: 'Search',
                  placeholderStyle: TextStyle(color: constants.secondaryTextColor),
                  itemColor: Colors.grey,
                  style: TextStyle(color: constants.primaryTextColor),
                ),
              ),
              SizedBox(
                height: 500.0,
                child: CardSwiper(
                  // TODO: FIX THE SWIPE DIRECTIONS
                  controller: controller,
                  cardsCount: cards.length,
                  backCardOffset: const Offset(0, 0),
                  allowedSwipeDirection: const AllowedSwipeDirection.only(
                    right: true,
                    left: true,
                    up: true,
                    down: false,
                  ),
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