import 'package:flutter/material.dart';
import 'package:mds_flutter_application/services/conversation_service.dart';

class ConversationDetailPage extends StatefulWidget {
  final String conversationTitle;
  final int conversationId;

  ConversationDetailPage({required this.conversationTitle, required this.conversationId});

  @override
  _ConversationDetailPageState createState() => _ConversationDetailPageState();
}

class _ConversationDetailPageState extends State<ConversationDetailPage> {
  List<String> _messages = [];
  TextEditingController _messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    try {
      List<String> messages = await ConversationService().getMessages(widget.conversationId);
      setState(() {
        _messages = messages;
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching messages: $e');
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty) {
      return;
    }

    try {
      await ConversationService().sendMessage(widget.conversationId, _messageController.text);
      _messageController.clear();
      _fetchMessages();
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  Future<void> _regenerateMessages() async {
    try {
      await ConversationService().regenerateMessage(widget.conversationId);
      _fetchMessages();
    } catch (e) {
      print('Error regenerating messages: $e');
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.conversationTitle),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(16.0),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      bool isMe = index % 2 == 0; 
                      bool isLastReceived = !isMe && index == _messages.length - 1; 
                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: isMe ? Color.fromARGB(255, 85, 167, 182) : Color.fromARGB(255, 231, 230, 230), 
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12.0),
                                  topRight: Radius.circular(12.0),
                                  bottomLeft: isMe ? Radius.circular(12.0) : Radius.circular(0),
                                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(12.0),
                                ),
                              ),
                              padding: EdgeInsets.all(12.0),
                              margin: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                _messages[index],
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            if (isLastReceived)
                              Positioned(
                                right: -10,
                                top: -10,
                                child: IconButton(
                                  icon: Icon(Icons.refresh, color: Colors.blue),
                                  onPressed: _regenerateMessages,
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Message here...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      fillColor: Color.fromARGB(255, 255, 254, 254),
                      filled: true,
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                CircleAvatar(
                  backgroundColor: Color(0xFF4A919E),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
