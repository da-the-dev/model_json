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

  
  static T fromJson<T>(Map<String, dynamic> json) =>
      reflectClass(T)
          .newInstance(
            Symbol.empty,
            [],
            json.map((key, value) => MapEntry(Symbol(key), value)),
          )
          .reflectee;
}
