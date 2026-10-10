import 'package:flutter/material.dart';
import 'package:strathclean/services/sql_client.dart';
import 'package:strathclean/widgets/fuzzy_search.dart';

class RoomSelect extends StatefulWidget {
  const RoomSelect({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  State<RoomSelect> createState() => _RoomSelectState();
}

class _RoomSelectState extends State<RoomSelect> {
  List<String> _rooms = [];
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
        'select name from rooms order by name',
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _rooms = [for (final row in rows) row['name'] as String];
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
    final selected = _rooms.contains(widget.value) ? widget.value : null;
    final hint = !_loaded
        ? 'Loading rooms'
        : _rooms.isEmpty
            ? 'No rooms'
            : 'Select room';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<int>(
          key: ValueKey(
            '${_rooms.map((room) => room.id).join(',')}:$selected',
          ),
          initialValue: selected,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Room',
          ),
          hint: Text(hint),
          items: [
            for (final name in _rooms)
              DropdownMenuItem(value: name, child: Text(name)),
          ],
          onChanged: _rooms.isEmpty ? null : widget.onChanged,
        ),
        if (_rooms.isNotEmpty) ...[
          const SizedBox(height: 12),
          FuzzySearch(
            values: [for (final room in _rooms) room.name],
            onSelected: (name) {
              for (final room in _rooms) {
                if (room.name == name) {
                  widget.onChanged(room.id);
                  return;
                }
              }
            },
          ),
        ],
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
