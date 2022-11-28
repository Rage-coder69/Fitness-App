import 'dart:convert';

import 'package:app/constants.dart';
import 'package:app/screens/article_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  static String id = '/explore_screen';

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String query = '';
  List<dynamic> articles = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadArticles();
  }

  loadArticles() {
    var url = Uri.parse(
        'https://newsapi.org/v2/everything?q=fitness&apikey=$kApiKey');
    http.get(url).then((response) {
      // print(jsonDecode(response.body));
      if (jsonDecode(response.body)['status'] == 'ok') {
        setState(() {
          articles = jsonDecode(response.body)['articles'];
        });
      }
    });
  }

  getArticles(dynamic query) {
    var url =
        Uri.parse('https://newsapi.org/v2/everything?q=$query&apikey=$kApiKey');
    http.get(url).then((response) {
      // print(jsonDecode(response.body));
      if (jsonDecode(response.body)['status'] == 'ok') {
        setState(() {
          articles = jsonDecode(response.body)['articles'];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    /*loadArticles();*/
    print(width);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            padding: EdgeInsets.all(width * 0.05),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.7, 0.9],
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFFFDFCFF),
                  Color(0xFFebebed),
                ],
              ),
            ),
            child: Column(
              children: [
                TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      prefixIconColor: Color(0xE8184045),
                      focusColor: Color(0xE8184045),
                      focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xE8184045), width: 2.0),
                      )
                      /*iconColor: Color(0xE8184045),*/
                      ),
                  cursorColor: Color(0xE8184045),
                  onChanged: (value) {
                    query = value;
                    if (query.isNotEmpty) {
                      Future.delayed(Duration(milliseconds: 500), () {
                        getArticles(query);
                      });
                    } else {
                      loadArticles();
                    }
                  },
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                Expanded(
                  child: FutureBuilder(builder: (context, snapshot) {
                    if (articles.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return ListView.builder(
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                leading: Image.network(
                                  articles[index]['urlToImage'],
                                  width: width * 0.2,
                                  height: height * 0.2,
                                  fit: BoxFit.cover,
                                  frameBuilder: (context, child, frame,
                                      wasSynchronouslyLoaded) {
                                    if (wasSynchronouslyLoaded) {
                                      return child;
                                    }
                                    return AnimatedOpacity(
                                      child: child,
                                      opacity: frame == null ? 0 : 1,
                                      duration: const Duration(seconds: 1),
                                      curve: Curves.easeOut,
                                    );
                                  },
                                ),
                                title: Text(
                                  articles[index]['title'].toString(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  articles[index]['author'].toString(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () {
                                  //dismiss keyboard
                                  SystemChannels.textInput
                                      .invokeMethod('TextInput.hide');
                                  Navigator.pushNamed(context, ArticleScreen.id,
                                      arguments: articles[index]);
                                },
                              ),
                            );
                          });
                    }
                  }),
                )
              ],
            )),
      ),
    );
  }
}

/*ListView.builder(
                    itemCount: articles.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(articles[index]['title']),
                        subtitle: Text(articles[index]['author']),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      );
                    },
                  ),*/
