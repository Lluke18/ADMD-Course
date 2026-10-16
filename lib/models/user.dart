class User{
  final String name;
  final int? age;
  final String? email;

  User({required this.name, this.age, this.email});

  String getDisplayAge(){
    return age == null ? "Age not provided" : age.toString();
  }

}