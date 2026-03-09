
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/global_veri.dart';

class OdemeSayfasi extends StatefulWidget {
  final VoidCallback sayfayiYenile; 

  const OdemeSayfasi({super.key, required this.sayfayiYenile});

  @override
  State<OdemeSayfasi> createState() => _OdemeSayfasiState();
}

class _OdemeSayfasiState extends State<OdemeSayfasi> {
  
  final TextEditingController _adresController = TextEditingController();
  final TextEditingController _kartNoController = TextEditingController();
  final TextEditingController _sktController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    
    _adresController.text = adresDefteri[seciliSiparisAdresi] ?? "";
  }

  
  void siparisiTamamla() {
    
    if (_adresController.text.isEmpty || _kartNoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen adres ve kart bilgilerini doldurun!"), backgroundColor: Colors.red),
      );
      return;
    }

    
    double toplam = globalSepet.fold(0, (sum, item) => sum + item.fiyat);

    
    String siparisNo = "SPRS-${Random().nextInt(90000) + 10000}";
    String tarih = "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";

    
    Siparis yeniSiparis = Siparis(
      siparisNo: siparisNo,
      tarih: tarih,
      toplamTutar: toplam,
      urunler: List.from(globalSepet),
    );
    siparisGecmisi.insert(0, yeniSiparis);

    
    globalSepet.clear();
    widget.sayfayiYenile();

    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Siparişiniz başarıyla alındı! 🎉"), 
        backgroundColor: Colors.green, 
        duration: Duration(seconds: 2)
      ),
    );
    Navigator.pop(context); 
  }

  @override
  Widget build(BuildContext context) {
    double toplamTutar = globalSepet.fold(0, (sum, item) => sum + item.fiyat);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E), 
        title: const Text("Güvenli Ödeme", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            const Text("Teslimat Adresi", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 15),
            
            
            const Text("Kayıtlı Adreslerim", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey, fontSize: 14)),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: adresDefteri.keys.map((String baslik) {
                  bool seciliMi = seciliSiparisAdresi == baslik;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        seciliSiparisAdresi = baslik;
                        _adresController.text = adresDefteri[baslik]!;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: seciliMi ? Colors.deepOrange : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: seciliMi ? Colors.deepOrange : Colors.grey.shade300),
                        boxShadow: seciliMi ? [BoxShadow(color: Colors.deepOrange.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))] : [],
                      ),
                      child: Text(
                        baslik, 
                        style: TextStyle(
                          color: seciliMi ? Colors.white : Colors.black87, 
                          fontWeight: FontWeight.bold
                        )
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 15),

            
            TextField(
              controller: _adresController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Adres detayı...",
                prefixIcon: const Icon(Icons.location_on, color: Colors.deepOrange),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade200)),
              ),
            ),
            const SizedBox(height: 30),

            
            const Text("Ödeme Bilgileri", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white, 
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade200)
              ),
              child: Column(
                children: [
                  TextField(
                    controller: _kartNoController,
                    keyboardType: TextInputType.number,
                    maxLength: 16,
                    decoration: const InputDecoration(labelText: "Kart Numarası", prefixIcon: Icon(Icons.credit_card), border: InputBorder.none),
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _sktController,
                          keyboardType: TextInputType.datetime,
                          maxLength: 5,
                          decoration: const InputDecoration(labelText: "SKT (AA/YY)", prefixIcon: Icon(Icons.date_range), border: InputBorder.none),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextField(
                          controller: _cvvController,
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          obscureText: true,
                          decoration: const InputDecoration(labelText: "CVV", prefixIcon: Icon(Icons.security), border: InputBorder.none),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 40),

            
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: siparisiTamamla,
                icon: const Icon(Icons.check_circle_outline, size: 28),
                label: Text("Ödemeyi Tamamla ($toplamTutar ₺)"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  elevation: 5,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}