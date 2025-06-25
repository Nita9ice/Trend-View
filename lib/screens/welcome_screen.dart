import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trendveiw/components/buttton.dart';
import 'package:trendveiw/components/onboard.dart';
import 'package:trendveiw/theme/theme_controller.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  // Controller to manage and control the pages in a PageView ; for swiping between screens
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    // Access the ThemeController instance from the Provider for managing light/dark theme state
    final themeController = Provider.of<ThemeController>(context);

    // Get the current theme data from the context.
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              // switch icons based on mode
              themeController.isDarkMode
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode,
              color: theme.iconTheme.color,
            ),

            onPressed: () {
              // Toggle between light and dark theme modes when the button is pressed
              themeController.toggleThemeMode();
            },
            tooltip:
                themeController.isDarkMode
                    // Show tooltip text depending on current theme mode
                    ? 'Switch to Light Mode' // If currently in dark mode, suggest switching to light mode
                    : 'Switch to Dark Mode', // If currently in light mode, suggest switching to dark mode
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),

            // PageView showing intro content
            Expanded(
              child: PageView(
                controller: _controller,
                children: const [
                  // first pageveiw
                  OnboardItem(
                    icon: Icons.trending_up,
                    title: 'Trending Movies',
                    description:
                        'Stay updated with the hottest and most talked-about movies.',
                  ),
                  // second pageveiw
                  OnboardItem(
                    icon: Icons.category,
                    title: 'Genre Explorer',
                    description:
                        'Browse movies based on your favorite genres and moods.',
                  ),
                  // third pageveiw
                  OnboardItem(
                    icon: Icons.favorite,
                    title: 'Add to favourites',
                    description:
                        'Save items to your favourites for quick access later.',
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
                dotColor: theme.hintColor.withAlpha((0.7 * 255).round()),
                activeDotColor: Color.fromRGBO(255, 64, 129, 1),
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
                  // take me to login screen
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
