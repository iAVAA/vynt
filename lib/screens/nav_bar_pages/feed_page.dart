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
          title: const Text("Welcome to Vynt"),
          features: const [
            WhatsNewFeature(
              title: Text('Discover Music and Connect'),
              description: Text(
                  'Vynt lets you share your favorite tracks and connect with others who share your taste in music.'),
              icon: Icon(CupertinoIcons.music_note),
            ),
            WhatsNewFeature(
              title: Text("Share Your Vinyl Moments"),
              description: Text(
                  "Showcase your personal vinyl collection or favorite playlists in a visually stunning way."),
              icon: Icon(CupertinoIcons.photo_camera),
            ),
            WhatsNewFeature(
              title: Text('Join the Vynt Community'),
              description: Text(
                  "Engage with music enthusiasts, follow creators, and exchange recommendations."),
              icon: Icon(CupertinoIcons.group),
            ),
          ],
        ),
        const CupertinoOnboardingPage(
          title: Text('Create Your Profile'),
          body: Icon(
            CupertinoIcons.person_crop_circle,
            size: 200,
          ),
        ),
        const CupertinoOnboardingPage(
          title: Text('Share Your Music Journey'),
          body: Icon(
            CupertinoIcons.share,
            size: 200,
          ),
        ),
        const CupertinoOnboardingPage(
          title: Text('Engage with the Community'),
          body: Icon(
            CupertinoIcons.chat_bubble_text,
            size: 200,
          ),
        ),
      ],
    );
  }
}
