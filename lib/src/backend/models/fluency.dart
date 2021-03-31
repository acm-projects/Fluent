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
