import 'package:flutter/material.dart';

import 'package:strathclean/services/room_service.dart';

class RoomsView extends StatefulWidget {
  const RoomsView({
    super.key,
    required this.roomService,
    this.canEdit = false,
  });

  final RoomService roomService;
  final bool canEdit;

  @override
  State<RoomsView> createState() => _RoomsViewState();
}

class _RoomsViewState extends State<RoomsView> {
  List<({String name, DateTime? cleanTime})> _rooms = [];
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
          const DataColumn(label: Text('Last cleaned')),
          if (widget.canEdit) const DataColumn(label: Text('')),
        ],
        rows: [
          for (final room in _rooms)
            DataRow(
              cells: [
                DataCell(Text(room.name)),
                DataCell(
                  Text(room.cleanTime == null ? '' : _when(room.cleanTime!)),
                ),
                if (widget.canEdit)
                  DataCell(
                    TextButton(onPressed: () {}, child: const Text('Edit')),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
