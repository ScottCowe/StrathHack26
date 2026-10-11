import 'package:flutter/material.dart';

import 'package:strathclean/kml.dart';
import 'package:strathclean/services/room_service.dart';
import 'package:strathclean/widgets/room_outline.dart';

class AddRoomView extends StatefulWidget {
  const AddRoomView({super.key, required this.roomService});

  final RoomService roomService;

  @override
  State<AddRoomView> createState() => _AddRoomViewState();
}

class _AddRoomViewState extends State<AddRoomView> {
  final _nameController = TextEditingController();
  final _buildingController = TextEditingController();
  final _floorController = TextEditingController();
  final _notesController = TextEditingController();
  String? _kml;
  var _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _buildingController.dispose();
    _floorController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (_saving) return;
    if (name.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Enter a room name')));
      return;
    }

    final notes = _notesController.text.trim();
    final building = _buildingController.text.trim();
    final floor = _floorController.text.trim();
    setState(() => _saving = true);
    try {
      await widget.roomService.addRoom(
        name: name,
        notes: notes.isEmpty ? null : notes,
        building: building.isEmpty ? null : building,
        floor: floor.isEmpty ? null : floor,
        kml: roomKmlFor(name, _kml),
      );
      if (!mounted) return;
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not add room: $error')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _draw() async {
    final saved = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RoomOutline(roomName: _nameController.text.trim(), kml: _kml),
      ),
    );
    if (saved == null || !mounted) return;
    setState(() => _kml = saved.isEmpty ? null : saved);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new room'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Room name',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _buildingController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Building',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _floorController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Floor',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Notes',
              alignLabelWithHint: true,
            ),
            maxLines: 4,
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: _saving ? null : _draw,
            child: Text(
              _kml == null
                  ? 'Draw outline'
                  : 'Edit outline (${parseRoomPolygonKml(_kml).length} corners)',
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _saving ? null : _submit,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
