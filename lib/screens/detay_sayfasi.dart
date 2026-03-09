import 'package:flutter/material.dart';
import '../models/urun.dart';
import '../models/global_veri.dart';

class DetaySayfasi extends StatefulWidget {
  final Urun secilenUrun;
  final VoidCallback sayfayiYenile;
  const DetaySayfasi({super.key, required this.secilenUrun, required this.sayfayiYenile});

  @override
  State<DetaySayfasi> createState() => _DetaySayfasiState();
}

class _DetaySayfasiState extends State<DetaySayfasi> {
  late bool isFavorite; 
  int seciliRenk = 0;      

  @override
  void initState() {
    super.initState();
    isFavorite = favoriUrunler.any((urun) => urun.id == widget.secilenUrun.id);
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border, 
              color: isFavorite ? Colors.red : Colors.black87,
              size: 28,
            ),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
                if (isFavorite) {
                  favoriUrunler.add(widget.secilenUrun);
                } else {
                  favoriUrunler.removeWhere((urun) => urun.id == widget.secilenUrun.id);
                }
              }); 
              widget.sayfayiYenile(); 
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isFavorite ? "Favorilere eklendi!" : "Favorilerden çıkarıldı!"), 
                  duration: const Duration(seconds: 1),
                  backgroundColor: isFavorite ? Colors.pink : Colors.grey[800],
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                )
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Container(
              width: double.infinity, 
              height: 300,
              color: Colors.white, 
              padding: const EdgeInsets.symmetric(vertical: 20), 
              child: Hero(
                tag: widget.secilenUrun.id, 
                child: Image.asset(widget.secilenUrun.resimUrl, fit: BoxFit.contain),
              ),
            ),
            
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), spreadRadius: 5, blurRadius: 15, offset: const Offset(0, -5))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.secilenUrun.kategori.toUpperCase(), style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                      const Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 18),
                          SizedBox(width: 4),
                          Text("4.5 (245 Yorum)", style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(widget.secilenUrun.ad, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 15),
                  
                  
                  Row(
                    children: [
                      _rozet(Icons.local_shipping, "Hızlı Teslimat", Colors.green),
                      const SizedBox(width: 10),
                      _rozet(Icons.verified, "Orijinal Ürün", Colors.blue),
                    ],
                  ),
                  
                  const SizedBox(height: 30),
                  const Text("Renk Seçeneği", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(children: [_renkSecici(0, Colors.black), _renkSecici(1, Colors.grey), _renkSecici(2, Colors.blueGrey), _renkSecici(3, Colors.brown)]),
                  
                  const SizedBox(height: 30),
                  const Text("Ürün Açıklaması", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(widget.secilenUrun.aciklama, style: const TextStyle(fontSize: 15, color: Colors.black54, height: 1.5)),
                  
                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 20),
                  
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                    children: [
                      const Text("Müşteri Yorumları", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), 
                      TextButton(onPressed: (){}, child: const Text("Tümünü Gör", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)))
                    ]
                  ),
                  const SizedBox(height: 10),
                  
                  _yorumKarti("Ahmet Y.", "2 gün önce", "Ürün tam beklediğim gibi geldi, paketleme çok özenliydi.", 5),
                  _yorumKarti("Selin K.", "1 hafta önce", "Kargo biraz gecikti ama ürünün kalitesi muazzam.", 4),
                  
                  const SizedBox(height: 100), 
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _altSatinAlBar(),
    );
  }

  

  Widget _altSatinAlBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white, 
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, -5))]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Toplam Fiyat", style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
              Text('${widget.secilenUrun.fiyat} ₺', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepOrange)),
            ],
          ),
          ElevatedButton.icon(
            onPressed: () {
              globalSepet.add(widget.secilenUrun);
              widget.sayfayiYenile();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${widget.secilenUrun.ad} sepete eklendi!'),
                  backgroundColor: Colors.teal,
                  behavior: SnackBarBehavior.floating,
                )
              );
              Navigator.pop(context);
            },
            icon: const Icon(Icons.shopping_bag_outlined), 
            label: const Text("Sepete Ekle"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange, 
              foregroundColor: Colors.white, 
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15), 
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 0
            ),
          )
        ],
      ),
    );
  }

  Widget _rozet(IconData ikon, String metin, MaterialColor renk) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), 
      decoration: BoxDecoration(color: renk[50], borderRadius: BorderRadius.circular(8), border: Border.all(color: renk[200]!)), 
      child: Row(children: [Icon(ikon, size: 14, color: renk[800]), const SizedBox(width: 5), Text(metin, style: TextStyle(color: renk[800], fontSize: 11, fontWeight: FontWeight.bold))])
    );
  }

  Widget _renkSecici(int index, Color renk) {
    bool seciliMi = seciliRenk == index;
    return GestureDetector(
      onTap: () { setState(() { seciliRenk = index; }); }, 
      child: Container(
        margin: const EdgeInsets.only(right: 12), 
        padding: const EdgeInsets.all(3), 
        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: seciliMi ? Colors.deepOrange : Colors.transparent, width: 2)), 
        child: CircleAvatar(backgroundColor: renk, radius: 14)
      )
    );
  }

  Widget _yorumKarti(String isim, String tarih, String yorum, int yildizSayisi) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12), 
      padding: const EdgeInsets.all(16), 
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade200)), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, 
            children: [
              Text(isim, style: const TextStyle(fontWeight: FontWeight.bold)), 
              Text(tarih, style: const TextStyle(color: Colors.grey, fontSize: 11))
            ]
          ),
          const SizedBox(height: 8), 
          Row(children: List.generate(5, (index) => Icon(index < yildizSayisi ? Icons.star : Icons.star_border, color: Colors.amber, size: 14))), 
          const SizedBox(height: 8), 
          Text(yorum, style: const TextStyle(color: Colors.black87, fontSize: 13))
        ]
      )
    );
  }
}