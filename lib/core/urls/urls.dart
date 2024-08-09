enum Url {
  signupUrl(endpoint: "/api/auth/firebase/signup"),
  signinUrl(endpoint: "/api/auth/firebase/signin"),
  verifyOTPUrl(endpoint: "api/verify_otp"),
  verifyTokenUrl(endpoint: "/verify_token"),
  homeUrl(endpoint: "/api/auth/firebase/me"),
  addDataUrl(endpoint: "/api/firestore/data"),
  becomeATeacherUrl(endpoint: "/api/admin/signup"),
  listDataUrl(endpoint: '/api/firestore/datas'),
  deleteDataUrl(endpoint: "/api/firestore/data/"),
  deleteMultipleDataUrl(endpoint: "/api/firestore/data/list"),
  getDataByIdUrl(endpoint: "/api/firestore/data/"),
  logoutUrl(endpoint: "/api/auth/logout"),
  refreshUrl(endpoint: "/api/auth/refresh"),
  deleteAccount(endpoint: "/api/user/firebase/profile"),
  updateUser(endpoint: "/api/user/firebase/profile"),
  updateProfilePicture(endpoint: "/api/user/firebase/profile/picture"),
  changePasswordUrl(endpoint: "/api/user/profile/password"),
  fUrl(endpoint: "/verify_otp");

  final String endpoint;

  const Url({required this.endpoint});
}

getUri(
    {String? path,
    Map<String, dynamic>? queryParams,
    required String endpoint}) {
  String baseUrl = 'gemini-server-1.onrender.com';
  var url = Uri.https(baseUrl, endpoint + (path ?? ""), queryParams);

  return url;
}
