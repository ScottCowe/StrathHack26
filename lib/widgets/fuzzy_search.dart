import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fuzzy_search_engine/fuzzy_search_engine.dart';

class FuzzySearch extends StatefulWidget {
  const FuzzySearch({
    required this.values,
    required this.onSelected,
    this.value,
    this.label,
    this.hint,
    this.enabled = true,
    Key? key,
  }) : super(key: key);

  final List<String> values;
  final ValueChanged<String> onSelected;
  final String? value;
  final String? label;
  final String? hint;
  final bool enabled;

  @override
  State<StatefulWidget> createState() => FuzzySearchState();
}

class FuzzySearchState extends State<FuzzySearch> {
  final searchController = TextEditingController();
  final focusNode = FocusNode();
  List<String> results = [];
  var _suppress = false;
  var _applyingSelection = false;

  @override
  void initState() {
    super.initState();
    searchController.text = widget.value ?? '';
    searchController.addListener(_onText);
    focusNode.addListener(_onFocus);
  }

  @override
  void didUpdateWidget(FuzzySearch oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = widget.value ?? '';
    if (widget.value != oldWidget.value && next != searchController.text) {
      _suppress = true;
      searchController.text = next;
      _suppress = false;
    }
    if (focusNode.hasFocus && !_sameOrder(oldWidget.values, widget.values)) {
      _search(searchController.text);
    }
  }

  bool _sameOrder(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  void dispose() {
    searchController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void _onText() {
    if (_suppress || !focusNode.hasFocus) {
      return;
    }
    _search(searchController.text);
  }

  void _onFocus() {
    if (focusNode.hasFocus) {
      _search('');
      return;
    }
    if (_applyingSelection) {
      _applyingSelection = false;
      return;
    }

    final selected = widget.value ?? '';
    if (searchController.text != selected) {
      _suppress = true;
      searchController.text = selected;
      _suppress = false;
    }
    if (results.isNotEmpty) {
      setState(() => results = []);
    }
  }

  void _search(String query) {
    final trimmed = query.trim();
    final List<String> next;
    if (trimmed.isEmpty) {
      next = widget.values;
    } else {
      final items = [
        for (var index = 0; index < widget.values.length; index++)
          SearchableItem(id: '$index', name: widget.values[index]),
      ];
      next = SearchEngine.fuzzySearch(
        items,
        trimmed,
      ).map((item) => item.name).toList();
    }
    setState(() => results = next);
  }

  void select(String name) {
    _applyingSelection = true;
    _suppress = true;
    searchController.text = name;
    _suppress = false;
    widget.onSelected(name);
    setState(() => results = []);
    focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).colorScheme.outline;

    return TapRegion(
      onTapOutside: (_) => focusNode.unfocus(),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SearchInput(
              controller: searchController,
              focusNode: focusNode,
              label: widget.label,
              hint: widget.hint,
              enabled: widget.enabled,
            ),
            if (results.isNotEmpty) ...[
              Divider(height: 1, color: borderColor),
              SearchResult(results: results, selectResult: select),
            ],
          ],
        ),
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
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 200),
      child: ListView(
        shrinkWrap: true,
        children: [
          for (final result in results)
            InkWell(
              onTapDown: (_) => selectResult(result),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Text(result),
              ),
            ),
        ],
      ),
    );
  }
}

class SearchInput extends StatelessWidget {
  const SearchInput({
    required this.controller,
    required this.focusNode,
    this.label,
    this.hint,
    this.enabled = true,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String? label;
  final String? hint;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      onTapOutside: (_) {},
      decoration: InputDecoration(
        border: InputBorder.none,
        labelText: label,
        hintText: hint,
        contentPadding: const EdgeInsets.fromLTRB(12, 8, 0, 8),
        suffixIcon: const Icon(Icons.arrow_drop_down),
      ),
    );
  }
}
