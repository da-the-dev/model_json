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

  void fromJson(Map<String, dynamic> json) {
    final classReflection = reflectClass(this.runtimeType);
    final instanceReflection = reflect(this);

    for (final entry in classReflection.declarations.entries) {
      if (entry.value is VariableMirror) {
        final fieldName = symbolName(entry.key);
        if (json.containsKey(fieldName)) {
          final value = json[fieldName];
          instanceReflection.setField(entry.key, value);
        }
      }
    }
  }
}
