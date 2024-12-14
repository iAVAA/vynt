import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vynt/controllers/scroll_monitor.dart';
import 'package:vynt/constants/constants.dart' as constants;

import '../../widgets/nav_bar_pages_widgets/example_candidate_model.dart';
import '../../widgets/nav_bar_pages_widgets/example_card.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final CardSwiperController controller = CardSwiperController();

  final cards = candidates.map(ExampleCard.new).toList();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scrollMonitor = Provider.of<ScrollMonitor>(context);

    return Scaffold(
      backgroundColor: constants.bgColor,
      body: CustomScrollView(
        key: const PageStorageKey('search'),
        controller: scrollMonitor.scrollController,
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.transparent,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Library',
                style: GoogleFonts.poppins(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              collapseMode: CollapseMode.parallax,
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CupertinoSearchTextField(
                    backgroundColor: constants.secondaryBgColor,
                    borderRadius: BorderRadius.circular(10),
                    placeholder: 'Search',
                    placeholderStyle:
                        TextStyle(color: constants.secondaryTextColor),
                    itemColor: Colors.grey,
                    style: TextStyle(color: constants.primaryTextColor),
                  ),
                ),
                SizedBox(
                  height: 500.0,
                  child: CardSwiper(
                    controller: controller,
                    cardsCount: cards.length,
                    onSwipe: _onSwipe,
                    onUndo: _onUndo,
                    numberOfCardsDisplayed: 2,
                    cardBuilder: (
                      context,
                      index,
                      horizontalThresholdPercentage,
                      verticalThresholdPercentage,
                    ) =>
                        cards[index],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                        onPressed: controller.undo,
                        child: const Icon(Icons.rotate_left),
                      ),
                      FloatingActionButton(
                        onPressed: () =>
                            controller.swipe(CardSwiperDirection.left),
                        child: const Icon(Icons.keyboard_arrow_left),
                      ),
                      FloatingActionButton(
                        onPressed: () =>
                            controller.swipe(CardSwiperDirection.right),
                        child: const Icon(Icons.keyboard_arrow_right),
                      ),
                      FloatingActionButton(
                        onPressed: () =>
                            controller.swipe(CardSwiperDirection.top),
                        child: const Icon(Icons.keyboard_arrow_up),
                      ),
                      FloatingActionButton(
                        onPressed: () =>
                            controller.swipe(CardSwiperDirection.bottom),
                        child: const Icon(Icons.keyboard_arrow_down),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
