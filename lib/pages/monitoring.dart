import 'package:flutter/material.dart';
import 'package:my_app/pages/monitoring_engine.dart';
import 'package:my_app/pages/monitoring_fuelconsumption.dart';
import 'package:my_app/pages/monitoring_rpm.dart';
import 'package:my_app/pages/monitoring_temprature.dart';
import 'package:my_app/widget/carditem.dart';
import 'package:my_app/widget/engingstatuscard.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MONITORING'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Center(
              child: EngineStatusCard(
                isOn: true, // Ganti dengan nilai dari API
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MonitoringEnginePage(
                        isOn: true,
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Today",
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 10),
                CardItem(
                  title: 'Temperature',
                  status: 'Normal',
                  imagePath: '',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TemperaturePage(),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                CardItem(
                  title: 'Fuel Consumption',
                  status: 'Low',
                  imagePath: '',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FuelConsumptionPage(),
                        ));
                  },
                ),
                SizedBox(height: 20),
                CardItem(
                  title: 'Rotation Per Minutes',
                  status: 'High',
                  imagePath: '',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RPMPage(),
                        ));
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
