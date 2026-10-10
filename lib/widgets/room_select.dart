import 'package:flutter/material.dart';
import 'package:strathclean/services/sql_client.dart';

class RoomSelect extends StatefulWidget {
  const RoomSelect({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final int? value;
  final ValueChanged<int?> onChanged;

  @override
  State<RoomSelect> createState() => _RoomSelectState();
}

class _RoomSelectState extends State<RoomSelect> {
  List<({int id, String name})> _rooms = [];
  String? _error;
  var _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final rows = await SqlClient().query(
        'select id, name from rooms order by name',
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _rooms = [
          for (final row in rows)
            (id: (row['id'] as num).toInt(), name: row['name'] as String),
        ];
        _error = null;
        _loaded = true;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = error.toString();
        _loaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = _rooms.any((room) => room.id == widget.value)
        ? widget.value
        : null;
    final hint = !_loaded
        ? 'Loading rooms'
        : _rooms.isEmpty
            ? 'No rooms'
            : 'Select room';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<int>(
          key: ValueKey(_rooms.map((room) => room.id).join(',')),
          initialValue: selected,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Room',
          ),
          hint: Text(hint),
          items: [
            for (final room in _rooms)
              DropdownMenuItem(value: room.id, child: Text(room.name)),
          ],
          onChanged: _rooms.isEmpty ? null : widget.onChanged,
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
      ],
    );
  }
}
