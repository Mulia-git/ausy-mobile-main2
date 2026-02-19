import 'package:auto_size_text/auto_size_text.dart';
import 'package:ausy/core/models/blog.dart';
import 'package:ausy/core/themes/app_colors.dart';
import 'package:ausy/core/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

class BlogItem extends StatelessWidget {
  const BlogItem({
    super.key,
    required this.data,
    this.onTap,
  });

  final Blog data;
  final GestureTapCallback? onTap;
  void _openBlog() {
    FlutterWebBrowser.openWebPage(
      url: data.url,
      customTabsOptions: const CustomTabsOptions(
        colorScheme: CustomTabsColorScheme.light,
        darkColorSchemeParams:
            CustomTabsColorSchemeParams(toolbarColor: AppColor.primary),
        shareState: CustomTabsShareState.off,
        instantAppsEnabled: true,
        showTitle: true,
        urlBarHidingEnabled: true,
      ),
      safariVCOptions: const SafariViewControllerOptions(
        barCollapsingEnabled: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openBlog,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomImage(
              data.image,
              radius: 10,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(child: _buildInfo())
          ],
        ),
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.categories[0],
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColor.labelColor, fontSize: 10),
        ),
        const SizedBox(
          height: 5,
        ),
        AutoSizeText(
          data.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColor.textColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          data.date,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: AppColor.labelColor, fontSize: 10),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          data.excerpt,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            color: AppColor.labelColor,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        OutlinedButton(
          onPressed: _openBlog,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColor.primary, // Text color
            side: const BorderSide(
                color: AppColor.primary, width: 1.5), // Outline color
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text(
            "Read More",
            style: TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }
}
