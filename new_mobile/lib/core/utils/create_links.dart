import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinks {
  static Future<String> createDynamicLink({required String route}) async {
    final androidUninstalledFallback = Uri.parse(
      "https://play.google.com/store/apps/details?id=academy.skillbridge.skill_bridge_mobile",
    ); // Uninstalled app fallback
    final iosUninstalledFallback = Uri.parse('uri');

    // Construct DynamicLinkParameters with customized fallbacks
    final parameters = DynamicLinkParameters(
      androidParameters: AndroidParameters(
        packageName: "academy.skillbridge.skill_bridge_mobile",
        minimumVersion: 0,
        fallbackUrl: androidUninstalledFallback,
      ),
      googleAnalyticsParameters: const GoogleAnalyticsParameters(
        source: 'userid',
        medium: 'share',
        campaign: 'your_campaign',
        term: 'your_term',
        content: 'your_content',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        imageUrl: Uri.parse(
            'https://res.cloudinary.com/djrfgfo08/image/upload/v1713254611/SkillBridge/mobile_team_icons/crbouihyqpfdijwyxuhy.png'),
      ),
      iosParameters: IOSParameters(
        bundleId: "academy.skillbridge.skillBridgeMobile",
        minimumVersion: "0",
        fallbackUrl: Uri.parse('https://skillbridge.academy/'),
      ),
      link: Uri.parse("https://skillbridge.academy?route=$route"),
      uriPrefix: "https://skillbridgemobile.page.link",
      navigationInfoParameters: const NavigationInfoParameters(
        forcedRedirectEnabled: true,
      ),
    );

    // Create a short Dynamic Link
    final FirebaseDynamicLinks link = FirebaseDynamicLinks.instance;
    final refLink = await link.buildShortLink(parameters);

    return refLink.shortUrl.toString();
  }

  static Future<String> createReferalLink({required String userId}) async {
    final androidUninstalledFallback = Uri.parse(
      "https://play.google.com/store/apps/details?id=academy.skillbridge.skill_bridge_mobile",
    ); // Uninstalled app fallback
    final iosUninstalledFallback = Uri.parse('uri');

    // Construct DynamicLinkParameters with customized fallbacks
    final parameters = DynamicLinkParameters(
      androidParameters: AndroidParameters(
        packageName: "academy.skillbridge.skill_bridge_mobile",
        minimumVersion: 0,
        fallbackUrl: androidUninstalledFallback,
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        description: 'Share and collect money',
        title: 'SkillBridge referral link',
        imageUrl: Uri.parse(
            'https://res.cloudinary.com/djrfgfo08/image/upload/v1713254611/SkillBridge/mobile_team_icons/crbouihyqpfdijwyxuhy.png'),
      ),
      iosParameters: IOSParameters(
        bundleId: "academy.skillbridge.skillBridgeMobile",
        minimumVersion: "0",
        fallbackUrl: Uri.parse('https://skillbridge.academy/'),
      ),
      link: Uri.parse("https://skillbridge.academy?referalCode=$userId"),
      uriPrefix: "https://skillbridgemobile.page.link",
      navigationInfoParameters: const NavigationInfoParameters(
        forcedRedirectEnabled: true,
      ),
    );

    // Create a short Dynamic Link
    final FirebaseDynamicLinks link = FirebaseDynamicLinks.instance;
    final refLink = await link.buildShortLink(parameters);

    return refLink.shortUrl.toString();
  }
}
