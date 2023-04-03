import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

class ArticleScreen extends StatefulWidget {
  ArticleScreen({Key? key}) : super(key: key);
  static String id = '/article_screen';

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  Future<void> _launchUrl(String url) async {
    /*final uri = Uri.parse(url);
    */ /*await launchUrl(Uri.parse(url), mode: LaunchMode.inAppWebView);*/ /*
    if (!await launchUrl(uri, mode: LaunchMode.platformDefault)) {
      throw 'Could not launch $uri';
    }*/
  }

  void _launchURL(BuildContext context, String url) async {
    try {
      launch(url,
          customTabsOption: CustomTabsOption(
            toolbarColor: Theme.of(context).primaryColor,
          ));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final dynamic article = ModalRoute.of(context)?.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: const Text('Article'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Color(0xE8184045),
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0xE8184045),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 200.0,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(article['urlToImage']),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
              child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  article['title'].toString(),
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  article['description'].toString(),
                  style: const TextStyle(
                    color: Color(0xE8184045),
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  article['content'].toString(),
                  style: const TextStyle(
                    color: Color(0xE8184045),
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Color(0xFF184045),
                  ),
                  onPressed: () {
                    _launchURL(context, article['url']);
                  },
                  child: const Text('Read More'),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
