import 'package:flutter/material.dart';
import 'package:foodify/views/widgets/video_widget.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          // const Text(
          //   'Foodify',
          //   style: TextStyle(
          //     fontSize: 25,
          //     fontWeight: FontWeight.bold,
          //     color: Colors.amber,
          //   ),
          // ),
          Stack(
            children: [
              Lottie.asset(
                // 'assets/videos/splashscr.mp4.lottie.json',
                'assets/videos/splash_animation.json',
                controller: _controller,
                onLoaded: (composition) {
                  _controller!.duration = composition.duration;
                  _controller!.forward();
                },
              ),
              Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.65),
                  Text('Foodify',
                      style: TextStyle(
                        color: Colors.deepOrangeAccent,
                        fontSize: 45,
                      ))
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
