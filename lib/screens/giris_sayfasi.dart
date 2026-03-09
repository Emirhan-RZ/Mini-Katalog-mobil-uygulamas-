import 'package:flutter/material.dart';
import '../models/global_veri.dart';

class GirisSayfasi extends StatefulWidget {
  const GirisSayfasi({super.key});

  @override
  State<GirisSayfasi> createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  final TextEditingController _kullaniciAdiController = TextEditingController();
  final TextEditingController _sifreController = TextEditingController();

  void sistemeGirisYap() {
    String girilenEposta = _kullaniciAdiController.text; 
    String girilenSifre = _sifreController.text;

    if (girilenEposta == kayitliEposta && girilenSifre == kayitliSifre && kayitliEposta != "") {
      
      Navigator.pushReplacementNamed(context, '/ana_sayfa');
    } else if (kayitliEposta == "") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Sistemde kayıtlı kullanıcı bulunamadı. Lütfen kayıt olun!"), backgroundColor: Colors.orange));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("E-posta veya Şifre Hatalı!"), backgroundColor: Colors.redAccent));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.storefront, size: 80, color: Colors.deepOrangeAccent)),
              const SizedBox(height: 20),
              const Text("HamsiExpress", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 3)),
              const SizedBox(height: 50),
              Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, spreadRadius: 5)]),
                child: Column(
                  children: [
                    TextField(controller: _kullaniciAdiController, decoration: InputDecoration(labelText: "E-posta", prefixIcon: const Icon(Icons.person_outline), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)))),
                    const SizedBox(height: 20),
                    TextField(controller: _sifreController, obscureText: true, decoration: InputDecoration(labelText: "Şifre", prefixIcon: const Icon(Icons.lock_outline), border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)))),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity, height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.black87, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                        onPressed: sistemeGirisYap, child: const Text("GİRİŞ YAP", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                      ),
                    ),
                    TextButton(
                      
                      onPressed: () => Navigator.pushNamed(context, '/kayit'),
                      child: const Text("Hesabınız yok mu? Kayıt Olun", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}