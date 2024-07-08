import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:my_app/provider.dart';

class MonitoringEnginePage extends StatefulWidget {
  const MonitoringEnginePage({Key? key}) : super(key: key);

  @override
  _MonitoringEnginePageState createState() => _MonitoringEnginePageState();
}

class _MonitoringEnginePageState extends State<MonitoringEnginePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LogDataProvider>(context, listen: false).getlogdata();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Monitoring Engine'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Consumer<LogDataProvider>(
            builder: (context, logDataProvider, child) {
              if (logDataProvider.logData.isEmpty) {
                return Center(child: CircularProgressIndicator());
              } else {
                List<DataPoint> powerData = logDataProvider.logData
                    .map((entry) => DataPoint(
                          double.parse(entry['power']),
                          logDataProvider.logData.indexOf(entry).toDouble(),
                        ))
                    .toList();

                double latestPower = powerData.isNotEmpty
                    ? powerData.last.x
                    : 0; // Ambil nilai power terakhir

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ENGINE STATUS',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Radio(
                          value: true,
                          groupValue: true,
                          onChanged: (_) {},
                          activeColor: Colors.purple,
                        ),
                        Text(
                          'On',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.purple, width: 10),
                        ),
                        child: Center(
                          child: Text(
                            'STOP',
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
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Engine Load',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              '${latestPower.toStringAsFixed(0)} Watt',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Historical Load',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      height: 200,
                      child: SfCartesianChart(
                        primaryXAxis: NumericAxis(
                          edgeLabelPlacement: EdgeLabelPlacement.shift,
                          title: AxisTitle(text: 'Time'),
                        ),
                        primaryYAxis: NumericAxis(
                          title: AxisTitle(text: 'Power (Watt)'),
                        ),
                        series: <CartesianSeries>[
                          SplineSeries<DataPoint, double>(
                            dataSource: powerData,
                            xValueMapper: (DataPoint data, _) => data.y,
                            yValueMapper: (DataPoint data, _) => data.x,
                            markerSettings: MarkerSettings(isVisible: true),
                            dataLabelSettings: DataLabelSettings(
                              isVisible: true,
                            ),
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class DataPoint {
  final double x;
  final double y;

  DataPoint(this.x, this.y);
}
