import 'package:flutter/material.dart';

import 'package:strathclean/services/clean_service.dart';

typedef _Issue = ({
  int id,
  String? room,
  String? description,
  String tag,
  String priority,
  bool resolved,
  String? image,
  String? loggedBy,
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
      final issues = await widget.cleanService.listIssues(
        includeCleaning: widget.canEdit,
      );
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
        backgroundColor: const Color.fromARGB(255, 19, 8, 68),
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
          image: issue.image,
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
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _issues.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final issue = _issues[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  issue.room ?? 'Unknown room',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(issue.description ?? ''),
                const SizedBox(height: 8),
                Text('${_tagLabel(issue.tag)} · ${_label(issue.priority)}'),
                Text('Logged by ${issue.loggedBy ?? 'Unknown'}'),
                if(issue.image != null)
                  Image.network(issue.image ?? ""),
                if (widget.canEdit)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => _edit(issue),
                      child: const Text('Edit'),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
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
