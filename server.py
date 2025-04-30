from flask import Flask, request, jsonify
import ee
import requests

app = Flask(__name__)

# Gemini API Key
GEMINI_API_KEY = "AIzaSyAJen3M3YbE1low0mSZKguC8zUAQQ_59B0"

# Earth Engine Başlat
try:
    ee.Initialize(project='tarim-projesi-454911')  # kendi proje adını verdin
except Exception as e:
    print(f"Earth Engine başlatılamadı: {e}")

# Chat endpoint (Gemini API bağlantısı)
@app.route('/chat', methods=['POST'])
def chat():
    user_message = request.json.get('message')
    if not user_message:
        return jsonify({'error': 'Mesaj bulunamadı'}), 400

    url = f"https://generativelanguage.googleapis.com/v1/models/gemini-1.5-pro:generateContent?key={GEMINI_API_KEY}"

    payload = {
        "contents": [
            {
                "parts": [
                    {"text": user_message}
                ]
            }
        ]
    }

    try:
        response = requests.post(url, json=payload)
        if response.status_code == 200:
            data = response.json()
            ai_reply = data['candidates'][0]['content']['parts'][0]['text']
            return jsonify({'reply': ai_reply})
        else:
            return jsonify({'error': f"Gemini API hatası: {response.text}"}), 500

    except Exception as e:
        return jsonify({'error': str(e)}), 500

# NDVI endpoint (Earth Engine bağlantısı)
@app.route('/get-ndvi', methods=['POST'])
def get_ndvi():
    try:
        data = request.get_json()
        lat = data['latitude']
        lon = data['longitude']
        radius = data.get('radius', 1000)  # Radius opsiyonel, 1000 metre default

        point = ee.Geometry.Point(lon, lat)
        image = ee.ImageCollection('LANDSAT/LC08/C02/T1_L2') \
            .filterBounds(point) \
            .sort('CLOUD_COVER') \
            .first()

        ndvi = image.normalizedDifference(['SR_B5', 'SR_B4']).rename('NDVI')
        ndvi_params = {
            'min': 0.0,
            'max': 1.0,
            'dimensions': 500,
            'region': point.buffer(radius).bounds().getInfo(),
            'palette': ['blue', 'white', 'green']
        }
        url = ndvi.getThumbURL(ndvi_params)

        return jsonify({'ndvi_url': url})

    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, port=5000)
