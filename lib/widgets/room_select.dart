import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:strathclean/kml.dart';
import 'package:strathclean/services/sql_client.dart';
import 'package:strathclean/widgets/scan_room_number.dart';

class RoomSelect extends StatefulWidget {
  const RoomSelect({super.key, required this.value, required this.onChanged});

  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  State<RoomSelect> createState() => _RoomSelectState();
}

class _RoomSelectState extends State<RoomSelect> {
  List<({String name, String? building, String? floor, String? kml})> _rooms =
      [];
  String? _building;
  String? _floor;
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
        'select name, building, floor, kml from rooms order by name',
      );
      if (!mounted) return;
      setState(() {
        _rooms = [
          for (final row in rows)
            (
              name: row['name'] as String,
              building: _text(row['building']),
              floor: _text(row['floor']),
              kml: row['kml'] as String?,
            ),
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

  List<({String name, String? building, String? floor, String? kml})>
  _chosen() {
    return [
      for (final room in _rooms)
        if ((_building == null || room.building == _building) &&
            (_floor == null || room.floor == _floor))
          room,
    ];
  }

  Future<void> _nearest({bool quiet = false}) async {
    if (_finding) return;
    if (!_outlined(_chosen())) {
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
      final chosen = _chosen();
      if (!_outlined(chosen)) {
        if (!quiet) _say('No rooms have an outline');
        return;
      }
      final ranked = roomsByDistance((
        lat: position.latitude,
        lon: position.longitude,
      ), [
        for (final room in chosen) (name: room.name, kml: room.kml),
      ]);
      final byName = {for (final room in _rooms) room.name: room};
      final nearest = ranked.first.meters == null ? null : ranked.first;
      final room = nearest == null ? null : byName[nearest.name];
      final picked = {for (final entry in ranked) entry.name};
      final fill = room != null && (!quiet || widget.value == null);
      setState(() {
        _rooms = [
          for (final entry in ranked) byName[entry.name]!,
          for (final existing in _rooms)
            if (!picked.contains(existing.name)) existing,
        ];
        if (fill) {
          _building ??= room.building;
          _floor ??= room.floor;
        }
      });
      if (nearest == null || room == null) {
        if (!quiet) _say('No rooms have an outline');
        return;
      }
      if (fill) {
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

  void _pickBuilding(String? building) {
    setState(() {
      _building = building;
      _floor = null;
    });
    widget.onChanged(null);
  }

  void _pickFloor(String? floor) {
    setState(() => _floor = floor);
    widget.onChanged(null);
  }

  void _onScan(String name) {
    for (final room in _rooms) {
      if (room.name != name) continue;
      setState(() {
        _building = room.building;
        _floor = room.floor;
      });
      widget.onChanged(room.name);
      return;
    }
    _say('No room $name');
  }

  Future<void> _scan() async {
    final code = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (routeContext) => Scaffold(
          appBar: AppBar(
            title: const Text('Scan room code'),
            backgroundColor: const Color.fromARGB(255, 19, 8, 68),
            foregroundColor: Colors.white,
          ),
          body: SizedBox.expand(
            child: ScanRoomNumber(
              onDetect: (code) {
                if (code.isEmpty) return;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (routeContext.mounted) Navigator.pop(routeContext, code);
                });
              },
            ),
          ),
        ),
      ),
    );
    if (!mounted || code == null || code.isEmpty) return;
    _onScan(code);
  }

  void _say(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final buildings = {
      for (final room in _rooms)
        if (room.building != null) room.building!,
    }.toList()..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    final floors = {
      for (final room in _rooms)
        if (room.building == _building && room.floor != null) room.floor!,
    }.toList()..sort(compareFloors);
    final names = [
      for (final room in _rooms)
        if (room.building == _building && room.floor == _floor) room.name,
    ];
    final selected = names.contains(widget.value) ? widget.value : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _menu(
          label: 'Building',
          value: _building,
          items: buildings,
          hint: !_loaded
              ? 'Loading rooms'
              : buildings.isEmpty
              ? 'No buildings'
              : 'Select building',
          onChanged: _loaded && buildings.isNotEmpty ? _pickBuilding : null,
        ),
        const SizedBox(height: 12),
        _menu(
          label: 'Floor',
          value: _floor,
          items: floors,
          hint: _building == null
              ? 'Select building'
              : floors.isEmpty
              ? 'No floors'
              : 'Select floor',
          onChanged: _building != null && floors.isNotEmpty ? _pickFloor : null,
        ),
        const SizedBox(height: 12),
        _menu(
          label: 'Room',
          value: selected,
          items: names,
          hint: _floor == null
              ? 'Select floor'
              : names.isEmpty
              ? 'No rooms'
              : 'Select room',
          onChanged: _floor != null && names.isNotEmpty
              ? widget.onChanged
              : null,
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: !_loaded || _finding ? null : _nearest,
          child: Text(_finding ? 'Finding room' : 'Nearest room'),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: _loaded ? _scan : null,
          child: const Text("Can't see room? Tap here to scan room code"),
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

  Widget _menu({
    required String label,
    required String? value,
    required List<String> items,
    required String hint,
    required ValueChanged<String?>? onChanged,
  }) {
    final selected = items.contains(value) ? value : null;
    return DropdownButtonFormField<String>(
      key: ValueKey('$label:$selected'),
      initialValue: selected,
      isExpanded: true,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
      ),
      hint: Text(hint),
      items: [
        for (final item in items)
          DropdownMenuItem(value: item, child: Text(item)),
      ],
      onChanged: onChanged,
    );
  }
}

bool _outlined(
  List<({String name, String? building, String? floor, String? kml})> rooms,
) {
  for (final room in rooms) {
    if (parseRoomPolygonKml(room.kml).length >= 3) return true;
  }
  return false;
}

String? _text(Object? value) {
  if (value is! String) return null;
  final text = value.trim();
  return text.isEmpty ? null : text;
}

int compareFloors(String a, String b) {
  final left = int.tryParse(a);
  final right = int.tryParse(b);
  if (left != null && right != null) return left.compareTo(right);
  return a.toLowerCase().compareTo(b.toLowerCase());
}
