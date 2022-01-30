import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kopbi/main.dart';
import 'package:kopbi/src/services/simpananApi.dart';
import 'package:kopbi/src/views/bottom_bar.dart';
import 'package:kopbi/src/views/isiulang_screen/isiulang.dart';
import 'package:kopbi/src/views/kendaraan_screen/kendaraan.dart';
import 'package:kopbi/src/views/konsumer_screen/konsumer.dart';
import 'package:kopbi/src/views/kredit_screen/kredit.dart';
import 'package:kopbi/src/views/login_screen/daftar.dart';
import 'package:kopbi/src/views/login_screen/login_page.dart';
import 'package:kopbi/src/views/login_screen/re_login.dart';
import 'package:kopbi/src/views/main_screen/main_page.dart';
import 'package:kopbi/src/views/more_screen/more.dart';
import 'package:kopbi/src/views/perumahan_screen/perumahan.dart';
import 'package:kopbi/src/views/pinjaman_screen/list_pinjaman.dart';
import 'package:kopbi/src/views/pinjaman_screen/pinjaman.dart';
import 'package:kopbi/src/views/register_screen/aktivasi_page.dart';
import 'package:kopbi/src/views/register_screen/bantuan.dart';
import 'package:kopbi/src/views/register_screen/new_register_page.dart';
import 'package:kopbi/src/views/register_screen/register_page.dart';
import 'package:kopbi/src/views/setting_screen/informasi.dart';
import 'package:kopbi/src/views/setting_screen/ketentuan_dan_kebijakan.dart';
import 'package:kopbi/src/views/setting_screen/pusat_bantuan.dart';
import 'package:kopbi/src/views/setting_screen/setting_page.dart';
import 'package:kopbi/src/views/simpanan_screen/list_simpanan.dart';
import 'package:kopbi/src/views/tiket_screen/tiket.dart';

void app() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto'),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/bottom-bar': (context) => BottomBar(),
        '/login': (context) => LoginScreen(),
        '/re-login': (context) => ReLoginScreen(),
//        '/register': (context) => RegisterScreen(),
        '/register': (context) => NewRegisterPage(),
        '/daftar': (context) => DaftarScreen(),
        '/bantuan': (context) => BantuanPage(),
        '/aktivasi': (context) => AktivasiScreen(),
        '/pinjaman': (context) => PinjamanScreen(),
        '/home': (context) => MainScreen(),
        '/konsumer': (context) => KonsumerScreen(),
        '/perumahan': (context) => PerumahanScreen(),
        '/isi-ulang': (context) => IsiUlangScreen(),
        '/tiket': (context) => KendaraanScreen(),
        '/kredit': (context) => KreditScreen(),
        '/lainnya': (context) => MoreScreen(),
        '/settings': (context) => SettingScreen(),
        '/settings-informasi': (context) => InformasiScreen(),
        '/ketentuan-kebijakan': (context) => KetentuanKebijakanScreen(),
        '/settings-pusat-bantuan': (context) => PusatBantuanScreen(),
        '/list-simpanan': (context) => SimpananListPage(),
        '/list-pinjaman': (context) => PengajuanListPage(),
      },
    ),
  );
}
