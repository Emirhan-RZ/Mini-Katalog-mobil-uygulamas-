import 'package:flutter/material.dart';
import 'screens/giris_sayfasi.dart';
import 'screens/kayit_sayfasi.dart';
import 'screens/ana_sayfa.dart';
import 'screens/detay_sayfasi.dart';
import 'screens/odeme_sayfasi.dart';
import 'screens/profil_duzenle_sayfasi.dart';
import 'screens/siparisler_sayfasi.dart';
import 'models/urun.dart';

void main() => runApp(const HamsiExpress());

class HamsiExpress extends StatelessWidget {
  const HamsiExpress({super.key});

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HamsiExpress',
      initialRoute: '/', 
      
    
      routes: {
        '/': (context) => const GirisSayfasi(),
        '/kayit': (context) => const KayitSayfasi(),
        '/ana_sayfa': (context) => const AnaSayfa(),
        '/siparisler': (context) => const SiparislerSayfasi(),
      },
      
      
      onGenerateRoute: (settings) {
        if (settings.name == '/detay') {
        
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => DetaySayfasi(secilenUrun: args['urun'] as Urun, sayfayiYenile: args['yenile'] as VoidCallback),
          );
        }
        if (settings.name == '/odeme') {
          final args = settings.arguments as VoidCallback;
          return MaterialPageRoute(builder: (context) => OdemeSayfasi(sayfayiYenile: args));
        }
        if (settings.name == '/profil_duzenle') {
          final args = settings.arguments as VoidCallback;
          return MaterialPageRoute(builder: (context) => ProfilDuzenleSayfasi(sayfayiYenile: args));
        }
        return null; 
      },
    );
  }
}