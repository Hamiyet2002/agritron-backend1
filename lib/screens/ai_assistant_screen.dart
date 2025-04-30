import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({Key? key}) : super(key: key);

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final ScrollController _scrollController = ScrollController();
  bool _isNearBottom = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_checkIfNearBottom);
  }

  void _checkIfNearBottom() {
    if (!_scrollController.hasClients) return;
    double maxScroll = _scrollController.position.maxScrollExtent;
    double currentScroll = _scrollController.position.pixels;
    const double threshold = 100.0;
    setState(() {
      _isNearBottom = (maxScroll - currentScroll) < threshold;
    });
  }

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;
    String userInput = _controller.text.trim();

    setState(() {
      _messages.add({'role': 'user', 'text': userInput});
      _controller.clear();
    });

    _scrollToBottomIfNeeded();

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/chat'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8', // Türkçe karakter desteği
        },
        body: jsonEncode({'message': userInput}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes)); // Türkçe karakter decode
        final aiReply = data['reply'] ?? 'Cevap alınamadı.';

        setState(() {
          _messages.add({'role': 'ai', 'text': aiReply});
        });

        _scrollToBottomIfNeeded();
      } else {
        setState(() {
          _messages.add({'role': 'ai', 'text': 'Sunucu hatası: ${response.statusCode}'});
        });

        _scrollToBottomIfNeeded();
      }
    } catch (e) {
      setState(() {
        _messages.add({'role': 'ai', 'text': 'Hata: $e'});
      });

      _scrollToBottomIfNeeded();
    }
  }

  void _scrollToBottomIfNeeded() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients && _isNearBottom) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD1CD9F),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUser = message['role'] == 'user';
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                      decoration: BoxDecoration(
                        color: isUser ? const Color(0xFF345128) : const Color(0xFF5E7339),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(20),
                          topRight: const Radius.circular(20),
                          bottomLeft: isUser ? const Radius.circular(20) : const Radius.circular(0),
                          bottomRight: isUser ? const Radius.circular(0) : const Radius.circular(20),
                        ),
                      ),
                      child: Text(
                        message['text'] ?? '',
                        style: const TextStyle(
                          color: Color(0xFFF7F8F3),
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFFD1CD9F),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDFDAAE),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller: _controller,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.send,
                        style: const TextStyle(color: Color(0xFF62673C)),
                        decoration: const InputDecoration(
                          hintText: "Mesajınızı yazın...",
                          hintStyle: TextStyle(color: Color(0xFF62673C)),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: _sendMessage,
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xFF5E7339),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Color(0xFFF7F8F3),
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
