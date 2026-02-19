import 'package:auto_size_text/auto_size_text.dart';
import 'package:ausy/core/models/blog.dart';
import 'package:ausy/core/themes/app_colors.dart';
import 'package:ausy/core/widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

class BlogItem extends StatelessWidget {
  const BlogItem({super.key, required this.data});
  final Blog data;
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
      onTap: () {
        _openBlog();
      },
      child: Container(
         decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: CustomImage(data.image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.categories[0],
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: AppColor.labelColor, fontSize: 10),
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
                    style: const TextStyle(
                        color: AppColor.labelColor, fontSize: 10),
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      "Read More",
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
