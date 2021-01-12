class AppRoutePath {
  final int id;
  final bool isUnknown;

  AppRoutePath.home() : id = null,isUnknown = false;
  AppRoutePath.details(this.id) : isUnknown = false;
  AppRoutePath.unknown() : id = null, isUnknown = true;

  bool get isHomePage => id == null;
  bool get isDetailsPage => id != null;
}