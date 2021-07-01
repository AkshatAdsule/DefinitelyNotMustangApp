import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DynamicLinkService {
  Future<Uri> createDynamicLink({
    String title = "",
    String description = "",
    Uri imageUrl,
    String path,
  }) async {
    String prefix = dotenv.env['DYNAMIC_LINK_PREFIX'];

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://$prefix',
      link: Uri.parse('https://$prefix.com$path'),
      androidParameters: AndroidParameters(
        packageName: dotenv.env['PACKAGE_NAME'],
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: dotenv.env['BUNDLE_ID'],
        minimumVersion: '1',
        appStoreId: dotenv.env['APP_STORE_ID'],
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: title,
        description: description,
        imageUrl: imageUrl,
      ),
    );
    ShortDynamicLink dynamicUrl = await parameters.buildShortLink();
    final Uri shortUrl = dynamicUrl.shortUrl;
    return shortUrl;
  }

  Future<void> retrieveDynamicLink(BuildContext context) async {
    try {
      final PendingDynamicLinkData data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri deepLink = data?.link;

      if (deepLink != null) {
        Navigator.pushNamed(
          context,
          deepLink.path,
          arguments: deepLink.queryParameters,
        );
      }

      FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          Navigator.pushNamed(
            context,
            dynamicLink.link.path,
            arguments: dynamicLink.link.queryParameters,
          );
        },
        onError: (OnLinkErrorException error) async {
          print(error);
        },
      );

      FirebaseDynamicLinks.instance
          .getDynamicLink(Uri.parse('https://mustangapp.page.link/test'));
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Uri> getLinkFromFirebase(String path) async {
    PendingDynamicLinkData data = await FirebaseDynamicLinks.instance
        .getDynamicLink(Uri.parse('https://mustangapp.page.link/test'));
    return data.link;
  }
}
