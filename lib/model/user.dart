class User {
  String? id, name, email, phone;
  User({
    required this.name,
    required this.email,
    required this.id,
    //required this.regdate,
    required this.phone,
    //required this.address,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    // address = json['address'];
    //regdate = json['regdate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    //data['address'] = address;
    // data['regdate'] = regdate;
    return data;
    }
}