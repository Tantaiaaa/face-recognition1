class Profile {
  var email;
  var password;
  var name;
  var id;
  var phone;
  var group;
  var uid;

  Profile({
    this.email,
    this.password,
    this.name,
    this.id,
    this.phone,
    this.group,
    this.uid
  });

  factory Profile.fromMap(map) {
    return Profile(
      email: map['email'],
      password: map['password'],
      name: map['name'],
      id: map['id'],
      group: map['group'],
      phone: map['phone'],
      uid: map['uid']
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'pasword': password,
      'name': name,
      'id': id,
      'group': group,
      'phone': phone,
      'uid': uid
    };
  }
}