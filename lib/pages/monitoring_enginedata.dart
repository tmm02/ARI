import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:my_app/provider.dart';

class EngineDataPage extends StatefulWidget {
  const EngineDataPage({Key? key}) : super(key: key);

  @override
  _EngineDataPageState createState() => _EngineDataPageState();
}

class _EngineDataPageState extends State<EngineDataPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LogDataProvider>(context, listen: false).getlogdata();
    });
  }

  double extractTimeInSeconds(String terminalTime) {
    final dateTime = DateTime.parse(terminalTime.replaceFirst(' ', 'T'));
    return dateTime.hour * 3600 + dateTime.minute * 60 + dateTime.second.toDouble();
  }

  double calculateAverage(List<DataPoint> data) {
    if (data.isEmpty) return 0.0;
    double sum = data.fold(0.0, (previousValue, element) => previousValue + element.y);
    return sum / data.length;
  }

  void _refreshData() {
    setState(() {
      Provider.of<LogDataProvider>(context, listen: false).getlogdata();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Engine Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Consumer<LogDataProvider>(
          builder: (context, logDataProvider, child) {
            if (logDataProvider.logData.isEmpty) {
              return Center(child: CircularProgressIndicator());
            } else {
              List<DataPoint> temperatureData = logDataProvider.logData
                  .map((entry) => DataPoint(
                      extractTimeInSeconds(entry['_terminalTime']),
                      double.parse(entry['temperature'])))
                  .toList();
              List<DataPoint> fuelData = logDataProvider.logData
                  .map((entry) => DataPoint(
                      extractTimeInSeconds(entry['_terminalTime']),
                      double.parse(entry['fuel'])))
                  .toList();
              List<DataPoint> rpmData = logDataProvider.logData
                  .map((entry) => DataPoint(
                      extractTimeInSeconds(entry['_terminalTime']),
                      double.parse(entry['rpm'])))
                  .toList();
              List<DataPoint> powerData = logDataProvider.logData
                  .map((entry) => DataPoint(
                      extractTimeInSeconds(entry['_terminalTime']),
                      double.parse(entry['power'])))
                  .toList();

              // Sort data points by time
              temperatureData.sort((a, b) => a.x.compareTo(b.x));
              fuelData.sort((a, b) => a.x.compareTo(b.x));
              rpmData.sort((a, b) => a.x.compareTo(b.x));
              powerData.sort((a, b) => a.x.compareTo(b.x));

              double avgTemperature = calculateAverage(temperatureData);
              double avgFuel = calculateAverage(fuelData);
              double avgRPM = calculateAverage(rpmData);
              double avgPower = calculateAverage(powerData);

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "Engine Data",
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.left,
                    ),
                    ElevatedButton(
                      onPressed: _refreshData,
                      child: Text('Refresh Data'),
                    ),
                    Text(
                      "Engine Graphic Report",
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.left,
                    ),
                    SfCartesianChart(
                      primaryXAxis: NumericAxis(
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        title: AxisTitle(text: 'Time (seconds)'),
                      ),
                      primaryYAxis: NumericAxis(
                        title: AxisTitle(text: 'Value'),
                      ),
                      series: <CartesianSeries>[
                        SplineSeries<DataPoint, double>(
                          name: 'Temperature Exhaust',
                          dataSource: temperatureData,
                          xValueMapper: (DataPoint data, _) => data.x,
                          yValueMapper: (DataPoint data, _) => data.y,
                          markerSettings: MarkerSettings(isVisible: true),
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          color: Colors.red,
                        ),
                        SplineSeries<DataPoint, double>(
                          name: 'Fuel Consumption',
                          dataSource: fuelData,
                          xValueMapper: (DataPoint data, _) => data.x,
                          yValueMapper: (DataPoint data, _) => data.y,
                          markerSettings: MarkerSettings(isVisible: true),
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          color: Colors.green,
                        ),
                        SplineSeries<DataPoint, double>(
                          name: 'Rotation Per Minutes',
                          dataSource: rpmData,
                          xValueMapper: (DataPoint data, _) => data.x,
                          yValueMapper: (DataPoint data, _) => data.y,
                          markerSettings: MarkerSettings(isVisible: true),
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          color: Colors.blue,
                        ),
                        SplineSeries<DataPoint, double>(
                          name: 'Load',
                          dataSource: powerData,
                          xValueMapper: (DataPoint data, _) => data.x,
                          yValueMapper: (DataPoint data, _) => data.y,
                          markerSettings: MarkerSettings(isVisible: true),
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                          color: Colors.orange,
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Add the color legend
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildColorLegend(Colors.red, 'Temperature'),
                        SizedBox(width: 10),
                        _buildColorLegend(Colors.green, 'Fuel'),
                        SizedBox(width: 10),
                        _buildColorLegend(Colors.blue, 'RPM'),
                        SizedBox(width: 10),
                        _buildColorLegend(Colors.orange, 'Power'),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Engine Report",
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.left,
                    ),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(10),
                      children: [
                        _buildEngineReportCircle('Temperature', avgTemperature.toStringAsFixed(2)),
                        _buildEngineReportCircle('Fuel', avgFuel.toStringAsFixed(2)),
                        _buildEngineReportCircle('RPM', avgRPM.toStringAsFixed(2)),
                        _buildEngineReportCircle('Power', avgPower.toStringAsFixed(2)),
                      ],
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildColorLegend(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          color: color,
        ),
        SizedBox(width: 5),
        Text(text),
      ],
    );
  }

  Widget _buildEngineReportCircle(String label, String value) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.purple, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            label,
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class DataPoint {
  final double x;
  final double y;

  DataPoint(this.x, this.y);
}
