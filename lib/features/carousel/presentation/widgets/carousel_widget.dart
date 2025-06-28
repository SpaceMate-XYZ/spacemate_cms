import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacemate/features/carousel/presentation/bloc/carousel_bloc.dart';
import 'package:spacemate/features/carousel/presentation/widgets/carousel_item_widget.dart';
import 'package:spacemate/features/carousel/presentation/widgets/carousel_loading_widget.dart';

class CarouselWidget extends StatelessWidget {
  final String? placeId;
  final double height;
  final double viewportFraction;
  final bool autoPlay;
  final Duration autoPlayInterval;
  final Duration autoPlayAnimationDuration;
  final bool showIndicator;

  const CarouselWidget({
    super.key,
    this.placeId,
    this.height = 200.0,
    this.viewportFraction = 0.9,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 5),
    this.autoPlayAnimationDuration = const Duration(milliseconds: 800),
    this.showIndicator = true,
  });

  @override
  Widget build(BuildContext context) {
    // Trigger loading on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CarouselBloc>().add(LoadCarousel(placeId: placeId));
    });

    return BlocBuilder<CarouselBloc, CarouselState>(
      builder: (context, state) {
        if (state is CarouselLoading) {
          return const CarouselLoadingWidget();
        } else if (state is CarouselLoaded) {
          if (state.items.isEmpty) {
            return const SizedBox.shrink();
          }
          return _buildCarousel(context, state.items);
        } else if (state is CarouselError) {
          return _buildError(context, state.message);
        }
        return const SizedBox.shrink();
      },
    );
  
  }

  Widget _buildCarousel(BuildContext context, List<dynamic> items) {
    return Column(
      children: [
        SizedBox(
          height: height,
          child: PageView.builder(
            itemCount: items.length,
            controller: PageController(viewportFraction: viewportFraction),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: CarouselItemWidget(item: items[index]),
              );
            },
          ),
        ),
        if (showIndicator && items.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                items.length,
                (index) => Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
