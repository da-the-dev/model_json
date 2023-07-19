# model_json
This package helps you with managing object models for databases.

## Getting started
Define some object for a database, for example `User`, extend it from `Equatable` and mixin `Model`.
```dart
class User extends Equatable with Model {
  final String id;
  final String name;
  final List<String> list;

  User({
    required this.id,
    required this.name,
    required this.list,
  });
}
```

## Usage
### Parse from JSON
Say we send a request `GET /user?id=` and the response body contains a user object as JSON. Let's parse it:

```dart
final client = http.Client;
final uri = Uri(
    scheme: "http",
    host: "localhost",
    port: 5000,
    path: "/user",
    queryParameters: {"id": "awd3512gf"},
);
final response = await client.get(uri);

final user = Model.fromJson<User>(response.body);
```

### Parse to JSON
All classes that mixin `Model` have `toJSON` method. Say we want to save a user object in the database with a request `POST /user?id=&name=&list=`

```dart
final client = http.Client;
final uri = Uri(
    scheme: "http",
    host: "localhost",
    port: 5000,
    path: "/user",
    queryParameters: User.toJson(),
);
final response = await client.post(uri);
```
 
## Comparison of objects
`User` extends `Equatable`, and `Model` implements `props` method. So `User` objects now can be compared by value.

```dart
final test1 = User(id: '1', name: 'john doe', list: ['hello', 'world']);
final test2 = User(id: '1', name: 'john doe', list: ['hello', 'world]');

test1 == test2; // true
```

# Contributors
- Alexey Tkachenko (@da-the-dev)
- Michael Zimin (@N0taName)

