import 'dart:mirrors';
import 'package:type_plus/type_plus.dart';

import 'helpers/helpers.dart';

String symbolName(Symbol symbol) {
  final str = symbol.toString();
  return str.substring(8, str.length - 2);
}

mixin class Model {
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

    return classReflection.newInstance(
      Symbol.empty,
      [],
      json.map((key, value) {
        var type =
            (classReflection.declarations[Symbol(key)] as VariableMirror).type;
        final reflectedType = type.reflectedType;

        return MapEntry(Symbol(key), typeMapper(reflectedType, value));
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

dynamic fundamentalTypeMapper(Type reflectedType, dynamic value) {
  switch (reflectedType) {
    case int:
      return parseInt(value);
    case double:
      return parseDouble(value);
    case String:
      return value as String;
    case bool:
      return parseBool(value);
    case Symbol:
      return parseSymbol(value);
  }
  return containerObjectTypeMapper(reflectedType, value);
}

dynamic containerObjectTypeMapper(Type reflectedType, dynamic value) {
  if (reflectType(reflectedType).isSubtypeOf(reflectType(List))) {
    final elementType =
        reflectType(reflectedType).typeArguments[0].reflectedType;

    if (reflectType(elementType).isSubtypeOf(reflectType(List))) {
      for (final elem in value) containerObjectTypeMapper(elementType, elem);
    }
    return listFromDynamic
        .callWith(typeArguments: [elementType], parameters: [value]);
  }

  if (reflectType(reflectedType).isSubtypeOf(reflectType(Map))) {}

  /* For some reason reflectClass(reflectedType).mixin doesn't evaluate
   * to mixin, so this is a workaround
  */
  if (symbolName(reflectClass(reflectedType).superclass!.simpleName)
      .contains("Model")) {
    return Model.fromJson.callWith(
      typeArguments: [reflectedType],
      parameters: [value],
    );
  }
}

dynamic typeMapper(Type reflectedType, dynamic value) {
  return fundamentalTypeMapper(reflectedType, value);
}

List<T> listFromDynamic<T>(List<dynamic> value) =>
    List.castFrom<dynamic, T>(value.map((e) => typeMapper(T, e)).toList());
