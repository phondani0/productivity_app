class LocalUser {
  String id;
  String displayName;
  String photoUrl;
  String email;
  String idToken;
  bool isAuth;

  LocalUser({
    this.id,
    this.displayName,
    this.photoUrl,
    this.email,
    this.idToken,
    this.isAuth,
  });
}
