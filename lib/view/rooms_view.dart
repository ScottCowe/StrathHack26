import 'package:flutter/material.dart';

import 'package:strathclean/models/user.dart';
import 'package:strathclean/services/room_service.dart';

class RoomsView extends StatefulWidget {
  const RoomsView({
    super.key,
    required this.roomService,
    this.canEdit = false,
    this.user,
  });

  final RoomService roomService;
  final bool canEdit;
  final User? user;

  @override
  State<RoomsView> createState() => _RoomsViewState();
}

class _RoomsViewState extends State<RoomsView> {
  List<
      ({
        String name,
        String? notes,
        String? building,
        String? floor,
        DateTime? cleanTime,
      })> _rooms = [];
  String? _error;
  var _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final rooms = await widget.roomService.listRooms();
      if (!mounted) return;
      setState(() {
        _rooms = rooms;
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
        title: Text(widget.canEdit ? 'Manage rooms' : 'View rooms'),
        backgroundColor: const Color.fromARGB(255, 19, 8, 68),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          if (widget.canEdit)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: ElevatedButton(
                onPressed: _add,
                child: const Text('Add new room'),
              ),
            ),
          Expanded(child: _body()),
        ],
      ),
    );
  }

  Future<void> _add() async {
    await Navigator.pushNamed(
      context,
      '/add-room',
      arguments: widget.user,
    );
    if (!mounted) return;
    await _load();
  }

  Future<void> _edit(
    ({
      String name,
      String? notes,
      String? building,
      String? floor,
      DateTime? cleanTime,
    }) room,
  ) async {
    final result = await showDialog<
        ({
          bool delete,
          String name,
          String notes,
          String building,
          String floor,
        })>(
      context: context,
      builder: (context) => _EditRoomDialog(
        name: room.name,
        notes: room.notes,
        building: room.building,
        floor: room.floor,
      ),
    );
    if (result == null || !mounted) return;

    if (result.delete) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Delete room'),
          content: Text('Delete ${room.name}?'),
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
    } else if (result.name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a room name')),
      );
      return;
    }

    try {
      if (result.delete) {
        await widget.roomService.deleteRoom(room.name);
      } else {
        await widget.roomService.saveRoom(
          name: room.name,
          newName: result.name,
          notes: result.notes.isEmpty ? null : result.notes,
          building: result.building.isEmpty ? null : result.building,
          floor: result.floor.isEmpty ? null : result.floor,
        );
      }
      if (!mounted) return;
      await _load();
    } catch (error) {
      if (!mounted) return;
      final text = error.toString();
      final message = result.delete && text.contains('cleans_room_fkey')
          ? 'This room has cleans and cannot be deleted'
          : text.contains('rooms_pkey')
              ? 'A room with that name already exists'
              : text;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  String _when(DateTime time) {
    final day = time.day.toString().padLeft(2, '0');
    final month = time.month.toString().padLeft(2, '0');
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$day/$month/${time.year} $hour:$minute';
  }

  Widget _body() {
    if (!_loaded) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Text(_error!));
    if (_rooms.isEmpty) return const Center(child: Text('No rooms'));
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _rooms.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final room = _rooms[index];
        final place = [
          if (room.building != null && room.building!.isNotEmpty) room.building!,
          if (room.floor != null && room.floor!.isNotEmpty) 'Floor ${room.floor}',
        ].join(' · ');
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  room.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                if (place.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(place),
                ],
                const SizedBox(height: 8),
                Text(
                  room.cleanTime == null
                      ? 'Not cleaned yet'
                      : 'Last cleaned ${_when(room.cleanTime!)}',
                ),
                if (room.notes != null && room.notes!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(room.notes!),
                ],
                if (widget.canEdit)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => _edit(room),
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
}

class _EditRoomDialog extends StatefulWidget {
  const _EditRoomDialog({
    required this.name,
    required this.notes,
    required this.building,
    required this.floor,
  });

  final String name;
  final String? notes;
  final String? building;
  final String? floor;

  @override
  State<_EditRoomDialog> createState() => _EditRoomDialogState();
}

class _EditRoomDialogState extends State<_EditRoomDialog> {
  late final _name = TextEditingController(text: widget.name);
  late final _notes = TextEditingController(text: widget.notes ?? '');
  late final _building = TextEditingController(text: widget.building ?? '');
  late final _floor = TextEditingController(text: widget.floor ?? '');

  @override
  void dispose() {
    _name.dispose();
    _notes.dispose();
    _building.dispose();
    _floor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit room'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _name,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Room name',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _building,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Building',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _floor,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Floor',
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notes,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Notes',
              alignLabelWithHint: true,
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(
            context,
            (delete: true, name: '', notes: '', building: '', floor: ''),
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
              name: _name.text.trim(),
              notes: _notes.text.trim(),
              building: _building.text.trim(),
              floor: _floor.text.trim(),
            ),
          ),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
