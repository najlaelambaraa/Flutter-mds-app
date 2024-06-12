import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  final Function(String) onChanged;
  final String hintText;

  SearchBar({required this.onChanged, this.hintText = 'Recherche...'});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController _controller = TextEditingController();

  void _clearSearch() {
    _controller.clear();
    widget.onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[200], 
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: Theme.of(context).primaryColor), 
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Colors.grey[600], 
          ),
          border: InputBorder.none, 
          focusedBorder: InputBorder.none, 
          enabledBorder: InputBorder.none, 
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Color.fromARGB(255, 48, 120, 153)), 
                  onPressed: _clearSearch,
                )
              : null,
        ),
      ),
    );
  }
}
