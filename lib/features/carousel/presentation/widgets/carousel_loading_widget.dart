import 'package:flutter/material.dart';

class CarouselLoadingWidget extends StatelessWidget {
  final double height;

  const CarouselLoadingWidget({
    Key? key,
    this.height = 200.0,
  }) : super(key: key);

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
