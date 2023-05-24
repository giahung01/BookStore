import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  SearchState createState() => SearchState();

}

class SearchState extends State<SearchScreen> {

  List<String> suggestions = ['apple', 'banana', 'cherry', 'date', 'elderberry', 'fig', 'grape'];
  List<String> filteredSuggestions(String query) {
    return suggestions.where((suggestion) => suggestion.toLowerCase().contains(query.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return const Iterable<String>.empty();
          }
          return filteredSuggestions(textEditingValue.text);
        },
        onSelected: (String selection) {
          print('You just selected $selection');
        },
      )

    );
  }
}

