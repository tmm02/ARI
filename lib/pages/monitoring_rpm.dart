import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class RPMPage extends StatefulWidget {
  const RPMPage({Key? key}) : super(key: key);

  @override
  _RPMPageState createState() => _RPMPageState();
}

class _RPMPageState extends State<RPMPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  double rpm = 0;
  int throttle = 1;
  List<double> rpmHistory = [];

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

    // Initialize with some RPM history data
    rpmHistory = [0, 100, 200, 300, 400, 500, 600, 700, 800, 900, 1000];
  }

  void _increaseThrottle() {
    if (throttle < 5) {
      setState(() {
        throttle += 1;
        _updateRPM();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Throttle sudah mencapai maksimum'),
        ),
      );
    }
  }

  void _decreaseThrottle() {
    if (throttle > 1) {
      setState(() {
        throttle -= 1;
        _updateRPM();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Throttle sudah mencapai minimum'),
        ),
      );
    }
  }

  void _updateRPM() {
    if (_controller.isAnimating) _controller.stop(); // Hentikan animasi jika sedang berjalan
    double newRPM = throttle * 440.0; // RPM naik 440 untuk setiap throttle level

    // Simulasikan pengambilan data dari logdata RPM
    // Ini hanya contoh, Anda harus mengganti dengan data aktual dari logdata Anda
    rpmHistory.add(newRPM);
    if (rpmHistory.length > 10) rpmHistory.removeAt(0); // Hanya simpan 10 data terakhir

    _animation = Tween<double>(begin: rpm, end: newRPM).animate(_controller)
      ..addListener(() {
        setState(() {
          rpm = _animation.value;
        });
      });
    _controller.forward(); // Mulai animasi
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
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
                            duration: Duration(milliseconds: 500), // Durasi animasi
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
                                        endValue: value, // Gunakan nilai animasi saat ini
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
                        child: IconButton(
                          onPressed: _decreaseThrottle,
                          icon: Icon(Icons.remove),
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.withOpacity(0.2),
                        ),
                        padding: EdgeInsets.all(20), // Adjust padding to make the circle larger
                        child: Text(
                          '$throttle',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.withOpacity(0.2),
                        ),
                        child: IconButton(
                          onPressed: _increaseThrottle,
                          icon: Icon(Icons.add),
                          color: Colors.grey,
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
                        primaryXAxis: CategoryAxis(),
                        series: <CartesianSeries>[
                          LineSeries<double, int>(
                            dataSource: rpmHistory,
                            xValueMapper: (double rpm, int index) => index,
                            yValueMapper: (double rpm, int index) => rpm,
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
        );
      },
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
    super.dispose();
  }
}
