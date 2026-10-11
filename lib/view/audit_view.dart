import 'package:flutter/material.dart';
import 'package:strathclean/models/roles.dart';
import 'package:strathclean/models/user.dart';
import 'package:strathclean/services/clean_service.dart';
import 'package:strathclean/widgets/room_select.dart';

class AuditView extends StatefulWidget {
  const AuditView({
    super.key,
    this.title = 'Audit',
    this.logsClean = false,
    this.logsIssue = false,
    required this.user,
    required this.cleanService,
  });

  final String title;
  final bool logsClean;
  final bool logsIssue;
  final User user;
  final CleanService cleanService;

  @override
  State<AuditView> createState() => _AuditViewState();
}

class _AuditViewState extends State<AuditView> {
  String? _roomName;
  bool? _yesNo = true;
  String? _type;
  final _descriptionController = TextEditingController();
  var _saving = false;

  List<String> get _typeOptions => widget.user.role == Role.cleaner
      ? const ['external']
      : const ['cleaning', 'external'];

  @override
  void initState() {
    super.initState();
    if (widget.logsIssue && widget.user.role == Role.cleaner) {
      _type = 'external';
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_saving) return;
    final room = _roomName;
    if (room == null || room.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a room')),
      );
      return;
    }
    final issueTag = switch (_type) {
      'cleaning' => 'cleaners',
      'external' => 'external',
      _ => null,
    };
    if (widget.logsIssue) {
      if (issueTag == null) return;
    } else if (_yesNo != true && issueTag == null) {
      return;
    }
    final description = _descriptionController.text.trim();
    if ((widget.logsIssue || issueTag != null) && description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a description')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      if (widget.logsIssue) {
        await widget.cleanService.logIssueForRoom(
          room: room,
          description: description,
          tag: issueTag!,
        );
      } else {
        final cleanId = widget.logsClean
            ? await widget.cleanService.logClean(
                username: widget.user.username,
                room: room,
              )
            : await widget.cleanService.logAudit(
                username: widget.user.username,
                room: room,
              );
        if (issueTag != null) {
          await widget.cleanService.logIssue(
            cleanId: cleanId,
            description: description,
            tag: issueTag,
          );
        }
      }
      if (!mounted) return;
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.logsIssue
                ? 'Could not log issue: $error'
                : widget.logsClean
                    ? 'Could not log clean: $error'
                    : 'Could not save audit: $error',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _onYesNoChanged(bool? value) {
    setState(() {
      _yesNo = value;
      if (value != false) {
        _type = null;
        _descriptionController.clear();
      } else if (widget.user.role == Role.cleaner) {
        _type = 'external';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final showIssueFields = widget.logsIssue || _yesNo == false;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color.fromARGB(255, 19, 8, 68),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RoomSelect(
              value: _roomName,
              onChanged: (name) => setState(() => _roomName = name),
            ),
            const SizedBox(height: 12),
            if (!widget.logsIssue)
              DropdownButtonFormField<bool>(
              initialValue: _yesNo,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Yes / No',
              ),
              hint: const Text('Select'),
              items: const [
                DropdownMenuItem(value: true, child: Text('Yes')),
                DropdownMenuItem(value: false, child: Text('No')),
              ],
              onChanged: _onYesNoChanged,
            ),
            if (showIssueFields) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _typeOptions.contains(_type) ? _type : null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Type',
                ),
                hint: const Text('Select type'),
                items: _typeOptions
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(type[0].toUpperCase() + type.substring(1)),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _type = value),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
              ),
            ],
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _saving ? null : _submit,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
