import 'package:flutter/material.dart';
import 'package:my_app/pages/monitoring_enginedata.dart';
import 'package:provider/provider.dart';
import 'package:my_app/pages/monitoring_engine.dart';
import 'package:my_app/pages/monitoring_fuelconsumption.dart';
import 'package:my_app/pages/monitoring_rpm.dart';
import 'package:my_app/pages/monitoring_temprature.dart';
import 'package:my_app/widget/carditem.dart';
import 'package:my_app/widget/engingstatuscard.dart';
import 'package:my_app/provider.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<LogDataProvider>(context, listen: false).getlogdata();
  }

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
                isOn: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MonitoringEnginePage(
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              "Today",
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  CardItem(
                    title: 'Engine Data',
                    icon: Icons.settings,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EngineDataPage(
                          ),
                        ),
                      );
                    },
                  ),
                  CardItem(
                    title: 'Exhaust Temperature',
                    icon: Icons.thermostat_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TemperaturePage(),
                        ),
                      );
                    },
                  ),
                  CardItem(
                    title: 'Fuel Consumption',
                    icon: Icons.local_gas_station,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FuelConsumptionPage(),
                        ),
                      );
                    },
                  ),
                  CardItem(
                    title: 'RPM & Throttle',
                    icon: Icons.speed,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RPMPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
