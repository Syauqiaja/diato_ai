/// A reading's timestamp, written the way it is read locally.
///
/// Shared by the saved list and the result screen so one reading is not dated
/// two different ways depending on where it is opened.
String formatCalculationDate(DateTime date) {
  final local = date.toLocal();
  const months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];
  final time =
      '${local.hour.toString().padLeft(2, '0')}'
      '.${local.minute.toString().padLeft(2, '0')}';
  return '${local.day} ${months[local.month - 1]} ${local.year} · $time';
}
