class UrlHandler {
  // TO PATH ENDPOINT FOR BEASE URL .
  static String url(String endPoint) {
    var url = 'https://placeapp-6247b-default-rtdb.firebaseio.com/' + endPoint;
    return url;
  }
}
