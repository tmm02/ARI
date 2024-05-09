import 'package:flutter/material.dart';

class MonitoringEnginePage extends StatefulWidget {
  final bool isOn;
  const MonitoringEnginePage({Key? key, required this.isOn}) : super(key: key);

  @override
  _MonitoringEnginePageState createState() => _MonitoringEnginePageState();
}

class _MonitoringEnginePageState extends State<MonitoringEnginePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monitoring Engine'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Engine Status',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [Colors.purple, Colors.transparent],
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      widget.isOn ? 'On' : 'Off',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Center(
              child: Column(
                children: [
                  Ink(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.purple,
                          width: 10), // Menambahkan border ungu
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(75),
                      onTap: () {
                        // Aksi ketika tombol start ditekan
                      },
                      child: Center(
                        child: Text(
                          'Start',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Aksi ketika tombol stop ditekan
                    },
                    child: Text(
                      'Stop',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
