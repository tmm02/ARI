import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:mqtt_client/mqtt_server_client.dart' as mqtt;
import 'package:provider/provider.dart';
import 'package:my_app/provider.dart';

class RPMPage extends StatefulWidget {
  const RPMPage({Key? key}) : super(key: key);

  @override
  _RPMPageState createState() => _RPMPageState();
}

class _RPMPageState extends State<RPMPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  double rpm = 0;
  List<double> rpmHistory = [];

  late mqtt.MqttServerClient client;
  late mqtt.MqttConnectionState connectionState;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: 0, end: rpm).animate(_controller)
      ..addListener(() {
        setState(() {
          rpm = _animation.value;
        });
      });

    // Ambil data awal RPM dari logdata
    _fetchInitialRPMData();

    // Initialize MQTT connection
    _initializeMQTT();
  }

  Future<void> _initializeMQTT() async {
    client = mqtt.MqttServerClient('broker.hivemq.com', 'flutter_client');
    client.logging(on: true);
    client.keepAlivePeriod = 100;
    client.onConnected = _onConnected;
    client.onDisconnected = _onDisconnected;
    client.onSubscribed = _onSubscribed;

    final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
        .withClientIdentifier('flutter_client')
        .withWillTopic('willtopic')
        .withWillMessage('Will message')
        .startClean()
        .withWillQos(mqtt.MqttQos.atLeastOnce);
    print('MQTT client connecting....');
    client.connectionMessage = connMess;

    try {
      await client.connect();
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == mqtt.MqttConnectionState.connected) {
      print('MQTT client connected');
      setState(() {
        connectionState = mqtt.MqttConnectionState.connected;
      });
    } else {
      print(
          'ERROR: MQTT client connection failed - disconnecting, state is ${client.connectionStatus!.state}');
      client.disconnect();
      setState(() {
        connectionState = mqtt.MqttConnectionState.disconnected;
      });
    }
  }

  void _onConnected() {
    print('Connected');
  }

  void _onDisconnected() {
    print('Disconnected');
  }

  void _onSubscribed(String topic) {
    print('Subscribed topic: $topic');
  }

  void _publishMessage(String key, int value) {
    final builder = mqtt.MqttClientPayloadBuilder();
    builder.addString('{"$key": "$value"}');
    client.publishMessage(
        'data/subscriberData/dataRPM/1', mqtt.MqttQos.atLeastOnce, builder.payload!);
  }

  void _handleButtonPress(String key) {
    _publishMessage(key, 1);
  }

  void _handleButtonRelease(String key) {
    _publishMessage(key, 0);
  }

  void _fetchInitialRPMData() {
    Provider.of<LogDataProvider>(context, listen: false).getlogdata().then((_) {
      setState(() {
        rpmHistory = Provider.of<LogDataProvider>(context, listen: false)
            .logData
            .map<double>((entry) => double.parse(entry['rpm']))
            .toList();
        if (rpmHistory.isNotEmpty) {
          rpm = rpmHistory.last;
          rpmHistory.add(rpm); // Add initial RPM to history
        }
      });
    });
  }

  void _updateRPM() async {
    setState(() {
      
    });
  if (_controller.isAnimating) _controller.stop(); // Stop animation if it's running

  // Fetch updated RPM data from log provider
  await Provider.of<LogDataProvider>(context, listen: false).getlogdata();

  // Access the updated data from the provider instance
  final logDataProvider = Provider.of<LogDataProvider>(context, listen: true);

  // Check if data is empty or there's no "data" key (assuming provider updated logData)
  if (logDataProvider.logData.isEmpty) {
    print('Error: Data is empty');
    return; // Handle empty data case (optional)
  }

  // Extract the latest RPM from the data
  final List<Map<String, dynamic>> logEntries = logDataProvider.logData;
  final double newRPM = _extractLatestRPM(logEntries);

  // Update the history and remove old data if needed
  setState(() {
    rpmHistory.add(newRPM);
  if (rpmHistory.length > 10) rpmHistory.removeAt(0);

  // Animate the RPM value
  _animation = Tween<double>(begin: rpm, end: newRPM).animate(_controller)
    ..addListener(() {
      setState(() {
        rpm = _animation.value;
      });
    });

  _controller.forward(); // Start animation
  });
  
}

double _extractLatestRPM(List<Map<String, dynamic>> logEntries) {
  // Assuming the RPM value is still stored in a key named 'rpm'
  // Modify this based on your actual data structure
  if (logEntries.isEmpty) return rpm; // Handle empty data case

  // Check if any entry has a non-empty 'rpm' value
  for (final entry in logEntries) {
    if (entry.containsKey('rpm') && entry['rpm'].isNotEmpty) {
      return double.parse(entry['rpm']);
    }
  }

  // If no entry has a valid 'rpm', return the current rpm
  return rpm;
}





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RPM Control'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: 300,
                  height: 300,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0, end: rpm),
                        duration: Duration(milliseconds: 500), // Animation duration
                        builder: (BuildContext context, double value, Widget? child) {
                          return SfRadialGauge(
                            axes: <RadialAxis>[
                              RadialAxis(
                                minimum: 0,
                                maximum: 2200,
                                showLabels: true,
                                showTicks: true,
                                useRangeColorForAxis: true,
                                ranges: <GaugeRange>[
                                  GaugeRange(
                                    startValue: 0,
                                    endValue: value, // Use current animation value
                                    color: _getRPMColor(value),
                                    startWidth: 10,
                                    endWidth: 10,
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${rpm.toInt()}',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          Text(
                            'RPM',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  "Throttle",
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    child: GestureDetector(
                      onTapDown: (_) => _handleButtonPress('rpm_left'),
                      onTapUp: (_) => _handleButtonRelease('rpm_left'),
                      child: Icon(
                        size: 50,
                        Icons.remove,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  
                  SizedBox(width: 50),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    child: GestureDetector(
                      onTapDown: (_) => _handleButtonPress('rpm_right'),
                      onTapUp: (_) => _handleButtonRelease('rpm_right'),
                      child: Icon(
                        size: 50,
                        Icons.add,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  "Historical RPM",
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  height: 200,
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(), // Assuming you want a category axis for RPM data
                    series: <CartesianSeries>[
                      LineSeries<double, double>(
                        dataSource: rpmHistory, // Use the original rpmHistory data directly
                        xValueMapper: (double rpm, _) => rpm, // Assuming RPM values are doubles
                        yValueMapper: (double rpm, _) => rpm, // Assuming you want to plot RPM on the Y-axis
                        markerSettings: MarkerSettings(isVisible: true),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateRPM,
        child: Icon(Icons.refresh),
      ),
    );
  }

  Color _getRPMColor(double value) {
    if (value <= 800) {
      return Colors.blue;
    } else if (value <= 1800) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    client.disconnect();
    super.dispose();
  }
}
