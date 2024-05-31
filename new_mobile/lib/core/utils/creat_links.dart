import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

Future<String> createDynamicLink(
    {required String id, required String pageName}) async {
  // Define fallbacks based on platform and app installation status
  const desktopFallback = "https://skillbridge.academy/"; // Desktop fallback
  final androidUninstalledFallback = Uri.parse(
      "https://play.google.com/store/apps/details?id=academy.skillbridge.skill_bridge_mobile"); // Uninstalled app fallback
  final iosUninstalledFallback = Uri.parse('uri');

  // Construct DynamicLinkParameters with customized fallbacks
  final parameters = DynamicLinkParameters(
    googleAnalyticsParameters: const GoogleAnalyticsParameters(),
    androidParameters: AndroidParameters(
      packageName: "academy.skillbridge.skill_bridge_mobile",
      minimumVersion: 0,
      fallbackUrl: androidUninstalledFallback,
    ),
    iosParameters: IOSParameters(
      bundleId: "academy.skillbridge.skillBridgeMobile",
      minimumVersion: "0",
      fallbackUrl: Uri.parse(desktopFallback),
    ),
    link: Uri.parse("$desktopFallback?page=$pageName&id=$id"),
    uriPrefix: "https://skillbridgemobile.page.link",
    navigationInfoParameters: const NavigationInfoParameters(),
  );

  // Create a short Dynamic Link
  final FirebaseDynamicLinks link = FirebaseDynamicLinks.instance;
  final refLink = await link.buildShortLink(parameters);

  return refLink.shortUrl.toString();
}
