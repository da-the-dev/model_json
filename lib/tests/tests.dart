import 'package:model/model.dart';
import 'package:test/test.dart';

class User with Model {
  final String id;
  final String name;

  User({
    required this.id,
    required this.name,
  });
}

void main() {
  test("class to json", () {
    final user = User(id: "543efgtyt543erew", name: "john doe");
    expect(
      user.toJson(),
      {
        "id": "543efgtyt543erew",
        "name": "john doe",
      },
    );
  });
}
