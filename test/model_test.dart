import 'package:model/model.dart';
import 'package:test/test.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable with Model {
  final String id;
  final String name;
  final List<String> list;

  User({
    required this.id,
    required this.name,
    required this.list,
  });

  // TODO: This preferably should be moved to Model
  @override
  List<Object?> get props => [id, name];

  // TODO: This should be moved to Model
  static User get empty => User(
        id: "",
        name: "",
        list: [],
      );
}

void main() {
  test("class to json", () {
    final user = User(
      id: "543efgtyt543erew",
      name: "john doe",
      list: ["hello", "world"],
    );
    expect(
      user.toJson(),
      {
        "id": "543efgtyt543erew",
        "name": "john doe",
        "list": ['hello', 'world']
      },
    );
  });

  test("class from json", () {
    User user = Model.fromJson({
      "id": "543efgtyt543erew",
      "name": "john doe",
      "list": ["hello", "world"]
    });
    expect(
      user,
      User(id: "543efgtyt543erew", name: "john doe", list: ["hello", "world"]),
    );
  });
}
