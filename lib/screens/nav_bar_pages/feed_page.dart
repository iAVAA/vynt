import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:cupertino_onboarding/cupertino_onboarding.dart';
import 'package:vynt/screens/subscreens/listening_party_page.dart';
import 'package:vynt/screens/subscreens/message_page.dart';
import 'package:vynt/widgets/nav_bar_widgets/application_bar.dart';
import 'package:vynt/controllers/scroll_monitor.dart';
import 'package:vynt/widgets/nav_bar_pages_widgets/post_widget.dart';
import 'package:vynt/widgets/nav_bar_pages_widgets/story_box_widget.dart';
import 'package:vynt/constants/constants.dart' as constants;

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? onboardingShown = prefs.getBool('onboardingShown');
    if (onboardingShown == null || !onboardingShown) {
      if (mounted) {
        setState(() {});
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            showCupertinoModalBottomSheet(
              context: context,
              builder: (context) =>
                  OnboardingOverview(onComplete: _onOnboardingComplete),
            );
          }
        });
      }
    }
  }

  void _onOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingShown', true);
    if (mounted) {
      setState(() {});
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final scrollMonitor = Provider.of<ScrollMonitor>(context);
    final PageController pageController = PageController(initialPage: 1);

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          _buildBody(context, pageController, scrollMonitor),
        ],
      ),
      backgroundColor: constants.bgColor,
    );
  }

  Widget _buildBody(BuildContext context, PageController pageController,
      ScrollMonitor scrollMonitor) {
    return PageView(
      controller: pageController,
      physics: const ClampingScrollPhysics(),
      children: [
        const ListeningPartyPage(),
        _buildFeedContent(context, pageController, scrollMonitor),
        MessagePage(pageController: pageController),
      ],
    );
  }

  Widget _buildFeedContent(BuildContext context, PageController pageController,
      ScrollMonitor scrollMonitor) {
    return CustomScrollView(
      key: const PageStorageKey('feed'),
      controller: scrollMonitor.scrollController,
      slivers: [
        ApplicationBar(
          title: constants.appName,
          scrollController: scrollMonitor.scrollController,
          pageController: pageController,
        ),
        const SliverToBoxAdapter(child: StoryBoxRow()),
        const SliverPadding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return RepaintBoundary(
                child: PostWidget(index: index + 1),
              );
            },
            childCount: 5,
          ),
        ),
      ],
    );
  }
}

class OnboardingOverview extends StatelessWidget {
  final VoidCallback onComplete;

  const OnboardingOverview({required this.onComplete, super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoOnboarding(
      onPressedOnLastPage: onComplete,
      pages: [
        WhatsNewPage(
          scrollPhysics: const BouncingScrollPhysics(),
          title: const Text("What's New Template"),
          features: const [
            WhatsNewFeature(
              title: Text('Showcase your App Features'),
              description: Text(
                  'Clean and minimalistic iOS styled template for showing app features e.g. in a new update.'),
              icon: Icon(CupertinoIcons.star),
            ),
            WhatsNewFeature(
              title: Text("Styled Icons and Buttons"),
              description: Text(
                  "To create consistent look, icons and buttons are styled to match your CupertinoTheme's primaryColor. "),
              icon: Icon(CupertinoIcons.paintbrush),
            ),
            WhatsNewFeature(
              title: Text('Style Flexibility'),
              description: Text(
                  "What's New Template can be styled to match new and old iOS versions of onboarding or your own preferences."),
              icon: Icon(CupertinoIcons.gear),
            ),
          ],
        ),
        const CupertinoOnboardingPage(
          title: Text('Support For Multiple Pages'),
          body: Icon(
            CupertinoIcons.square_stack_3d_down_right,
            size: 200,
          ),
        ),
        const CupertinoOnboardingPage(
          title: Text('Great Look in Light and Dark Mode'),
          body: Icon(
            CupertinoIcons.sun_max,
            size: 200,
          ),
        ),
        const CupertinoOnboardingPage(
          title: Text('Beautiful and Consistent Appearance'),
          body: Icon(
            CupertinoIcons.check_mark_circled,
            size: 200,
          ),
        ),
      ],
    );
  }
}
