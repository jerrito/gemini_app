enum Url {
  signupUrl(endpoint: "/api/auth/signup"),
  signinUrl(endpoint: "/api/auth/signin"),
  verifyOTPUrl(endpoint: "api/verify_otp"),
  verifyTokenUrl(endpoint: "/verify_token"),
  homeUrl(endpoint: "/api/auth/me"),
  addDataUrl(endpoint: "/api/data"),
  listDataUrl(endpoint: '/api/data'),
  deleteDataUrl(endpoint: "/api/data/"),
  deleteMultipleDataUrl(endpoint: "/api/data/delete/list"),
  getDataByIdUrl(endpoint: "/api/data/"),
  logoutUrl(endpoint: "/api/auth/logout"),
  refreshUrl(endpoint: "/api/auth/refresh"),
  updateUser(endpoint: "/api/user/profile"),
  updateProfile(endpoint: "/api/user/profile/picture"),
  changePasswordUrl(endpoint: "/api/user/profile/password"),
  fUrl(endpoint: "/verify_otp");

  final String endpoint;

  const Url({required this.endpoint});
}

getUri(
    {String? path,
    Map<String, dynamic>? queryParams,
    required String endpoint}) {
  String baseUrl = 'gemini-server-qpjy.onrender.com';
  var url = Uri.https(baseUrl, endpoint + (path ?? ""), queryParams);

  return url;
}
