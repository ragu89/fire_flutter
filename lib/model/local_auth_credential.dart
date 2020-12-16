class LocalAuthCredential {
  final String accessToken;
  final String idToken;

  LocalAuthCredential(this.accessToken, this.idToken);

  LocalAuthCredential.fromJson(Map<String, dynamic> json)
      : accessToken = json['accessToken'],
        idToken = json['idToken'];

  Map<String, dynamic> toJson() => {
        '"accessToken"': '"$accessToken"',
        '"idToken"': '"$idToken"',
      };
}
