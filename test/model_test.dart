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

  // TODO: This should be moved to Model
  static User get empty => User(
        id: "",
        name: "",
        list: [],
      );
}


class CompositionTest extends Equatable with Model{
  User? user;
  CompositionTest({this.user});

  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

class MultipleCompositionTest extends Equatable with Model{
  List<User>? users;

  MultipleCompositionTest({
    this.users
  });

  @override
  // TODO: implement props
  List<Object?> get props => [users];

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

  test("composition to json",(){
    User user;
    final CompositionTest compositionTest = CompositionTest(
        user: User(id: "543efgtyt543erew", name: "john doe", list: ["hello", "world"]),
    );
    expect(
        compositionTest.toJson(),
        {
          "user":{
            "id": "543efgtyt543erew",
            "name": "john doe",
            "list": ['hello', 'world']
          }
        }
    );
  });
  test("multiple composition to json",(){
    User user;
    final MultipleCompositionTest compositionTest = MultipleCompositionTest(
        users: [
          User(id: "543efgtyt543erew", name: "john doe", list: ["hello", "world"]),
          User(id: "543efgtyt543erew", name: "john doe", list: ["hello", "world"]),
        ]
    );
    expect(
        compositionTest.toJson(),
        {
          "users": [
            {
            "id": "543efgtyt543erew",
            "name": "john doe",
            "list": ['hello', 'world']
            },
            {
            "id": "543efgtyt543erew",
            "name": "john doe",
            "list": ['hello', 'world']
            },
          ]
        }
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

  group("class props", () {
    test("variable and instance", () {
      final user = User(
          id: "543efgtyt543erew", name: "john doe", list: ["hello", "world"]);
      expect(
        user,
        User(
            id: "543efgtyt543erew", name: "john doe", list: ["hello", "world"]),
      );
    });

    test("instance and instance", () {
      expect(
        User(
            id: "543efgtyt543erew", name: "john doe", list: ["hello", "world"]),
        User(
            id: "543efgtyt543erew", name: "john doe", list: ["hello", "world"]),
      );
    });

    test("variable and variable", () {
      final user1 = User(
          id: "543efgtyt543erew", name: "john doe", list: ["hello", "world"]);
      final user2 = User(
          id: "543efgtyt543erew", name: "john doe", list: ["hello", "world"]);
      expect(
        user1,
        user2,
      );
    });
  });

}
