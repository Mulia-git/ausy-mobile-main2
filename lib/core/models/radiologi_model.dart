import 'radiologi_item.dart';
import 'radiologi_hasil.dart';
import 'radiologi_gambar.dart';

class RadiologiModel {
  final List<RadiologiItem> pemeriksaan;
  final List<RadiologiHasil> hasil;
  final List<RadiologiGambar> gambar;

  RadiologiModel.fromJson(Map<String, dynamic> j)
      : pemeriksaan = (j['pemeriksaan'] as List? ?? [])
      .map((e) => RadiologiItem.fromJson(e))
      .toList(),
        hasil = (j['hasil'] as List? ?? [])
            .map((e) => RadiologiHasil.fromJson(e))
            .toList(),
        gambar = (j['gambar'] as List? ?? [])
            .map((e) => RadiologiGambar.fromJson(e))
            .toList();
}
