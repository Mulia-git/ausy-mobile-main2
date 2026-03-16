import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

class FullscreenImageViewer extends StatefulWidget {
  final String imageUrl;
  final String tag;

  const FullscreenImageViewer({
    super.key,
    required this.imageUrl,
    required this.tag,
  });

  @override
  State<FullscreenImageViewer> createState() => _FullscreenImageViewerState();
}

class _FullscreenImageViewerState extends State<FullscreenImageViewer> {

  double verticalDrag = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,

      body: Stack(
        children: [

          /// BLUR BACKGROUND
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: 30,
                sigmaY: 30,
              ),
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// PHOTO VIEW (ZOOM)
          PhotoViewGestureDetectorScope(
            axis: Axis.vertical,
            child: GestureDetector(

              /// swipe down close
              onVerticalDragUpdate: (details) {
                verticalDrag += details.delta.dy;
              },

              onVerticalDragEnd: (_) {
                if (verticalDrag > 120) {
                  Navigator.pop(context);
                }
                verticalDrag = 0;
              },

              child: Center(
                child: Hero(
                  tag: widget.tag,
                  child: PhotoView(
                    backgroundDecoration:
                    const BoxDecoration(color: Colors.transparent),

                    imageProvider: CachedNetworkImageProvider(
                      widget.imageUrl,
                    ),

                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 4,

                    /// double tap zoom
                    scaleStateCycle: (actual) {
                      if (actual == PhotoViewScaleState.initial) {
                        return PhotoViewScaleState.zoomedIn;
                      }
                      return PhotoViewScaleState.initial;
                    },

                    loadingBuilder: (context, event) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade800,
                        highlightColor: Colors.grey.shade700,
                        child: Container(
                          width: 200,
                          height: 200,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          /// CLOSE BUTTON
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}