import 'package:flutter/material.dart';
import 'package:my_app/widget/appbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: MyAppBar(
          title: 'DIGITAL TWIN',
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //ENGINE
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Engine Overview",
                        style: Theme.of(context).textTheme.headlineSmall),
                    Center(
                      child:
                          // Tambahkan gambar di sini
                          Image.asset(
                        'assets/images/Mesin.png', // Ganti dengan path gambar Anda
                        // Sesuaikan lebar gambar sesuai kebutuhan
                        height: 303, // Sesuaikan tinggi gambar sesuai kebutuhan
                      ),
                    ),
                    Center(
                      child: Text("YANMAR TF-65",
                          style: Theme.of(context).textTheme.headlineSmall),
                    )
                  ],
                ),
              ),
              //TECHNICAL
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Technical Specification",
                        style: Theme.of(context).textTheme.headlineSmall),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildRow('Model:', '4-Step Diesel Motor',
                            isDisabled: true),
                        _buildRow('Burning:', 'Direct injection',
                            isDisabled: true),
                        _buildRow('Number of Cylinder:', '1 (One)',
                            isDisabled: true),
                        _buildRow('Type of Fuel:', 'Diesel Oil',
                            isDisabled: true),
                        _buildRow('Compression Ratio:', '18.1,',
                            isDisabled: true),
                        _buildRow('Power (Max):', '4.78 Kilowatt',
                            isDisabled: true),
                        _buildRow('RPM (Max):', '2200', isDisabled: true),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "System Overview",
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.left,
                    ),
                    Center(
                      child:
                          // Tambahkan gambar di sini
                          Image.asset(
                        'assets/images/diagram.png', // Ganti dengan path gambar Anda
                        // Sesuaikan lebar gambar sesuai kebutuhan
                        height: 441, // Sesuaikan tinggi gambar sesuai kebutuhan
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Using Programmable Logic Controller for Monitoring and Controlling the engine.In this case, Installed 3 sensors. The parameters that discussed are:',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          '- Exhaust Temperature',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '- Fuel Monitoring',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '- Rotation Per Minute (RPM)',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildRow(String label, String value, {bool isDisabled = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDisabled ? Colors.grey : Colors.black,
              fontWeight: isDisabled ? FontWeight.normal : FontWeight.bold,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
