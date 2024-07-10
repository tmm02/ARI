import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:provider/provider.dart';
import 'package:my_app/provider.dart';

class FuelConsumptionPage extends StatefulWidget {
  const FuelConsumptionPage({Key? key}) : super(key: key);

  @override
  _FuelConsumptionPageState createState() => _FuelConsumptionPageState();
}

class _FuelConsumptionPageState extends State<FuelConsumptionPage> {
  double fuel = 0;
  List<DataPoint> FuelConsumptionHistory = [DataPoint(0, 0)];

  double extractTimeInSeconds(String terminalTime) {
    final dateTime = DateTime.parse(terminalTime.replaceFirst(' ', 'T'));
    return dateTime.hour * 3600 + dateTime.minute * 60 + dateTime.second.toDouble();
  }

  void _refreshData() {
    final logDataProvider = Provider.of<LogDataProvider>(context, listen: false);
    logDataProvider.getlogdata().then((_) {
      setState(() {
        FuelConsumptionHistory = logDataProvider.logData
            .map((entry) => DataPoint(
                extractTimeInSeconds(entry['_terminalTime']),
                double.parse(entry['fuel'])))
            .toList();
        FuelConsumptionHistory.sort((a, b) => a.x.compareTo(b.x));

        if (FuelConsumptionHistory.isNotEmpty) {
          fuel = FuelConsumptionHistory.last.y;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  @override
  Widget build(BuildContext context) {
    Color _getFuelConsumptionColor(double value) {
      if (value <= 60) {
        return Colors.blue;
      } else if (value <= 120) {
        return Colors.yellow;
      } else {
        return Colors.red;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Fuel Consumption'),
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
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SfRadialGauge(
                      axes: <RadialAxis>[
                        RadialAxis(
                          minimum: 0,
                          maximum: 21,
                          showLabels: true,
                          showTicks: true,
                          useRangeColorForAxis: true,
                          ranges: <GaugeRange>[
                            GaugeRange(
                              startValue: 0,
                              endValue: fuel,
                              color: _getFuelConsumptionColor(fuel),
                              startWidth: 10,
                              endWidth: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '$fuel',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          'ml/minutes',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Fuel Consumption",
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.left,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SfCartesianChart(
                  primaryXAxis: NumericAxis(
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    title: AxisTitle(text: 'Time (second)'),
                  ),
                  primaryYAxis: NumericAxis(
                    maximum: 21,
                    title: AxisTitle(text: 'Fuel Consumption (ml/min)'),
                  ),
                  series: <CartesianSeries>[
                    SplineSeries<DataPoint, double>(
                      dataSource: FuelConsumptionHistory,
                      xValueMapper: (DataPoint data, _) => data.x,
                      yValueMapper: (DataPoint data, _) => data.y,
                      markerSettings: MarkerSettings(isVisible: true),
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshData,
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
