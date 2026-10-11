import 'package:flutter/material.dart';

import 'package:strathclean/services/clean_service.dart';

typedef _Issue = ({
  int id,
  String? room,
  String? description,
  String tag,
  String priority,
  bool resolved,
});

class IssuesView extends StatefulWidget {
  const IssuesView({
    super.key,
    required this.cleanService,
    this.canEdit = false,
  });

  final CleanService cleanService;
  final bool canEdit;

  @override
  State<IssuesView> createState() => _IssuesViewState();
}

class _IssuesViewState extends State<IssuesView> {
  List<_Issue> _issues = [];
  String? _error;
  var _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final issues = await widget.cleanService.listIssues();
      if (!mounted) return;
      setState(() {
        _issues = issues;
        _error = null;
        _loaded = true;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString();
        _loaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.canEdit ? 'Manage issues' : 'View issues'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _body(),
    );
  }

  Future<void> _edit(_Issue issue) async {
    final result = await showDialog<
        ({
          bool delete,
          String description,
          String tag,
          String priority,
          bool resolved,
        })>(
      context: context,
      builder: (context) => _EditIssueDialog(issue: issue),
    );
    if (result == null || !mounted) return;

    if (result.delete) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete issue'),
          content: const Text('Delete this issue?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete'),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
    }

    try {
      if (result.delete) {
        await widget.cleanService.deleteIssue(issue.id);
      } else {
        await widget.cleanService.saveIssue(
          id: issue.id,
          description: result.description.isEmpty ? null : result.description,
          tag: result.tag,
          priority: result.priority,
          resolved: result.resolved,
        );
      }
      if (!mounted) return;
      await _load();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  Widget _body() {
    if (!_loaded) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Text(_error!));
    if (_issues.isEmpty) return const Center(child: Text('No issues'));
    return SingleChildScrollView(
      child: DataTable(
        columnSpacing: 24,
        horizontalMargin: 16,
        columns: [
          const DataColumn(label: Text('Room')),
          const DataColumn(label: Text('Description')),
          const DataColumn(label: Text('Tag')),
          const DataColumn(label: Text('Priority')),
          const DataColumn(label: Text('Resolved')),
          if (widget.canEdit) const DataColumn(label: Text('')),
        ],
        rows: [
          for (final issue in _issues)
            DataRow(
              cells: [
                DataCell(Text(issue.room ?? '')),
                DataCell(Text(issue.description ?? '')),
                DataCell(Text(_tagLabel(issue.tag))),
                DataCell(Text(_label(issue.priority))),
                DataCell(Text(issue.resolved ? 'Yes' : 'No')),
                if (widget.canEdit)
                  DataCell(
                    TextButton(
                      onPressed: () => _edit(issue),
                      child: const Text('Edit'),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  String _tagLabel(String tag) {
    return tag == 'cleaners' ? 'Cleaning' : _label(tag);
  }

  String _label(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }
}

class _EditIssueDialog extends StatefulWidget {
  const _EditIssueDialog({required this.issue});

  final _Issue issue;

  @override
  State<_EditIssueDialog> createState() => _EditIssueDialogState();
}

class _EditIssueDialogState extends State<_EditIssueDialog> {
  late final _description = TextEditingController(
    text: widget.issue.description ?? '',
  );
  late String _tag = widget.issue.tag;
  late String _priority = widget.issue.priority;
  late bool _resolved = widget.issue.resolved;

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit issue'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _description,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Description',
              alignLabelWithHint: true,
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _tag,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Tag',
            ),
            items: const [
              DropdownMenuItem(value: 'cleaners', child: Text('Cleaning')),
              DropdownMenuItem(value: 'external', child: Text('External')),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _tag = value);
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _priority,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Priority',
            ),
            items: const [
              DropdownMenuItem(value: 'low', child: Text('Low')),
              DropdownMenuItem(value: 'medium', child: Text('Medium')),
              DropdownMenuItem(value: 'high', child: Text('High')),
            ],
            onChanged: (value) {
              if (value != null) setState(() => _priority = value);
            },
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Resolved'),
            value: _resolved,
            onChanged: (value) => setState(() => _resolved = value ?? false),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(
            context,
            (
              delete: true,
              description: '',
              tag: _tag,
              priority: _priority,
              resolved: _resolved,
            ),
          ),
          child: Text(
            'Delete',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(
            context,
            (
              delete: false,
              description: _description.text.trim(),
              tag: _tag,
              priority: _priority,
              resolved: _resolved,
            ),
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
