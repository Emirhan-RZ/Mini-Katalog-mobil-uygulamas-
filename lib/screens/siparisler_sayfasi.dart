
import 'package:flutter/material.dart';
import '../models/global_veri.dart';

class SiparislerSayfasi extends StatelessWidget {
  const SiparislerSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], 
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E), 
        elevation: 0,
        title: const Text(
          "Sipariş Geçmişim", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: siparisGecmisi.isEmpty
          ? _bosSiparisEkrani()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: siparisGecmisi.length,
              itemBuilder: (context, index) {
                final siparis = siparisGecmisi[index];
                
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  shadowColor: Colors.black12,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: ExpansionTile(
                    shape: const Border(), 
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_circle, color: Colors.green, size: 28),
                    ),
                    title: Text(
                      "Sipariş: ${siparis.siparisNo}", 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)
                    ),
                    subtitle: Text(
                      "${siparis.tarih}  •  ${siparis.toplamTutar} ₺", 
                      style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.w600)
                    ),
                    children: [
                      const Divider(indent: 16, endIndent: 16),
                      ...siparis.urunler.map((urun) => ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(urun.resimUrl, width: 45, height: 45, fit: BoxFit.cover),
                        ),
                        title: Text(urun.ad, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        trailing: Text(
                          "${urun.fiyat} ₺", 
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey)
                        ),
                      )).toList(),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              },
            ),
    );
  }


  Widget _bosSiparisEkrani() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.shopping_basket_outlined, size: 80, color: Colors.grey[400]),
          ),
          const SizedBox(height: 20),
          const Text(
            "Henüz sipariş vermediniz.", 
            style: TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 10),
          const Text(
            "HamsiExpress'de keşfe çıkmaya ne dersin?", 
            style: TextStyle(color: Colors.grey)
          ),
        ],
      ),
    );
  }
}