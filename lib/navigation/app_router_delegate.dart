import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:navigator_v2_sample_app/book.dart';
import 'package:navigator_v2_sample_app/book_page.dart';
import 'package:navigator_v2_sample_app/main.dart';
import 'package:navigator_v2_sample_app/navigation/app_route_path.dart';
import 'package:navigator_v2_sample_app/unknown_page.dart';

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  Book _selectedBook;
  bool _show404 = false;

  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  AppRoutePath get currentConfiguration {
    if (_show404) {
      return AppRoutePath.unknown();
    }
    if (null == _selectedBook) {
      return AppRoutePath.home();
    }
    return AppRoutePath.details(books.indexOf(_selectedBook));
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
            key: ValueKey('HomePage'),
            child: HomePage(onBookTap: _handleBookTap)),
        if (_show404)
          MaterialPage(key: ValueKey('UnknownPage'), child: UnknownPage())
        else if (null != _selectedBook)
          MaterialPage(
              key: ValueKey('BookPage'), child: BookPage(book: _selectedBook)),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        _selectedBook = null;
        _show404 = false;
        notifyListeners();
        return true;
      },
    );
  }

  void _handleBookTap(Book book) {
    _selectedBook = book;
    notifyListeners();
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath path) async {
    if (path.isUnknown) {
      _show404 = true;
      _selectedBook = null;
      return;
    }
    if (path.isDetailsPage) {
      final id = path.id;

      if (id.isNegative || id > books.length - 1) {
        _show404 = true;
        return;
      }

      _selectedBook = books[id];
    } else {
      _selectedBook = null;
    }
    _show404 = false;
  }
}
