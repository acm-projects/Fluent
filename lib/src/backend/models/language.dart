/// Represents a language.
class Language {
  /// This language's ISO 639-1 code.
  /// For more information, see [here](https://en.wikipedia.org/wiki/ISO_639-1).
  String iso639;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Language &&
          runtimeType == other.runtimeType &&
          iso639 == other.iso639;

  @override
  int get hashCode => iso639.hashCode;
}
