class ConfigItem<T> {
  final String id;
  final T defaultValue;
  final Map<T, int>? testSegments;
  final double sampleSize;
  final bool enabled;

  ConfigItem(
    this.id,
    this.defaultValue,
    this.testSegments,
    this.sampleSize, {
    required this.enabled,
  });

  List<T>? get values => testSegments?.keys.toList();
}
