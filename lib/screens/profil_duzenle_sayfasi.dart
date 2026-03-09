
import 'package:flutter/material.dart';
import '../models/global_veri.dart';

class ProfilDuzenleSayfasi extends StatefulWidget {
  final VoidCallback sayfayiYenile;
  const ProfilDuzenleSayfasi({super.key, required this.sayfayiYenile});

  @override
  State<ProfilDuzenleSayfasi> createState() => _ProfilDuzenleSayfasiState();
}

class _ProfilDuzenleSayfasiState extends State<ProfilDuzenleSayfasi> {
  late TextEditingController _adController;
  late TextEditingController _yeniAdresController;
  final TextEditingController _adresBaslikController = TextEditingController();
  
  String? _seciliCinsiyet;
  String? _seciliMedeniDurum;

  @override
  void initState() {
    super.initState();
    _adController = TextEditingController(text: mevcutKullaniciAdi);
    _yeniAdresController = TextEditingController();
    _seciliCinsiyet = mevcutCinsiyet;
    _seciliMedeniDurum = mevcutMedeniDurum;
  }

  void yeniAdresEkle() {
    if (_adresBaslikController.text.isNotEmpty && _yeniAdresController.text.isNotEmpty) {
      setState(() {
        adresDefteri[_adresBaslikController.text] = _yeniAdresController.text;
      });
      _adresBaslikController.clear();
      _yeniAdresController.clear();
      widget.sayfayiYenile();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Adres defterine başarıyla eklendi!"), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lütfen başlık ve adres alanını doldurun!"), backgroundColor: Colors.orange),
      );
    }
  }

  void bilgileriKaydet() {
    setState(() {
      mevcutKullaniciAdi = _adController.text;
      mevcutCinsiyet = _seciliCinsiyet ?? "Belirtilmemiş";
      mevcutMedeniDurum = _seciliMedeniDurum ?? "Belirtilmemiş";
    });
    widget.sayfayiYenile(); 
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profil başarıyla güncellendi!"), backgroundColor: Colors.teal),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Profilimi Düzenle", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Kişisel Bilgiler", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
            const SizedBox(height: 15),
            _inputKutusu("Ad Soyad", _adController, Icons.person_outline),
            const SizedBox(height: 15),
            
            
            Row(
              children: [
                Expanded(
                  child: _dropdownSecici("Cinsiyet", ["Belirtilmemiş", "Erkek", "Kadın"], _seciliCinsiyet, (val) => setState(() => _seciliCinsiyet = val)),
                ),
                const SizedBox(width: 10), 
                Expanded(
                  child: _dropdownSecici("Durum", ["Belirtilmemiş", "Bekar", "Evli"], _seciliMedeniDurum, (val) => setState(() => _seciliMedeniDurum = val)),
                ),
              ],
            ),
            
            const SizedBox(height: 30),
            const Divider(thickness: 1),
            const SizedBox(height: 20),
            
            const Text("Adres Defterine Ekle", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
            const SizedBox(height: 15),
            _inputKutusu("Adres Başlığı (Örn: İş, Yazlık)", _adresBaslikController, Icons.bookmark_border),
            const SizedBox(height: 15),
            _inputKutusu("Tam Adres", _yeniAdresController, Icons.map_outlined, maxLines: 2),
            const SizedBox(height: 15),
            
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: yeniAdresEkle, 
                icon: const Icon(Icons.add_location_alt),
                label: const Text("ADRESİ LİSTEYE EKLE"),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.teal,
                  side: const BorderSide(color: Colors.teal),
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ),
            
            const SizedBox(height: 50),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87, 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 5,
                ),
                onPressed: bilgileriKaydet,
                child: const Text("TÜM DEĞİŞİKLİKLERİ KAYDET", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputKutusu(String etiket, TextEditingController controller, IconData ikon, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: etiket,
        prefixIcon: Icon(ikon, color: Colors.blueGrey),
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade300)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade200)),
      ),
    );
  }

  Widget _dropdownSecici(String etiket, List<String> liste, String? seciliDeger, Function(String?) degisim) {
    return DropdownButtonFormField<String>(
      isExpanded: true, 
      value: seciliDeger,
      icon: const Icon(Icons.arrow_drop_down, size: 20), 
      decoration: InputDecoration(
        labelText: etiket, 
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), 
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: Colors.grey.shade200)),
        prefixIcon: const Icon(Icons.info_outline, color: Colors.blueGrey, size: 18),
      ),
      items: liste.map((String deger) => DropdownMenuItem(
        value: deger, 
        child: Text(deger, style: const TextStyle(fontSize: 12)) 
      )).toList(),
      onChanged: degisim,
    );
  }
}