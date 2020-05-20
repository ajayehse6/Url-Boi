import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class DynamicLinksService {
  Future<Uri> createDynamicLink(String url) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://urlboi.page.link',
      link: Uri.parse(url.trim()),
    );
    final Uri longDynamicUrl = await parameters.buildUrl();
    final ShortDynamicLink shortenedLink = await DynamicLinkParameters.shortenUrl(
      longDynamicUrl,
      new DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short),
    );
    final Uri shortUrl = shortenedLink.shortUrl;
    print(shortUrl);
    return shortUrl;
  }
}
