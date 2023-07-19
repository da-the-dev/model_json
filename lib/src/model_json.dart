import 'dart:mirrors';

mixin class Model {
  static String symbolName(Symbol symbol) {
    final str = symbol.toString();
    return str.substring(8, str.length - 2);
  }

  Map<String, dynamic> toJson() {
    var json = Map<String, dynamic>();
    final instanceReflection = reflect(this);
    final classReflection = reflectClass(this.runtimeType);

    for (final entry in classReflection.declarations.entries) {
      if (entry.value is VariableMirror) {
        final value = instanceReflection.getField(entry.key).reflectee;
        json[symbolName(entry.key)] = value;
      }
    }

    return json;
  }

  static T fromJson<T>(Map<String, dynamic> json) {
    final classReflection = reflectClass(T);

    classReflection.declarations.forEach((symbol, declaration) {
      if (declaration is VariableMirror) {
        String fieldName = MirrorSystem.getName(symbol);
        Type fieldType = declaration.type.reflectedType;

        print('Field Name: $fieldName');
        print('Field Type: $fieldType');
      }
    });

    return classReflection.newInstance(
      Symbol.empty,
      [],
      json.map((key, value) {
        final type =
            (classReflection.declarations[Symbol(key)] as VariableMirror)
                .type
                .reflectedType;

        switch (type) {
          case int:
            return MapEntry(Symbol(key), int.parse(value));
          case double:
            return MapEntry(Symbol(key), double.parse(value));
          case String:
            return MapEntry(Symbol(key), value.toString());
          case bool:
            return MapEntry(Symbol(key), bool.tryParse(value));
          case Record:
            throw Exception("Records are not supported as member fields");
          case Set:
            throw Exception("Sets are not supported as member fields");
          case Map:
            throw Exception("Maps are not supported as member fields");
          case Symbol:
            return MapEntry(Symbol(key), Symbol(value));
        }

        if (value.runtimeType == List<dynamic>) {
          final elementType =
              (classReflection.declarations[Symbol(key)] as VariableMirror)
                  .type
                  .typeArguments[0]
                  .reflectedType;
          switch (elementType) {
            case int:
              return MapEntry(Symbol(key), List<int>.from(value));
            case double:
              return MapEntry(Symbol(key), List<double>.from(value));
            case String:
              return MapEntry(Symbol(key), List<String>.from(value));
            case bool:
              return MapEntry(Symbol(key), List<bool>.from(value));
            case Record:
              throw Exception(
                  "Records are not supported as type argument for member lists");
            case List:
              throw Exception(
                  "Lists are not supported as type argument for member lists");
            case Set:
              throw Exception(
                  "Sets are not supported as type argument for member lists");
            case Map:
              throw Exception(
                  "Maps are not supported as type argument for member lists");
            case Symbol:
              return MapEntry(Symbol(key), List<Symbol>.from(value));
            default:
              throw Exception("Unsupported type conversion");
          }
        }
        throw Exception("Unsupported type conversion");
      }),
    ).reflectee;
  }

  List<Object?> get props {
    final instanceReflection = reflect(this);
    final classReflection = reflectClass(instanceReflection.runtimeType);

    return classReflection.declarations.entries
        .where((entry) => entry is VariableMirror)
        .map((e) => e.value)
        .toList();
  }
}
