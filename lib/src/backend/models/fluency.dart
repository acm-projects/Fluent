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

extension FluencyOps on Fluency {
  /// Retrieves the fluency number associated with this fluency.
  int get id => this.index + 1;

  /// Retrieves the fluency associated with the given fluency number.
  static Fluency byId(int id) => Fluency.values[id - 1];
}
