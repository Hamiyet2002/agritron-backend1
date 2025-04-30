import 'package:flutter/material.dart';
import 'package:agritron/screens/ndvi_screen.dart';
import 'package:agritron/screens/ai_assistant_screen.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, String>> hourlyWeatherData = [
    {'temp': '14', 'hour': '00:00'},
    {'temp': '12', 'hour': '03:00'},
    {'temp': '11', 'hour': '06:00'},
    {'temp': '10', 'hour': '09:00'},
    {'temp': '9', 'hour': '12:00'},
    {'temp': '12', 'hour': '15:00'},
    {'temp': '13', 'hour': '18:00'},
    {'temp': '11', 'hour': '21:00'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF565E2B),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF565E2B),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF495020)),
              child: Center(
                child: Text(
                  'Menü',
                  style: TextStyle(
                    color: Color(0xFFF6F4E3),
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.smart_toy, color: Color(0xFFF6F4E3)),
              title: const Text('AI Asistanı', style: TextStyle(color: Color(0xFFF6F4E3))),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AiAssistantScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.map, color: Color(0xFFF6F4E3)),
              title: const Text('NDVI Hesaplama', style: TextStyle(color: Color(0xFFF6F4E3))),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NdviScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Image.asset('assets/flower_logo.png', height: 60),
            const SizedBox(height: 24),
            _buildNutrientCard('Azot', '18 mg/kg', const Color(0xFF737736)),
            const SizedBox(height: 12),
            _buildNutrientCard('Fosfor', '27 mg/kg', const Color(0xFF737736)),
            const SizedBox(height: 12),
            _buildNutrientCard('Potasyum', '241 mg/kg', const Color(0xFF7C6F2B)),
            const SizedBox(height: 24),
            const Text(
              'Hava Durumu',
              style: TextStyle(
                color: Color(0xFFF6F4E3),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildHourlyWeather(),
            const SizedBox(height: 20),
            _buildInfoCard('assets/humidity_icon.png', 'Nem', '71.0%'),
            const SizedBox(height: 12),
            _buildInfoCard('assets/wind_icon.png', 'Rüzgar', '2.19 km/sa'),
            const SizedBox(height: 12),
            _buildInfoCard('assets/direction_icon.png', 'Yön', 'B'),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientCard(String title, String value, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFFF6F4E3), fontSize: 18)),
          Text(value, style: const TextStyle(color: Color(0xFFF6F4E3), fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildHourlyWeather() {
    return Container(
      height: 140,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Color(0xFF495020),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: hourlyWeatherData.map((weather) {
            return Container(
              width: 70,
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wb_sunny, color: Colors.yellow[700], size: 32),
                  const SizedBox(height: 8),
                  Text(
                    '${weather['temp']}°',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    weather['hour']!,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String iconPath, String label, String value) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF6E7534),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Image.asset(iconPath, width: 24, height: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$label: $value',
              style: const TextStyle(
                color: Color(0xFFF6F4E3),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
