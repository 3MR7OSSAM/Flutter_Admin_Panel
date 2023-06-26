import 'package:hive/hive.dart';
part 'user_model.g.dart';
@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  final String userName;
  @HiveField(1)
  final String password;
  @HiveField(2)
  final int pinCode;

  UserModel({required this.userName,required this.password,required this.pinCode});
}