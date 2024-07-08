import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function()? onTap;

  const CardItem({
    Key? key,
    required this.title,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) { // Warna latar belakang dengan kelebihan opasitas
    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(8), // Radius sudut untuk efek gelombang
      child: Padding(
        padding: const EdgeInsets.all(
            8.0), // Padding untuk memperbesar area ketika diklik
        child: Container(
          color:Color(0xFF070417) ,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon, // Replace this with the desired icon
                size: 90, // Adjust the size as needed
                color: Colors.white, // Set the icon color to match the status
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.rubik().fontFamily,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4), // Spasi antara teks dan persegi
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
