import 'package:agriot/blockchain_service.dart';
import 'package:agriot/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
          backgroundColor: Colors.white,
        ),
        textTheme: const TextTheme(titleMedium: TextStyle(fontSize: 24)),
      ),
      home: const Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final database = FirebaseDatabase.instance.ref();
  final blockchain = BlockchainService();

  final List<SoilData> _humidityData = [];
  final List<SoilData> _soilMoistureData = [];
  final List<SoilData> _temperatureData = [];

  @override
  void initState() {
    super.initState();
    _readData();
  }

  void _readData() {
    database.child('sensor').onValue.listen((event) async {
      try {
        if (event.snapshot.value == null) {
          print('No data found under "sensor".');
          return;
        }

        final data = event.snapshot.value as Map<dynamic, dynamic>?;
        if (data == null) return;

        final timestamp = DateTime.now();
        final double humidity = (data['humidity'] ?? 0.0).toDouble();
        final double soilMoisture = (data['soil_moisture'] ?? 0.0).toDouble();
        final double temperature = (data['temperature'] ?? 0.0).toDouble();

        setState(() {
          _humidityData.add(SoilData(timestamp: timestamp, value: humidity));
          _soilMoistureData.add(
            SoilData(timestamp: timestamp, value: soilMoisture),
          );
          _temperatureData.add(
            SoilData(timestamp: timestamp, value: temperature),
          );

          if (_humidityData.length > 100) _humidityData.removeAt(0);
          if (_soilMoistureData.length > 100) _soilMoistureData.removeAt(0);
          if (_temperatureData.length > 100) _temperatureData.removeAt(0);
        });

        await _storeDataOnBlockchain(temperature, humidity, soilMoisture);
      } catch (e) {
        print("Error reading data: $e");
      }
    });
  }

  Future<void> _storeDataOnBlockchain(
    double temp,
    double humidity,
    double soilMoisture,
  ) async {
    try {
      await blockchain.storeSensorData(
        BigInt.from(temp.toInt()),
        BigInt.from(humidity.toInt()),
        BigInt.from(soilMoisture.toInt()),
      );
      print("Sensor data successfully stored on blockchain");
    } catch (e) {
      print("Error storing data on blockchain: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PreviousData()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildChart('Humidity', _humidityData),
                _buildChart('Soil Moisture', _soilMoistureData),
                _buildChart('Temperature', _temperatureData),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChart(String title, List<SoilData> data) {
    final latestValue =
        data.isNotEmpty ? data.last.value.toStringAsFixed(2) : 'N/A';
    return Column(
      children: [
        Text(
          '$title: $latestValue',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(
          height: 200,
          child:
              data.isEmpty
                  ? const Center(child: Text('No data available'))
                  : SfCartesianChart(
                    plotAreaBorderWidth: 2,
                    plotAreaBorderColor: Colors.grey,
                    series: <LineSeries<SoilData, DateTime>>[
                      LineSeries<SoilData, DateTime>(
                        dataSource: data,
                        xValueMapper:
                            (SoilData soilData, _) => soilData.timestamp,
                        yValueMapper: (SoilData soilData, _) => soilData.value,
                      ),
                    ],
                    primaryXAxis: DateTimeAxis(isVisible: true),
                    primaryYAxis: NumericAxis(isVisible: true),
                  ),
        ),
      ],
    );
  }
}

class SoilData {
  final DateTime timestamp;
  final double value;
  SoilData({required this.timestamp, required this.value});
}

class PreviousData extends StatelessWidget {
  const PreviousData({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Previous Data')),
      body: const Center(child: Text('Previous Data')),
    );
  }
}
