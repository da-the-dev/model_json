part of converters;

int? parseInt(dynamic value) => int.tryParse(value);
double? parseDouble(dynamic value) => double.tryParse(value);
bool? parseBool(dynamic value) => bool.tryParse(value);
Symbol parseSymbol(dynamic value) => Symbol(value);
