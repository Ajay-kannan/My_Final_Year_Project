class UserName {
  String? id;
  final String name;
  final String email;

  UserName( {required this.name , required this.email});

  toJson(){
    return {
      "userName" : name ,
      "email" : email
    } ;
  }



}