class Urun {
  final int id;
  final String ad;
  final String aciklama;
  final double fiyat;
  final String kategori; 
  final String resimUrl;

  Urun({required this.id, required this.ad, required this.aciklama, required this.fiyat, required this.kategori, required this.resimUrl});

  factory Urun.fromJson(Map<String, dynamic> json) {
    return Urun(
      id: json['id'],
      ad: json['ad'],
      aciklama: json['aciklama'],
      fiyat: (json['fiyat'] as num).toDouble(),
      kategori: json['kategori'], 
      resimUrl: json['resimUrl'],
    );
  }
}