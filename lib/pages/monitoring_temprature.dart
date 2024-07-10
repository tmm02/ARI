import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:my_app/provider.dart';

class TemperaturePage extends StatefulWidget {
  const TemperaturePage({Key? key}) : super(key: key);

  @override
  _TemperaturePageState createState() => _TemperaturePageState();
}

class _TemperaturePageState extends State<TemperaturePage> {
  double celsius = 0; // Nilai suhu dalam derajat Celsius, default 0
  List<DataPoint> temperatureHistory = [
    DataPoint(0, 0)
  ]; // Sejarah suhu, default dimulai dari 0

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LogDataProvider>(context, listen: false).getlogdata();
    });
  }

  double extractSeconds(String terminalTime) {
    final dateTime = DateTime.parse(terminalTime.replaceFirst(' ', 'T'));
    return dateTime.millisecondsSinceEpoch.toDouble() / Duration.millisecondsPerMinute; // Convert to minutes
  }

  @override
  Widget build(BuildContext context) {
    Color _getTemperatureColor(double value) {
      if (value <= 120) {
        return Colors.blue;
      } else if (value <= 220) {
        return Colors.yellow;
      } else {
        return Colors.red;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Temperature'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: Container(
                width: 200,
                height: 200,
                child: Consumer<LogDataProvider>(
                  builder: (context, logDataProvider, child) {
                    if (logDataProvider.logData.isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      double latestTemperature = double.parse(
                          logDataProvider.logData.last['temperature']);

                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          SfRadialGauge(
                            axes: <RadialAxis>[
                              RadialAxis(
                                minimum: 0,
                                maximum: 400,
                                showLabels: true, // Menampilkan label
                                showTicks: true, // Menampilkan tick
                                useRangeColorForAxis:
                                    true, // Menggunakan warna dari rentang untuk sumbu
                                ranges: <GaugeRange>[
                                  GaugeRange(
                                    startValue: 0,
                                    endValue: latestTemperature,
                                    color: _getTemperatureColor(latestTemperature),
                                    startWidth: 10,
                                    endWidth: 10,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            '$latestTemperature °C',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Temperature Data",
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.left,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Consumer<LogDataProvider>(
                  builder: (context, logDataProvider, child) {
                    if (logDataProvider.logData.isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      List<DataPoint> temperatureHistory = logDataProvider.logData
                          .map((entry) => DataPoint(
                              extractSeconds(entry['_terminalTime']),
                              double.parse(entry['temperature'])))
                          .toList();

                      return SfCartesianChart(
                        primaryXAxis: NumericAxis(
                          edgeLabelPlacement: EdgeLabelPlacement.shift,
                          title: AxisTitle(text: 'Time (seconds)'),
                        ),
                        primaryYAxis: NumericAxis(
                          title: AxisTitle(text: 'Temperature (°C)'),
                        ),
                        series: <CartesianSeries>[
                          SplineSeries<DataPoint, double>(
                            dataSource: temperatureHistory,
                            xValueMapper: (DataPoint data, _) => data.x,
                            yValueMapper: (DataPoint data, _) => data.y,
                            markerSettings: MarkerSettings(isVisible: true),
                            dataLabelSettings: DataLabelSettings(
                              isVisible: true,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            Provider.of<LogDataProvider>(context, listen: false).getlogdata();
          });
          
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}

class DataPoint {
  final double x;
  final double y;

  DataPoint(this.x, this.y);
}
