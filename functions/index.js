const functions = require("firebase-functions");
const express = require("express");
const cors = require("cors");
const axios = require("axios");

const app = express();
app.use(cors({ origin: true }));
app.use(express.json());

const GEMINI_API_KEY = "AIzaSyAJen3M3YbE1low0mSZKguC8zUAQQ_59B0"; // senin API key’in

// 🧠 Chat endpoint
app.post("/chat", async (req, res) => {
  const message = req.body.message;
  const url = `https://generativelanguage.googleapis.com/v1/models/gemini-1.5-pro:generateContent?key=${GEMINI_API_KEY}`;

  try {
    const response = await axios.post(url, {
      contents: [{ parts: [{ text: message }] }],
    });

    const reply = response.data.candidates[0].content.parts[0].text;
    res.json({ reply: reply });
  } catch (error) {
    console.error("Gemini API error:", error.message);
    res.status(500).json({ error: "Gemini API failed." });
  }
});

// 🌱 NDVI endpoint (örnek çıktı)
app.post("/get-ndvi", (req, res) => {
  const { lat, lon, radius } = req.body;
  res.json({
    imageUrl: "https://upload.wikimedia.org/wikipedia/commons/thumb/7/7a/NDVI_image.png/640px-NDVI_image.png",
    lat,
    lon,
    radius
  });
});

exports.api = functions.https.onRequest(app);
