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
        title: const Text('Article'),
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
          Text(article['title']),
          Text(article['description']),
          Text(article['content']),
          TextButton(
            onPressed: () {
              _launchURL(context, article['url']);
            },
            child: const Text('Read More'),
          ),
        ],
      ),
    );
  }
}
