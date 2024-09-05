import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'userdetails_view.dart'; // Import your UserdetailsView

class SplashscreenView extends StatefulWidget {
  const SplashscreenView({super.key});

  @override
  State<SplashscreenView> createState() => _SplashscreenViewState();
}

class _SplashscreenViewState extends State<SplashscreenView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    // Start the animation
    _controller.forward();

    // Navigate to UserdetailsView after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (_controller.isAnimating) {
        _controller.stop();
      }
      // Navigate to UserdetailsView
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) =>  UserdetailsView()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _animation.value * 2.0 * 3.14159, // Full rotation (2 * π)
                  child: child,
                );
              },
              child: Image.asset("assets/pngwing.com.png", height: 200),
            ),
          ),
          SizedBox(height: 23),
          Text(
            "Manage your expenses",
            style: GoogleFonts.inter(
              color: Colors.black,
              fontSize: 20, // Adjust the font size as needed
            ),
          ),
        ],
      ),
    );
  }
}
