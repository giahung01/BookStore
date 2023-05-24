import 'dart:async';

import 'package:flutter/material.dart';

class SlideBanner extends StatefulWidget {
  const SlideBanner({super.key});

  @override
  _SlideBanner createState() => _SlideBanner();
}

class _SlideBanner extends State<SlideBanner> {
  late final PageController pageController;
  int pageNo = 0;

  Timer? bannerTimer;

  Timer getTimer() {
    return Timer.periodic(const Duration(seconds: 2), (timer) {
      if (pageNo == 4) {
        pageNo = 0;
      }
      pageController.animateToPage(pageNo,
          duration: const Duration(seconds: 1), curve: Curves.easeInCirc);
      pageNo++;
    });
  }

  @override
  void initState() {
    pageController = PageController(initialPage: 0, viewportFraction: 0.85);
    bannerTimer = getTimer();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: buildBannerSlider()
      ),
    );
  }

  buildBannerSlider() {
    return Column(
      children: [
        SizedBox(
          height: 100, // chieu cao cua the
          child: PageView.builder(
            controller: pageController,
            onPageChanged: (index) {
              pageNo = index;
              setState(() {});
            },
            itemBuilder: (_, index) {
              return AnimatedBuilder(
                animation: pageController,
                builder: (context, child) {
                  return child!;
                },
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("You tapped at ${index+1}")));
                  },
                  onPanDown: (d) {
                    bannerTimer?.cancel();
                    bannerTimer = null;
                  },
                  onPanCancel: () {
                    bannerTimer = getTimer();
                  },
                  child: Container(
                    margin: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.amberAccent,
                    ),
                  ),
                ),
              );
            },
            itemCount: 5,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
                  (index) => Container(
                margin: const EdgeInsets.all(2),
                child: Icon(
                  Icons.circle,
                  size: 12,
                  color: pageNo == index
                      ? Colors.indigoAccent
                      : Colors.grey.shade300,
                ),
              ),
            )),
      ],
    );
  }

}

