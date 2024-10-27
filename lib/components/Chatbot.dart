import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:intl/intl.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Chatbot> {
  final TextEditingController _userMessage = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  static const apiKey = 'AIzaSyCoX6X4xDSaD7W8NXQvyXTyQexqUOmKXaY';

  final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

  final List<Message> _messages = [];

  Future<void> sendMessage() async {
    final message = _userMessage.text;
    _userMessage.clear();

    setState(() {
      _messages
          .add(Message(isUser: true, message: message, date: DateTime.now()));
    });

    _scrollToBottom();

    final content = [Content.text(message)];
    final response = await model.generateContent(content);

    setState(() {
      _messages.add(Message(
          isUser: false, message: response.text ?? "", date: DateTime.now()));
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              return Messages(
                isUser: message.isUser,
                message: message.message,
                date: DateFormat('HH:mm').format(message.date),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
          child: Row(
            children: [
              Expanded(
                flex: 15,
                child: TextFormField(
                  controller: _userMessage,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    fillColor: Colors.white,
                    label: const Text('Enter your message'),
                    labelStyle: TextStyle(color: Colors.white),
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                padding: const EdgeInsets.all(15),
                iconSize: 30,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.black),
                  foregroundColor: WidgetStateProperty.all(Colors.white),
                  shape: WidgetStateProperty.all(const CircleBorder()),
                ),
                onPressed: () {
                  sendMessage();
                },
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class Messages extends StatelessWidget {
  final bool isUser;
  final String message;
  final String date;
  const Messages(
      {super.key,
      required this.isUser,
      required this.message,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(vertical: 15).copyWith(
        left: isUser ? 100 : 10,
        right: isUser ? 10 : 100,
      ),
      decoration: BoxDecoration(
          color: isUser ? Colors.red : Colors.grey.shade300,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(10),
            bottomLeft: isUser ? const Radius.circular(10) : Radius.zero,
            topRight: const Radius.circular(10),
            bottomRight: isUser ? Radius.zero : const Radius.circular(10),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(color: isUser ? Colors.white : Colors.black),
          ),
          Text(
            date,
            style: TextStyle(color: isUser ? Colors.white : Colors.black),
          )
        ],
      ),
    );
  }
}

class Message {
  final bool isUser;
  final String message;
  final DateTime date;

  Message({
    required this.isUser,
    required this.message,
    required this.date,
  });
}
