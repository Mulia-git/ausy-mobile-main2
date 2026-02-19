String formatTanggalIndo(DateTime date) {
  String namaHari;
  switch (date.weekday) {
    case 1:
      namaHari = 'Senin';
      break;
    case 2:
      namaHari = 'Selasa';
      break;
    case 3:
      namaHari = 'Rabu';
      break;
    case 4:
      namaHari = 'Kamis';
      break;
    case 5:
      namaHari = 'Jumat';
      break;
    case 6:
      namaHari = 'Sabtu';
      break;
    case 7:
      namaHari = 'Minggu';
      break;
    default:
      namaHari = '';
  }

  String twoDigit(int n) => n < 10 ? '0$n' : '$n';
  final dd = twoDigit(date.day);
  final mm = twoDigit(date.month);
  final yyyy = date.year;

  return '$namaHari, $dd-$mm-$yyyy';
}

String hariIndo(DateTime date) {
  String namaHari;
  switch (date.weekday) {
    case 1:
      namaHari = 'Senin';
      break;
    case 2:
      namaHari = 'Selasa';
      break;
    case 3:
      namaHari = 'Rabu';
      break;
    case 4:
      namaHari = 'Kamis';
      break;
    case 5:
      namaHari = 'Jumat';
      break;
    case 6:
      namaHari = 'Sabtu';
      break;
    case 7:
      namaHari = 'Minggu';
      break;
    default:
      namaHari = '';
  }

  return namaHari;
}
