import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:waloma/core/config/app_configuration.dart';

class ImageViewer extends StatefulWidget {
  final List<String> imageUrl;
  ImageViewer({required this.imageUrl});

  @override
  _ImageViewerState createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  PageController productImageSlider = PageController();
  @override
  Widget build(BuildContext context) {
    // Helper function to normalize image URLs
    String _normalizeImageUrl(String imagePath) {
      if (imagePath.startsWith('http')) {
        return imagePath;
      }
      // Remove leading slash and construct the full URL
      imagePath =
          imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
      return 'http://${AppConfiguration.apiURL}/$imagePath';
    }

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: SvgPicture.asset(
            'assets/icons/Arrow-left.svg',
            color: Colors.white,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Stack(
        children: [
          PageView(
            physics: const BouncingScrollPhysics(),
            controller: productImageSlider,
            children: List.generate(
              widget.imageUrl.length,
              (index) => SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Image.network(
                  _normalizeImageUrl(widget.imageUrl[index]),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // indicator
          Positioned(
            bottom: 16,
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: SmoothPageIndicator(
                controller: productImageSlider,
                count: widget.imageUrl.length,
                effect: ExpandingDotsEffect(
                  dotColor: Colors.white.withOpacity(0.2),
                  activeDotColor: Colors.white.withOpacity(0.2),
                  dotHeight: 8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
