import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:model_json/src/model_json.dart';
import 'package:test/test.dart';
import 'package:type_plus/type_plus.dart';

class Obj extends Equatable with Model {
  final String id;
  final SubObj smolObj;

  Obj({
    required this.id,
    required this.smolObj,
  });
}

class SubObj extends Equatable with Model {
  final String id;

  SubObj({
    required this.id,
  });
}

void main() {
  TypePlus.add<Obj>();
  TypePlus.add<SubObj>();
  group("composition", () {
    test("obj + obj from json", () {
      final obj = Model.fromJson<Obj>(jsonDecode(jsonEncode({
        "id": "123",
        "smolObj": {"id": "123"}
      })));

      expect(obj, Obj(id: "123", smolObj: SubObj(id: "123")));
    });
  });
}
