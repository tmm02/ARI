import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardItem extends StatelessWidget {
  final String title;
  final String status;
  final String imagePath;
  final Function()? onTap;

  const CardItem({
    Key? key,
    required this.title,
    required this.status,
    required this.imagePath,
    this.onTap,
  }) : super(key: key);

  Color getStatusColor(String status) {
    switch (status) {
      case 'Normal':
        return Colors.deepPurple; // Warna ungu untuk status Normal
      case 'Low':
        return Colors.amber; // Warna kuning untuk status Low
      case 'High':
        return Colors.red; // Warna merah untuk status High
      default:
        return Colors.black; // Warna default
    }
  }

  @override
  Widget build(BuildContext context) {
    Color color = getStatusColor(status);
    Color statusBackgroundColor = color
        .withOpacity(0.3); // Warna latar belakang dengan kelebihan opasitas

    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(8), // Radius sudut untuk efek gelombang
      child: Padding(
        padding: const EdgeInsets.all(
            8.0), // Padding untuk memperbesar area ketika diklik
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: imagePath.isNotEmpty ? null : Color(0xFF1B143F),
                image: imagePath.isNotEmpty
                    ? DecorationImage(
                        image: AssetImage(imagePath), fit: BoxFit.cover)
                    : null,
              ),
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
                  ),
                ),
                SizedBox(height: 4), // Spasi antara teks dan persegi
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4), // Padding untuk teks status
                  decoration: BoxDecoration(
                    color: statusBackgroundColor, // Warna latar belakang
                    borderRadius: BorderRadius.circular(8), // Radius sudut
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: color, // Warna teks berdasarkan status
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
