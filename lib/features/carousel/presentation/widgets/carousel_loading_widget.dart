import 'package:flutter/material.dart';

class CarouselLoadingWidget extends StatelessWidget {
  final double height;

  const CarouselLoadingWidget({
    super.key,
    this.height = 200.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
