// Model for scanned item
class ScannedItem {
  final String id;
  final String imageUrl;
  final String type;
  final String result;
  final DateTime scanDate;

  ScannedItem({
    required this.id,
    required this.imageUrl,
    required this.type,
    required this.result,
    required this.scanDate,
  });
}