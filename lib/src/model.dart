import 'dart:io';
import 'dart:mirrors';

import 'package:equatable/equatable.dart';

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
        if(value is Model && value.runtimeType != Model){
          json[symbolName(entry.key)] = (value).toJson();
        }else if(value is Iterable && value.runtimeType!= Iterable){
          json[symbolName(entry.key)] = new List<Map<String, dynamic>>.empty(growable: true);
          for (final element in value){
            json[symbolName(entry.key)].add(element.json);
          }
        }else{
          json[symbolName(entry.key)] = (value);
        }
      }
    }

    return json;
  }

  static T fromJson<T>(Map<String, dynamic> json) => reflectClass(T)
      .newInstance(
        Symbol.empty,
        [],
        json.map((key, value) => MapEntry(Symbol(key), value)),
      )
      .reflectee;

  @override
  List<Object?> get props {
    final instanceReflection = reflect(this);
    final classReflection = reflectClass(instanceReflection.runtimeType);

    return classReflection.declarations.entries
        .where((entry) => entry is VariableMirror)
        .map((e) => e.value)
        .toList();
  }
}
