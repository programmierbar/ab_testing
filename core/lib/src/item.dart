class ConfigItem<T> {
  final String id;
  final T defaultValue;
  final Map<T, int>? testSegments;
  final List<Language>? languages;
  final double sampleSize;
  final bool paused;

  ConfigItem(
    this.id,
    this.defaultValue,
    this.testSegments,
    this.languages,
    this.sampleSize, {
    required this.paused,
  });

  bool get local => languages != null;

  List<T>? get values => testSegments?.keys.toList();
}
