import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:spendsmart/home_page.dart';
import 'package:spendsmart/styles.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            title: "Welcome to SpendSmart",
            body:
                "Track your spending effortlessly by snapping a photo of your receipt. Let AI do the rest.",
            image: Icon(Icons.camera_alt, size: 200),
            decoration: const PageDecoration(
              titleTextStyle: TextStyle(
                color: AppColors.secondary,
                fontSize: AppTextSize.title,
                fontWeight: FontWeight.bold,
              ),
              bodyTextStyle: TextStyle(fontSize: AppTextSize.body),
            ),
          ),

          PageViewModel(
            title: "Understand Your Finances",
            body:
                "View charts and insights to see where your money goes. Set budgets and stick to them with ease.",
            image: Icon(Icons.bar_chart, size: 200),
            decoration: const PageDecoration(
              titleTextStyle: TextStyle(
                color: AppColors.secondary,
                fontSize: AppTextSize.title,
                fontWeight: FontWeight.bold,
              ),
              bodyTextStyle: TextStyle(fontSize: AppTextSize.body),
            ),
          ),

          PageViewModel(
            title: "Smarter Money Habits",
            body:
                "Get personalized tips to improve your spending behavior, powered by OpenAI and your own data.",
            image: Icon(Icons.lightbulb_outline, size: 200),
            decoration: const PageDecoration(
              titleTextStyle: TextStyle(
                color: AppColors.secondary,
                fontSize: AppTextSize.title,
                fontWeight: FontWeight.bold,
              ),
              bodyTextStyle: TextStyle(fontSize: AppTextSize.body),
            ),
          ),

          PageViewModel(
            title: "Secure & Personalized",
            body:
                "Sign in with Google to save your data securely and access your personal finance dashboard anytime.",
            image: Icon(Icons.lock, size: 200),
            decoration: const PageDecoration(
              titleTextStyle: TextStyle(
                color: AppColors.secondary,
                fontSize: AppTextSize.title,
                fontWeight: FontWeight.bold,
              ),
              bodyTextStyle: TextStyle(fontSize: AppTextSize.body),
            ),
          ),
        ],
        showSkipButton: true,
        skip: const Text("Skip"),
        next: const Text("Next"),
        done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w700)),
        onDone: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        },
        dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: Theme.of(context).colorScheme.secondary,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.xxl),
          ),
        ),
      ),
    );
  }
}
