import 'package:flutter/material.dart';
import 'package:shababeek/splash/start_screen.dart';
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3), // Total duration of 3 seconds
    );

    _animation = Tween<double>(
      begin: 0.0, // Fully transparent
      end: 1.0,   // Fully opaque
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 1.0, curve: Curves.easeInOut), // Control the timing
    ));

    _animationController.forward().then((_) {
      // Reverse the animation after it completes
      _animationController.reverse();
    });
  }

  void _startFadeInAnimation() {
    _animationController.forward().then((_) {
      // Navigate to the main screen when the animation completes
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => AuthContainer()),
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    print("splash screen");
    return Center(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Opacity(
            opacity: _animation.value,
            child: child,
          );
        },
        child: Image.network("https://res.cloudinary.com/dmrb3gva0/image/upload/v1711317757/s_logo_iu1vov.png", width: 200, height: 200),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
