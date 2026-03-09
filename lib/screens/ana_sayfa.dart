import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/urun.dart';
import '../models/global_veri.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  List<Urun> tumUrunler = [];
  String seciliKategori = "Tümü"; 
  int seciliSekme = 0; 

  @override
  void initState() {
    super.initState();
    jsonVerisiniYukle();
  }

  Future<void> jsonVerisiniYukle() async {
    final String jsonMetni = await rootBundle.loadString('assets/data/urunler.json');
    final List<dynamic> jsonListesi = json.decode(jsonMetni);
    setState(() => tumUrunler = jsonListesi.map((json) => Urun.fromJson(json)).toList());
  }

  void sayfayiYenile() => setState(() {});

  @override
  Widget build(BuildContext context) {
    List<Urun> gosterilecekUrunler = seciliKategori == "Tümü" ? tumUrunler : tumUrunler.where((u) => u.kategori == seciliKategori).toList();
    final List<Widget> sekmeler = [_anaSayfaIcerigi(gosterilecekUrunler), _favorilerIcerigi(), _sepetIcerigi(), _profilIcerigi()];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white, elevation: 0, centerTitle: true, iconTheme: const IconThemeData(color: Colors.black87),
        title: Text(seciliSekme == 0 ? (seciliKategori == "Tümü" ? "HamsiExpress" : seciliKategori) : seciliSekme == 1 ? "Favorilerim" : seciliSekme == 2 ? "Sepetim" : "Profilim", style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
      ),
      drawer: seciliSekme == 0 ? Drawer(
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF1E1E1E), Color(0xFF3A3A3A)], begin: Alignment.topLeft, end: Alignment.bottomRight)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle), child: const Icon(Icons.storefront, color: Colors.white, size: 40)), const SizedBox(height: 15), const Text('Kategoriler', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.5))])),
              _kategoriListTile("Tümü", Icons.grid_view_rounded), _kategoriListTile("Teknoloji", Icons.laptop_mac_rounded), _kategoriListTile("Giyim", Icons.checkroom_rounded), _kategoriListTile("Ev", Icons.weekend_rounded),
            ],
          ),
        ),
      ) : null,
      body: tumUrunler.isEmpty ? const Center(child: CircularProgressIndicator(color: Colors.black87)) : sekmeler[seciliSekme],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5))]),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, backgroundColor: Colors.white, currentIndex: seciliSekme, selectedItemColor: Colors.deepOrange, unselectedItemColor: Colors.grey[400], showUnselectedLabels: true,
          onTap: (index) => setState(() => seciliSekme = index),
          items: [
            const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Keşfet'),
            BottomNavigationBarItem(icon: Icon(favoriUrunler.isNotEmpty ? Icons.favorite : Icons.favorite_border, color: favoriUrunler.isNotEmpty ? Colors.redAccent : Colors.grey[400]), label: 'Favoriler'),
            BottomNavigationBarItem(icon: Stack(children: [const Icon(Icons.shopping_bag_outlined), if (globalSepet.isNotEmpty) Positioned(right: 0, top: 0, child: Container(padding: const EdgeInsets.all(3), decoration: const BoxDecoration(color: Colors.deepOrange, shape: BoxShape.circle), constraints: const BoxConstraints(minWidth: 16, minHeight: 16), child: Text('${globalSepet.length}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center)))]), activeIcon: const Icon(Icons.shopping_bag), label: 'Sepet'),
            const BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }

  ListTile _kategoriListTile(String baslik, IconData ikon) {
    bool seciliMi = seciliKategori == baslik;
    return ListTile(leading: Icon(ikon, color: seciliMi ? Colors.deepOrange : Colors.black87), title: Text(baslik, style: TextStyle(fontSize: 16, fontWeight: seciliMi ? FontWeight.bold : FontWeight.normal, color: seciliMi ? Colors.deepOrange : Colors.black87)), onTap: () { setState(() => seciliKategori = baslik); Navigator.pop(context); });
  }

  Widget _anaSayfaIcerigi(List<Urun> urunler) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (seciliKategori == "Tümü") ...[
          const Padding(padding: EdgeInsets.fromLTRB(16, 20, 16, 10), child: Text("🔥 Öne Çıkanlar", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87))),
          SizedBox(height: 140, child: ListView.builder(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 10), itemCount: tumUrunler.take(3).length, itemBuilder: (context, index) {
            final firsatUrunu = tumUrunler[index];
            return GestureDetector(
              
              onTap: () => Navigator.pushNamed(context, '/detay', arguments: {'urun': firsatUrunu, 'yenile': sayfayiYenile}),
              child: Container(width: 280, margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5), child: Card(elevation: 4, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), color: const Color(0xFF1E1E1E), child: Center(child: ListTile(leading: Container(padding: const EdgeInsets.all(5), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)), child: Image.asset(firsatUrunu.resimUrl, width: 50)), title: Text(firsatUrunu.ad, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), subtitle: Text("${firsatUrunu.fiyat} ₺", style: const TextStyle(color: Colors.deepOrangeAccent, fontWeight: FontWeight.bold)))))),
            );
          })),
        ],
        const Padding(padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0), child: Text("Tüm Ürünler", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87))),
        Expanded(child: GridView.builder(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.72, crossAxisSpacing: 15, mainAxisSpacing: 15), itemCount: urunler.length, itemBuilder: (context, index) {
          final urun = urunler[index];
          return GestureDetector(
            
            onTap: () => Navigator.pushNamed(context, '/detay', arguments: {'urun': urun, 'yenile': sayfayiYenile}),
            child: Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, spreadRadius: 2, offset: const Offset(0, 5))]), child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Hero(tag: urun.id, child: Image.asset(urun.resimUrl, width: 100, height: 100)), const SizedBox(height: 15), Padding(padding: const EdgeInsets.symmetric(horizontal: 10.0), child: Text(urun.ad, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87), textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis)), const SizedBox(height: 8), Text('${urun.fiyat} ₺', style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold, fontSize: 16))])),
          );
        })),
      ],
    );
  }

  Widget _favorilerIcerigi() {
    if (favoriUrunler.isEmpty) return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.favorite_border, size: 80, color: Colors.grey[300]), const SizedBox(height: 20), const Text("Favorileriniz şu an boş.", style: TextStyle(fontSize: 18, color: Colors.grey))]));
    return ListView.builder(padding: const EdgeInsets.all(16), itemCount: favoriUrunler.length, itemBuilder: (context, index) {
      final urun = favoriUrunler[index];
      return Card(elevation: 2, margin: const EdgeInsets.only(bottom: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), child: ListTile(contentPadding: const EdgeInsets.all(10), leading: Image.asset(urun.resimUrl, width: 60), title: Text(urun.ad, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text('${urun.fiyat} ₺', style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold)), trailing: IconButton(icon: const Icon(Icons.favorite, color: Colors.red), onPressed: () => setState(() => favoriUrunler.removeAt(index))),
        
        onTap: () => Navigator.pushNamed(context, '/detay', arguments: {'urun': urun, 'yenile': sayfayiYenile}),
      ));
    });
  }

  Widget _sepetIcerigi() {
    if (globalSepet.isEmpty) return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey[300]), const SizedBox(height: 20), const Text("Sepetiniz şu an boş.", style: TextStyle(fontSize: 18, color: Colors.grey))]));
    double toplamTutar = globalSepet.fold(0, (toplam, urun) => toplam + urun.fiyat);
    return Column(children: [
      Expanded(child: ListView.builder(padding: const EdgeInsets.all(16), itemCount: globalSepet.length, itemBuilder: (context, index) => Card(elevation: 2, margin: const EdgeInsets.only(bottom: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), child: ListTile(contentPadding: const EdgeInsets.all(10), leading: Image.asset(globalSepet[index].resimUrl, width: 60), title: Text(globalSepet[index].ad, style: const TextStyle(fontWeight: FontWeight.bold)), trailing: IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), onPressed: () => setState(() => globalSepet.removeAt(index))))))),
      Container(padding: const EdgeInsets.all(24), decoration: const BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, -5))], borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("Toplam:", style: TextStyle(fontSize: 14, color: Colors.grey)), Text("$toplamTutar ₺", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87))]), ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.black87, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
        
        onPressed: () { if (globalSepet.isNotEmpty) Navigator.pushNamed(context, '/odeme', arguments: sayfayiYenile); },
        icon: const Icon(Icons.credit_card), label: const Text("Satın Al", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)))])),
    ]);
  }

  Widget _profilIcerigi() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const CircleAvatar(radius: 60, backgroundColor: Colors.black87, child: Icon(Icons.person, size: 60, color: Colors.white)), const SizedBox(height: 15),
          Text(mevcutKullaniciAdi, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87)), Text("$mevcutCinsiyet | $mevcutMedeniDurum", style: const TextStyle(color: Colors.grey)), const SizedBox(height: 10),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 40), child: Text(adresDefteri[seciliSiparisAdresi] ?? "Adres seçilmedi", textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.blueGrey))), const SizedBox(height: 30),
          _profilKart(Icons.edit_note_rounded, "Profilimi Düzenle", Colors.teal, () => Navigator.pushNamed(context, '/profil_duzenle', arguments: sayfayiYenile)),
          _profilKart(Icons.shopping_bag_outlined, "Siparişlerim", Colors.deepOrange, () => Navigator.pushNamed(context, '/siparisler')),
          _profilKart(Icons.location_on_outlined, "Adres Defterim (${adresDefteri.length})", Colors.blue, () => showModalBottomSheet(context: context, shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))), builder: (context) => Container(padding: const EdgeInsets.all(20), child: Column(mainAxisSize: MainAxisSize.min, children: [const Text("Kayıtlı Adresleriniz", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), const Divider(), ...adresDefteri.entries.map((e) => ListTile(leading: const Icon(Icons.home_work_outlined, color: Colors.blue), title: Text(e.key, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(e.value))).toList(), const SizedBox(height: 20)])))),
          _profilKart(Icons.exit_to_app, "Çıkış Yap", Colors.red, () { globalSepet.clear(); favoriUrunler.clear(); Navigator.pushReplacementNamed(context, '/'); }),
        ],
      ),
    );
  }

  Widget _profilKart(IconData ikon, String baslik, MaterialColor renk, VoidCallback tiklama) {
    return Card(elevation: 2, margin: const EdgeInsets.only(bottom: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)), child: ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), leading: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: renk[50], borderRadius: BorderRadius.circular(12)), child: Icon(ikon, color: renk)), title: Text(baslik, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey), onTap: tiklama));
  }
}