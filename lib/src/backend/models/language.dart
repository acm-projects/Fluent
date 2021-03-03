/// Represents a user's fluency level with a given language.
enum Fluency {
  /// Fluency level 1.
  Beginner,

  /// Fluency level 2.
  Intermediate,

  /// Fluency level 3.
  Advanced,

  /// Fluency level 4.
  Fluent,

  /// Fluency level 5.
  Native,
}

Fluency parseFluency(int displayNumber) {
  return Fluency.values[displayNumber - 1];
}

extension FluencyOps on Fluency {
  /// Retrieves the display number associated with this fluency.
  int get displayNumber => this.index + 1;
}

/// Represents a language.
class Language {
  /// This language's ISO 639-1 code.
  /// For more information, see [here](https://en.wikipedia.org/wiki/ISO_639-1).
  String iso639;

  Language(this.iso639);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Language && runtimeType == other.runtimeType && iso639 == other.iso639;

  @override
  int get hashCode => iso639.hashCode;
}
