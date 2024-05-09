import 'package:flutter/material.dart';
import 'package:my_app/widget/navbar.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    navigateToNextPage();
  }

  Future<void> navigateToNextPage() async {
    // Menunda navigasi selama 3 detik.
    Future.delayed(Duration(seconds: 3), () {
      // Navigasi ke halaman berikutnya (misalnya, halaman utama).
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Navbar())); // Ganti '/home' dengan nama rute halaman berikutnya.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(22, 22, 34, 100),
      body: Center(
        child:
            // Tambahkan gambar di sini
            Image.asset(
          'assets/images/logo.png', // Ganti dengan path gambar Anda
          width: 200, // Sesuaikan lebar gambar sesuai kebutuhan
          height: 200, // Sesuaikan tinggi gambar sesuai kebutuhan
        ),
      ),
    );
  }
}
