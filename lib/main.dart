import 'package:flutter/material.dart';
import 'package:navigator_v2_sample_app/book.dart';
import 'package:navigator_v2_sample_app/fake_widgets.dart';

import 'book_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Book _selectedBook;

  void _handleBookTap(Book book) {
    setState(() {
      _selectedBook = book;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          color: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
        ),
      ),
      home: Navigator(
        pages: [
          MaterialPage(child: HomePage(onBookTap: _handleBookTap)),
          if (null != _selectedBook)
            MaterialPage(child: BookPage(book: _selectedBook)),
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) {
            return false;
          }
          setState(() {
            _selectedBook = null;
          });
          return true;
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final ValueChanged<Book> onBookTap;

  const HomePage({Key key, @required this.onBookTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(children: [
          SizedBox(height: 20),
          FakeAppBar(),
          SizedBox(height: 20),
          FakeTabBar(),
          SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              childAspectRatio: 48 / 78,
              shrinkWrap: true,
              crossAxisCount: 2,
              children: List.generate(books.length, (index) {
                final book = books[index];
                return InkWell(
                  onTap: () => onBookTap(book),
                  child: Card(
                    child: Image.asset(
                      book.image,
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              }),
            ),
          )
        ]),
      ),
    );
  }
}
