import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mustang_app/pages/onboarding/register.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DynamicLinkService {
  static final String prefix = dotenv.env['DYNAMIC_LINK_URI_PREFIX'];

  static Future<Uri> createDynamicLink({
    String title = "Homestead Robotics",
    String description = "Homestead Robotics Scouting App",
    Uri imageUrl,
    String path = Register.route,
  }) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://$prefix',
      link: Uri.parse('https://$prefix$path'),
      androidParameters: AndroidParameters(
        packageName: packageInfo.packageName,
        minimumVersion: 1,
      ),
      iosParameters: IosParameters(
        bundleId: packageInfo.packageName,
        minimumVersion: '1',
        appStoreId: dotenv.env['APP_STORE_ID'],
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: title,
        description: description,
        imageUrl: imageUrl ??
            Uri.parse(
                'https://firebasestorage.googleapis.com/v0/b/mustangapp-b1398.appspot.com/o/logo.png?alt=media&token=f45e368d-3cba-4d67-b8d5-2e554f87e046'),
      ),
      navigationInfoParameters: NavigationInfoParameters(
        forcedRedirectEnabled: false,
      ),
    );
    ShortDynamicLink dynamicUrl = await parameters.buildShortLink();
    final Uri shortUrl = dynamicUrl.shortUrl;
    return shortUrl;
  }

  static Future<void> retrieveDynamicLink({
    Function(PendingDynamicLinkData data) onLinkReceived,
    Function(OnLinkErrorException error) onError,
  }) async {
    try {
      FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData dynamicLink) async {
          if (onLinkReceived != null) {
            onLinkReceived(dynamicLink);
          } else {
            print(dynamicLink.link.toString());
          }
        },
        onError: (OnLinkErrorException error) async {
          if (onError != null) {
            onError(error);
          } else {
            print(error);
          }
        },
      );

      final PendingDynamicLinkData data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      final Uri deepLink = data?.link;

      if (deepLink != null) {
        if (onLinkReceived != null) {
          onLinkReceived(data);
        } else {
          print(deepLink.toString());
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<Uri> getLinkFromFirebase(String path) async {
    PendingDynamicLinkData data = await FirebaseDynamicLinks.instance
        .getDynamicLink(Uri.parse('https://$prefix$path'));
    return data.link;
  }
}
