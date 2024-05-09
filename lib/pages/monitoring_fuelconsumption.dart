import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class FuelConsumptionPage extends StatefulWidget {
  const FuelConsumptionPage({Key? key}) : super(key: key);

  @override
  _FuelConsumptionPageState createState() => _FuelConsumptionPageState();
}

class _FuelConsumptionPageState extends State<FuelConsumptionPage> {
  double fuel = 0;
  List<DataPoint> FuelConsumptionHistory = [DataPoint(0, 0)];

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
        title: Text('FuelConsumption'),
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
                          maximum: 150,
                          showLabels: true, // Menampilkan label
                          showTicks: true, // Menampilkan tick
                          useRangeColorForAxis:
                              true, // Menggunakan warna dari rentang untuk sumbu
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
                          'l/hour',
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
              "SFOC Data",
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.left,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SfCartesianChart(
                  primaryXAxis: NumericAxis(
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    title: AxisTitle(text: 'Waktu (hari)'),
                  ),
                  primaryYAxis: NumericAxis(
                    maximum: 170,
                    title: AxisTitle(text: 'Fuel Consumption (l/hour)'),
                  ),
                  series: <CartesianSeries>[
                    SplineSeries<DataPoint, double>(
                        dataSource: FuelConsumptionHistory,
                        xValueMapper: (DataPoint data, _) => data.x,
                        yValueMapper: (DataPoint data, _) => data.y,
                        markerSettings: MarkerSettings(isVisible: true),
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Misalnya, di sini Anda dapat mengubah nilai suhu secara dinamis
          setState(() {
            // Contoh: nilai suhu diperbarui secara acak antara 0 hingga 300 derajat fuel
            fuel = Random().nextInt(150).toDouble();
            FuelConsumptionHistory.add(DataPoint(
                FuelConsumptionHistory.length.toDouble(),
                fuel)); // Tambahkan nilai suhu ke dalam sejarah
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
