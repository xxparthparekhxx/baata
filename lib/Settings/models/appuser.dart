class appuser {
  String? name;
  String phonenumber;
  String? profileUrl;
  appuser({this.name, required this.phonenumber, this.profileUrl});

  set uname(new_name) {
    name = new_name;
  }
}
