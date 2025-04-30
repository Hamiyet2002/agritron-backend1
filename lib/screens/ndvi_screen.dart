import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NdviScreen extends StatefulWidget {
  const NdviScreen({Key? key}) : super(key: key);

  @override
  State<NdviScreen> createState() => _NdviScreenState();
}

class _NdviScreenState extends State<NdviScreen> {
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController radiusController = TextEditingController();

  String? ndviUrl;
  bool isLoading = false;

  Future<void> fetchNDVI(double latitude, double longitude, double radius) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/get-ndvi'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'latitude': latitude,
        'longitude': longitude,
        'radius': radius,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        ndviUrl = data['ndvi_url'];
        isLoading = false;
      });
    } else {
      print('NDVI isteği başarısız: ${response.statusCode}');
      setState(() {
        isLoading = false;
      });
    }
  }

  void getNDVI() {
    final double? latitude = double.tryParse(latitudeController.text);
    final double? longitude = double.tryParse(longitudeController.text);
    final double? radius = double.tryParse(radiusController.text);

    if (latitude != null && longitude != null && radius != null) {
      setState(() {
        isLoading = true;
      });
      fetchNDVI(latitude, longitude, radius);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen geçerli enlem, boylam ve yarıçap girin')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF083727),
      appBar: AppBar(
        backgroundColor: const Color(0xFF083727),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'NDVI Haritası',
          style: TextStyle(
            color: Color(0xFFF7F8F3),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFF7F8F3)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildInputField('Enlem', latitudeController, 'Örnek: 39.9208')),
                const SizedBox(width: 8),
                Expanded(child: _buildInputField('Boylam', longitudeController, 'Örnek: 32.8541')),
              ],
            ),
            const SizedBox(height: 10),
            _buildInputField('Yarıçap (m)', radiusController, 'Örnek: 500'),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: getNDVI,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF13402F), Color(0xFF1A5E3F)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'NDVI Haritasını Gör',
                    style: TextStyle(
                      color: Color(0xFFF7F8F3),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // NDVI Haritası Alanı
            if (isLoading)
              const CircularProgressIndicator()
            else
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey[800], // Boş arka plan
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ndviUrl == null
                    ? const Center(
                  child: Text(
                    'NDVI Haritası burada görüntülenecek',
                    style: TextStyle(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    ndviUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            const SizedBox(height: 12),
            _buildColorScaleBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF13402F),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: controller,
            style: const TextStyle(color: Color(0xFFF7F8F3)),
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: label,
              labelStyle: const TextStyle(color: Color(0xFFF7F8F3)),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          hint,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildColorScaleBar() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 15,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            gradient: LinearGradient(
              colors: [
                Colors.red,
                Colors.orange,
                Colors.yellow,
                Colors.lightGreen,
                Colors.green,
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text('Min: 0.0', style: TextStyle(color: Color(0xFFF7F8F3))),
            Text('Max: 1.0', style: TextStyle(color: Color(0xFFF7F8F3))),
          ],
        ),
      ],
    );
  }
}
