import 'package:flutter/material.dart';
import '../models/global_veri.dart';

class KayitSayfasi extends StatefulWidget {
  const KayitSayfasi({super.key});

  @override
  State<KayitSayfasi> createState() => _KayitSayfasiState();
}

class _KayitSayfasiState extends State<KayitSayfasi> {
  final TextEditingController _adController = TextEditingController();
  final TextEditingController _epostaController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController();

  void kaydiTamamla() {
    if (_adController.text.isNotEmpty && _epostaController.text.isNotEmpty && _sifreController.text.isNotEmpty) {
      setState(() {
        mevcutKullaniciAdi = _adController.text;
        kayitliEposta = _epostaController.text; 
        kayitliSifre = _sifreController.text;   
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Hesabınız oluşturuldu! Giriş yapabilirsiniz."), backgroundColor: Colors.green));
      Navigator.pop(context); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Lütfen tüm alanları doldurun!"), backgroundColor: Colors.orange));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.white)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            const Icon(Icons.person_add_alt_1, size: 70, color: Colors.deepOrangeAccent),
            const SizedBox(height: 20),
            const Text("YENİ HESAP", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2)),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: Column(
                children: [
                  TextField(controller: _adController, decoration: const InputDecoration(labelText: "Ad Soyad", prefixIcon: Icon(Icons.face))),
                  const SizedBox(height: 15),
                  TextField(controller: _epostaController, decoration: const InputDecoration(labelText: "E-posta", prefixIcon: Icon(Icons.email_outlined))),
                  const SizedBox(height: 15),
                  TextField(controller: _sifreController, obscureText: true, decoration: const InputDecoration(labelText: "Şifre", prefixIcon: Icon(Icons.lock_outline))),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity, height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black87, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                      onPressed: kaydiTamamla, child: const Text("KAYIT OL", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}