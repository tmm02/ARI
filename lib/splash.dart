import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:my_app/pages/login.dart';
import 'package:my_app/widget/navbar.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool isDialogShowing = false;

  @override
  void initState() {
    super.initState();
    navigateToNextPage();
  }

  Future<void> navigateToNextPage() async {
    // Menunda navigasi selama 3 detik.
    await Future.delayed(Duration(seconds: 3));

    // Loop to continuously check for internet connection.
    while (true) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        if (!isDialogShowing) {
          isDialogShowing = true;
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: Text('No Internet Connection'),
              content: Text('Please check your internet connection and try again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    isDialogShowing = false;
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          );
        }
        // Wait for a while before re-checking connectivity.
        await Future.delayed(Duration(seconds: 3));
      } else {
        if (isDialogShowing) {
          Navigator.of(context).pop();
        }
        // Ada koneksi internet, navigasi ke halaman berikutnya.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()), // Ganti dengan halaman tujuan
        );
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(22, 22, 34, 100),
      body: Center(
        child:
            // Tambahkan gambar di sini
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                          'assets/images/logo.png', // Ganti dengan path gambar Anda
                          width: 200, // Sesuaikan lebar gambar sesuai kebutuhan
                          height: 200, // Sesuaikan tinggi gambar sesuai kebutuhan
                        ),
                        Text(
                  'DIGITAL',
                  style: TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: GoogleFonts.rubik().fontFamily)
                  ),
                  Text(
                  'TWIN',
                  style: TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: GoogleFonts.rubik().fontFamily)
                  ),
              ],
            ),
      ),
    );
  }
}
