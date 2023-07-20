part of converters;

int? parseInt(dynamic value) => value is int ? value : int.tryParse(value);
double? parseDouble(dynamic value) => value is double ? value : double.tryParse(value);
bool? parseBool(dynamic value) => value is bool ? value : bool.tryParse(value);
Symbol parseSymbol(dynamic value) => value is Symbol ? value : Symbol(value);
