/// One physicochemical reading at a station, as recorded in the field sheet.
/// [value] is kept as text because it may carry units or a margin of error
/// (e.g. "19.33±0.84").
final class StationPhysicochemistry {
  final int id;
  final String parameter;
  final String value;

  StationPhysicochemistry({required this.id, required this.parameter, required this.value});

  factory StationPhysicochemistry.fromJson(Map<String, dynamic> json) {
    return StationPhysicochemistry(
      id: json['id'] as int,
      parameter: json['parameter'] as String? ?? '',
      value: json['value']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'parameter': parameter, 'value': value};
  }
}
