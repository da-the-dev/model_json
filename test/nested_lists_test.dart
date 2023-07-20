import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:model_json/model_json.dart';
import 'package:test/test.dart';

class Matrix extends Equatable with Model {
  final List<List<int>> matrix;

  Matrix({
    required this.matrix,
  });
}

void main() {
  group("nested lists", () {
    test("matrix from json", () {
      final matrix = Model.fromJson<Matrix>(jsonDecode(jsonEncode({
        "matrix": [
          [1, 2],
          [3, 4],
        ]
      })));

      expect(
          matrix,
          Matrix(matrix: [
            [1, 2],
            [3, 4]
          ]));
    });
  });
}
