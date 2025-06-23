import 'package:flutter/material.dart';
import 'package:spacemate/core/utils/image_utils.dart';

class CachedMenuImage extends StatelessWidget {
  final String imageUrl;
  final String placeholderIcon;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final BorderRadius? borderRadius;
  final BoxShape shape;
  final Widget? errorWidget;
  final Widget? placeholder;

  const CachedMenuImage({
    super.key,
    required this.imageUrl,
    this.placeholderIcon = 'menu',
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.errorWidget,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    final Widget image = ImageUtils.cachedImage(
      imageUrl: imageUrl,
      placeholderIcon: placeholderIcon,
      width: width,
      height: height,
      fit: fit,
      color: color,
    );

    Widget result = ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      clipBehavior: Clip.antiAlias,
      child: image,
    );

    // Apply shape if borderRadius is not provided
    if (borderRadius == null && shape == BoxShape.circle) {
      result = ClipOval(
        child: image,
      );
    }

    // Add error handling
    if (errorWidget != null) {
      result = ErrorWidgetBuilder(
        imageUrl: imageUrl,
        builder: image,
        errorWidget: errorWidget!,
      );
    }

    // Add loading placeholder
    if (placeholder != null) {
      result = Stack(
        children: [
          if (placeholder != null) placeholder!,
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: result,
            ),
          ),
        ],
      );
    }

    return result;
  }
}

class ErrorWidgetBuilder extends StatefulWidget {
  final String imageUrl;
  final Widget builder;
  final Widget errorWidget;

  const ErrorWidgetBuilder({
    super.key,
    required this.imageUrl,
    required this.builder,
    required this.errorWidget,
  });

  @override
  _ErrorWidgetBuilderState createState() => _ErrorWidgetBuilderState();
}

class _ErrorWidgetBuilderState extends State<ErrorWidgetBuilder> {
  bool _hasError = false;

  @override
  void didUpdateWidget(ErrorWidgetBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageUrl != oldWidget.imageUrl) {
      _hasError = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return widget.errorWidget;
    }

    return Builder(
      builder: (context) {
        // This is a hack to detect image loading errors
        return LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                widget.builder,
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: GestureDetector(
                      onTap: () {
                        if (_hasError) {
                          setState(() {
                            _hasError = false;
                          });
                        }
                      },
                      child: Container(
                        color: Colors.transparent,
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _onImageError(dynamic error, StackTrace? stackTrace) {
    if (mounted) {
      setState(() {
        _hasError = true;
      });
    }
  }
}
