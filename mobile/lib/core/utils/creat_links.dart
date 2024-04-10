import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

Future<String> createContestLink({required String contestId}) async {
  // Define fallbacks based on platform and app installation status
  const desktopFallback = "https://skillbridge.academy/"; // Desktop fallback
  final androidUninstalledFallback = Uri.parse(
      "https://drive.google.com/drive/folders/1LBIwiJL-_TUXU7q1gbhiGc8xiHVa9CGw?usp=sharing"); // Uninstalled app fallback

  // Construct DynamicLinkParameters with customized fallbacks
  final parameters = DynamicLinkParameters(
    googleAnalyticsParameters: const GoogleAnalyticsParameters(),
    androidParameters: AndroidParameters(
      packageName: "com.example.skill_bridge_mobile",
      minimumVersion: 0,
      fallbackUrl: androidUninstalledFallback,
    ),
    iosParameters: IOSParameters(
      bundleId: "com.example.skill_bridge_mobile",
      minimumVersion: "0",
      fallbackUrl: Uri.parse(desktopFallback),
    ),
    link: Uri.parse("$desktopFallback?contestId=$contestId"),
    uriPrefix: "https://skillbridgemobile.page.link",
    navigationInfoParameters: const NavigationInfoParameters(),
  );

  // Create a short Dynamic Link
  final FirebaseDynamicLinks link = FirebaseDynamicLinks.instance;
  final refLink = await link.buildShortLink(parameters);

  return refLink.shortUrl.toString();
}
