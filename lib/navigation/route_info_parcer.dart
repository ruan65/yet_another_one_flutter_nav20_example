import 'package:flutter/cupertino.dart';
import 'package:navigator_v2_sample_app/navigation/app_route_path.dart';

class RouteInfoParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);
    final segments = uri.pathSegments;
    if (segments.length == 0) {
      return AppRoutePath.home();
    }

    if (segments.length == 2 && segments.first == 'book') {
      final rem = uri.pathSegments.elementAt(1);
      final id = int.tryParse(rem);
      if (null != id) {
        return AppRoutePath.details(id);
      }
    }
    return AppRoutePath.unknown();
  }

  @override
  RouteInformation restoreRouteInformation(AppRoutePath path) {
    if (path.isUnknown) return RouteInformation(location: '/404');
    if (path.isHomePage) return RouteInformation(location: '/');
    if (path.isDetailsPage) {
      return RouteInformation(location: '/book/${path.id}');
    }
    return null;
  }
}
