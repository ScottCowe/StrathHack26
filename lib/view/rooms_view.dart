import 'package:flutter/material.dart';

import 'package:strathclean/kml.dart';
import 'package:strathclean/services/room_service.dart';
import 'package:strathclean/widgets/room_outline.dart';

class RoomsView extends StatefulWidget {
  const RoomsView({super.key, required this.roomService, this.canEdit = false});

  final RoomService roomService;
  final bool canEdit;

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
      String? kml,
      DateTime? cleanTime,
    })
  >
  _rooms = [];
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
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _body(),
    );
  }

  Future<void> _edit(
    ({
      String name,
      String? notes,
      String? building,
      String? floor,
      String? kml,
      DateTime? cleanTime,
    })
    room,
  ) async {
    final result =
        await showDialog<
          ({
            bool delete,
            String name,
            String notes,
            String building,
            String floor,
            String? kml,
          })
        >(
          context: context,
          builder: (context) => _EditRoomDialog(
            name: room.name,
            notes: room.notes,
            building: room.building,
            floor: room.floor,
            kml: room.kml,
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
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Enter a room name')));
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
          kml: roomKmlFor(result.name, result.kml),
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
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
    return SingleChildScrollView(
      child: DataTable(
        columnSpacing: 24,
        horizontalMargin: 16,
        columns: [
          const DataColumn(label: Text('Name')),
          const DataColumn(label: Text('Building')),
          const DataColumn(label: Text('Floor')),
          const DataColumn(label: Text('Last cleaned')),
          const DataColumn(label: Text('Notes')),
          if (widget.canEdit) const DataColumn(label: Text('')),
        ],
        rows: [
          for (final room in _rooms)
            DataRow(
              cells: [
                DataCell(Text(room.name)),
                DataCell(Text(room.building ?? '')),
                DataCell(Text(room.floor ?? '')),
                DataCell(
                  Text(room.cleanTime == null ? '' : _when(room.cleanTime!)),
                ),
                DataCell(Text(room.notes == null ? '' : room.notes!)),
                if (widget.canEdit)
                  DataCell(
                    TextButton(
                      onPressed: () => _edit(room),
                      child: const Text('Edit'),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _EditRoomDialog extends StatefulWidget {
  const _EditRoomDialog({
    required this.name,
    required this.notes,
    required this.building,
    required this.floor,
    required this.kml,
  });

  final String name;
  final String? notes;
  final String? building;
  final String? floor;
  final String? kml;

  @override
  State<_EditRoomDialog> createState() => _EditRoomDialogState();
}

class _EditRoomDialogState extends State<_EditRoomDialog> {
  late final _name = TextEditingController(text: widget.name);
  late final _notes = TextEditingController(text: widget.notes ?? '');
  late final _building = TextEditingController(text: widget.building ?? '');
  late final _floor = TextEditingController(text: widget.floor ?? '');
  late var _kml = widget.kml;

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
      content: SizedBox(
        width: 360,
        child: SingleChildScrollView(
          child: Column(
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
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () async {
                  final saved = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RoomOutline(roomName: _name.text.trim(), kml: _kml),
                    ),
                  );
                  if (saved == null || !mounted) return;
                  setState(() => _kml = saved.isEmpty ? null : saved);
                },
                child: Text(
                  _kml == null
                      ? 'Draw outline'
                      : 'Edit outline (${parseRoomPolygonKml(_kml).length} corners)',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, (
            delete: true,
            name: '',
            notes: '',
            building: '',
            floor: '',
            kml: null,
          )),
          child: Text(
            'Delete',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, (
            delete: false,
            name: _name.text.trim(),
            notes: _notes.text.trim(),
            building: _building.text.trim(),
            floor: _floor.text.trim(),
            kml: _kml,
          )),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
