import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:strathclean/kml.dart';
import 'package:strathclean/services/sql_client.dart';

class RoomSelect extends StatefulWidget {
  const RoomSelect({super.key, required this.value, required this.onChanged});

  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  State<RoomSelect> createState() => _RoomSelectState();
}

class _RoomSelectState extends State<RoomSelect> {
  List<({String name, String? kml})> _rooms = [];
  String? _error;
  var _loaded = false;
  var _finding = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final rows = await SqlClient().query(
        'select name, kml from rooms order by name',
      );
      if (!mounted) return;
      setState(() {
        _rooms = [
          for (final row in rows)
            (name: row['name'] as String, kml: row['kml'] as String?),
        ];
        _error = null;
        _loaded = true;
      });
      await _nearest(quiet: true);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString();
        _loaded = true;
      });
    }
  }

  Future<void> _nearest({bool quiet = false}) async {
    if (_finding) return;
    final outlined = [
      for (final room in _rooms)
        if (parseRoomPolygonKml(room.kml).length >= 3) room,
    ];
    if (outlined.isEmpty) {
      if (!quiet) _say('No rooms have an outline');
      return;
    }
    setState(() => _finding = true);
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (!mounted) return;
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!quiet) _say('Location is off');
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 8),
        ),
      );
      if (!mounted) return;
      final ranked = roomsByDistance((
        lat: position.latitude,
        lon: position.longitude,
      ), _rooms);
      final nearest = ranked.first.meters == null ? null : ranked.first;
      setState(() {
        _rooms = [
          for (final room in ranked) (name: room.name, kml: room.kml),
        ];
      });
      if (nearest == null) {
        if (!quiet) _say('No rooms have an outline');
        return;
      }
      if (!quiet || widget.value == null) {
        widget.onChanged(nearest.name);
        final distance = nearest.meters!.round();
        _say(
          distance == 0
              ? 'In ${nearest.name}'
              : '${nearest.name}, ${distance}m away',
        );
      }
    } catch (_) {
      if (mounted && !quiet) _say('Location is off');
    } finally {
      if (mounted) setState(() => _finding = false);
    }
  }

  void _say(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final names = [for (final room in _rooms) room.name];
    final selected = names.contains(widget.value) ? widget.value : null;
    final hint = !_loaded
        ? 'Loading rooms'
        : _rooms.isEmpty
        ? 'No rooms'
        : 'Select room';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<String>(
          key: ValueKey(selected),
          initialValue: selected,
          isExpanded: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Room',
          ),
          hint: Text(hint),
          items: [
            for (final name in names)
              DropdownMenuItem(value: name, child: Text(name)),
          ],
          onChanged: _loaded && names.isNotEmpty ? widget.onChanged : null,
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: !_loaded || _finding ? null : _nearest,
          child: Text(_finding ? 'Finding room' : 'Nearest room'),
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
