import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trendveiw/components/buttton.dart';
import 'package:trendveiw/components/onboard.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(18, 18, 18, 1),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),

            // PageView showing intro content
            Expanded(
              child: PageView(
                controller: _controller,
                children: const [
                  OnboardItem(
                    icon: Icons.trending_up,
                    title: 'Trending Movies',
                    description:
                        'Stay updated with the hottest and most talked-about movies.',
                  ),
                  OnboardItem(
                    icon: Icons.category,
                    title: 'Genre Explorer',
                    description:
                        'Browse movies based on your favorite genres and moods.',
                  ),
                  OnboardItem(
                    icon: Icons.bookmark_border,
                    title: 'Save & Watch Later',
                    description:
                        'Bookmark movies and create your personalized watchlist.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Dot Indicator
            SmoothPageIndicator(
              controller: _controller,
              count: 3,
              effect: WormEffect(
                dotColor: Colors.grey.shade700,
                activeDotColor: const Color.fromRGBO(255, 64, 129, 1),
                dotHeight: 10,
                dotWidth: 10,
              ),
            ),

            const SizedBox(height: 30),

            // Get Started Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: MyButton(
                text: 'Get Started',
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
