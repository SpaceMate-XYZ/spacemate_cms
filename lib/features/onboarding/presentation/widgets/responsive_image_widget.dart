import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class ResponsiveImageWidget extends StatelessWidget {
  final String imageUrl;
  final double containerHeight;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;
  final Widget Function(BuildContext, String)? placeholder;

  const ResponsiveImageWidget({
    super.key,
    required this.imageUrl,
    required this.containerHeight,
    this.errorWidget,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    developer.log('ResponsiveImageWidget: Attempting to load image: $imageUrl');
    return Container(
      height: containerHeight,
      width: double.infinity,
      child: ClipRect(
        child: OverflowBox(
          maxWidth: double.infinity,
          alignment: Alignment.center,
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: containerHeight,
            errorBuilder: (context, url, error) {
              developer.log('ResponsiveImageWidget: Image.network error: $error for $url');
              return Container(
                height: containerHeight,
                color: Colors.red[50],
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.broken_image,
                        size: 80,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Image Loading Failed',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[800],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'URL: $url',
                        style: const TextStyle(fontSize: 12, color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Error: $error',
                        style: const TextStyle(fontSize: 10, color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: containerHeight,
                color: Colors.grey[200],
                child: const Center(child: CircularProgressIndicator()),
              );
            },
          ),
        ),
      ),
    );
  }
} 