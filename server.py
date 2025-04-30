from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

# Gemini API Key
GEMINI_API_KEY = "AIzaSyAJen3M3YbE1low0mSZKguC8zUAQQ_59B0"

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


@app.route('/get-ndvi', methods=['POST'])
def get_ndvi():
    # Flutter'dan gelen veriler alınır ama gerçek EE kullanılmaz
    data = request.get_json()
    latitude = data.get('latitude')
    longitude = data.get('longitude')
    radius = data.get('radius')

    # Sahte NDVI haritası (herkese açık örnek görsel)
    return jsonify({
        'ndvi_url': 'https://upload.wikimedia.org/wikipedia/commons/7/7e/NDVI.png'
    })

if __name__ == '__main__':
    app.run(debug=True, port=5000)
