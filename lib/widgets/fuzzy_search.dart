import 'package:flutter/material.dart';
import 'package:fuzzy_search_engine/fuzzy_search_engine.dart';

class FuzzySearch extends StatefulWidget {
  const FuzzySearch({
    required this.values,
    required this.onSelected,
    super.key,
  });

  final List<String> values;
  final ValueChanged<String> onSelected;

  @override
  State<StatefulWidget> createState() => FuzzySearchState();
}

class FuzzySearchState extends State<FuzzySearch> {
  List<String> results = [];

  void doSearch(query) {
    List<SearchableItem> items = [];
    widget.values.asMap().forEach((index, value) {
      items.add(SearchableItem(id: '$index', name: value));
    });
    final rresults = SearchEngine.fuzzySearch(items, query);
    setState(() {
      results = rresults.map((x) {
        return x.name;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SearchInput(onChange: doSearch),
          SearchResult(results: results, selectResult: widget.onSelected),
        ],
      ),
    );
  }
}

class SearchResult extends StatelessWidget {
  const SearchResult({
    required this.results,
    required this.selectResult,
    super.key,
  });

  final List<String> results;
  final void Function(String) selectResult;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: results.map((res) {
        void onPressed() => selectResult(res);
        return ElevatedButton(onPressed: onPressed, child: Text(res));
      }).toList(),
    );
  }
}

class SearchInput extends StatefulWidget {
  const SearchInput({required this.onChange, super.key});

  final void Function(String) onChange;

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void onChange() {
    final text = searchController.text;
    widget.onChange(text);
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(onChange);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: searchController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'ex: LT420',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a room number';
        }
        return null;
      },
    );
  }
}
