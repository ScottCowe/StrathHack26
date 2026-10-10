import 'package:flutter/material.dart';

class AuditView extends StatefulWidget {
  const AuditView({super.key});

  @override
  State<AuditView> createState() => _AuditViewState();
}

class _AuditViewState extends State<AuditView> {
  static const _roomNames = <String>[];
  static const _typeOptions = ['cleaning', 'external'];

  String? _roomName;
  bool? _yesNo;
  String? _type;
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _onYesNoChanged(bool? value) {
    setState(() {
      _yesNo = value;
      if (value != false) {
        _type = null;
        _descriptionController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final showIssueFields = _yesNo == false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Audit'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _roomNames.contains(_roomName) ? _roomName : null,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Room name',
              ),
              hint: const Text('Select room'),
              items: _roomNames
                  .map(
                    (room) => DropdownMenuItem(
                      value: room,
                      child: Text(room),
                    ),
                  )
                  .toList(),
              onChanged:
                  _roomNames.isEmpty ? null : (value) => setState(() => _roomName = value),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<bool>(
              value: _yesNo,
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
                value: _typeOptions.contains(_type) ? _type : null,
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
          ],
        ),
      ),
    );
  }
}
