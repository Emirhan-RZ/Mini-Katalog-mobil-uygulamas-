import 'urun.dart';

List<Urun> globalSepet = [];
Map<String, String> adresDefteri = {
  "Ev": "Uskudar, İstanbul, Türkiye", 
};
String seciliSiparisAdresi = "Ev";
List<Siparis> siparisGecmisi = [];

class Siparis {
  final String siparisNo;
  final String tarih;
  final double toplamTutar;
  final List<Urun> urunler;

  Siparis({required this.siparisNo, required this.tarih, required this.toplamTutar, required this.urunler});
}

List<Urun> favoriUrunler = [];

String mevcutKullaniciAdi = "Misafir Kullanıcı"; 
String kayitliEposta = ""; 
String kayitliSifre = ""; 
String mevcutCinsiyet = "Belirtilmemiş";
String mevcutMedeniDurum = "Belirtilmemiş";