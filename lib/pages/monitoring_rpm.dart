import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  }

  void _increaseRPM() {
    if (rpm < 2200) {
      setState(() {
        if (_controller.isAnimating)
          _controller.stop(); // Hentikan animasi jika sedang berjalan
        rpm += 100;

        _controller.forward(); // Mulai animasi
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('RPM sudah mencapai maksimum'),
        ),
      );
    }
  }

  void _decreaseRPM() {
    if (rpm > 0) {
      setState(() {
        if (_controller.isAnimating)
          _controller.stop(); // Hentikan animasi jika sedang berjalan
        rpm -= 100;
        // Reset animasi
        _controller.forward(); // Mulai animasi
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('RPM sudah mencapai minimum'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Widget AnimatedBuilder untuk membuat animasi saat nilai RPM berubah
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('RPM Control'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
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
                          duration:
                              Duration(milliseconds: 500), // Durasi animasi
                          builder: (BuildContext context, double value,
                              Widget? child) {
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
                                      endValue:
                                          value, // Gunakan nilai animasi saat ini
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
                    "Throttle Button",
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
                        onPressed: _decreaseRPM,
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
                      child: IconButton(
                        onPressed: _increaseRPM,
                        icon: Icon(Icons.add),
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
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
