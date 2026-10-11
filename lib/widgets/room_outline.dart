import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:strathclean/kml.dart';

/// Tap corners of the room on the map, then drag them. Pops the KML string,
/// or '' to clear.
///
/// shortcut: outdoor map, tiles stop at zoom 19. Swap the tile URL for an
/// indoor floor plan when one exists.
class RoomOutline extends StatefulWidget {
  const RoomOutline({super.key, required this.roomName, this.kml});

  final String roomName;
  final String? kml;

  @override
  State<RoomOutline> createState() => _RoomOutlineState();
}

class _RoomOutlineState extends State<RoomOutline> {
  static const _campus = LatLng(55.8614, -4.2430);
  static const _outline = Color(0xFF1565C0);

  final _map = MapController();
  final _points = <LatLng>[];
  LatLng? _here;
  StreamSubscription<Position>? _fixes;

  @override
  void initState() {
    super.initState();
    _points.addAll([
      for (final point in parseRoomPolygonKml(widget.kml))
        LatLng(point.lat, point.lon),
    ]);
  }

  @override
  void dispose() {
    _fixes?.cancel();
    _map.dispose();
    super.dispose();
  }

  Future<void> _locate({bool quiet = false, bool pan = true}) async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (!mounted) return;
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!quiet) _say('Location is off. Pan the map to the room.');
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 8),
        ),
      );
      if (!mounted) return;
      final here = LatLng(position.latitude, position.longitude);
      setState(() => _here = here);
      if (pan) _map.move(here, 19);
      _fixes ??= Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 2,
        ),
      ).listen((update) {
        if (!mounted) return;
        setState(() {
          _here = LatLng(update.latitude, update.longitude);
        });
      });
    } catch (_) {
      if (!quiet && mounted) {
        _say('Location is off. Pan the map to the room.');
      }
    }
  }

  void _say(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  bool _onHandle(LatLng point) {
    final tap = _map.camera.latLngToScreenOffset(point);
    for (final existing in _points) {
      final handle = _map.camera.latLngToScreenOffset(existing);
      if ((tap - handle).distance < 22) return true;
    }
    return false;
  }

  void _save() {
    if (_points.length == 1 || _points.length == 2) {
      _say('Mark at least 3 corners');
      return;
    }
    if (_points.isEmpty) {
      Navigator.pop(context, '');
      return;
    }
    Navigator.pop(
      context,
      roomPolygonKml(widget.roomName.isEmpty ? 'Room' : widget.roomName, [
        for (final point in _points)
          (lat: point.latitude, lon: point.longitude),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Room outline'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              mapController: _map,
              options: MapOptions(
                initialCenter: _points.isEmpty ? _campus : _points.first,
                initialZoom: 18,
                maxZoom: 19,
                initialCameraFit: _points.length < 2
                    ? null
                    : CameraFit.coordinates(
                        coordinates: _points,
                        padding: const EdgeInsets.all(48),
                        maxZoom: 19,
                      ),
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                ),
                onMapReady: () => _locate(quiet: true, pan: _points.isEmpty),
                onTap: (_, point) {
                  if (_onHandle(point)) return;
                  setState(() => _points.add(point));
                },
              ),
              children: [
                TileLayer(
                  // OSM: no API key, and it works in the web build.
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'strathclean',
                ),
                if (_points.length >= 3)
                  PolygonLayer(
                    polygons: [
                      Polygon(
                        points: _points,
                        color: const Color(0x552196F3),
                        borderStrokeWidth: 3,
                        borderColor: _outline,
                      ),
                    ],
                  )
                else if (_points.length >= 2)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _points,
                        strokeWidth: 3,
                        color: _outline,
                      ),
                    ],
                  ),
                if (_here != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _here!,
                        width: 18,
                        height: 18,
                        child: const IgnorePointer(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Color(0xFF2E7D32),
                              shape: BoxShape.circle,
                              border: Border.fromBorderSide(
                                BorderSide(color: Colors.white, width: 3),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: [
                    for (var i = 0; i < _points.length; i++)
                      Marker(
                        point: _points[i],
                        width: 28,
                        height: 28,
                        child: RawGestureDetector(
                          behavior: HitTestBehavior.opaque,
                          gestures: {
                            _EagerPan:
                                GestureRecognizerFactoryWithHandlers<_EagerPan>(
                                  _EagerPan.new,
                                  (pan) {
                                    pan.onUpdate = (details) {
                                      final camera = _map.camera;
                                      final next = camera.screenOffsetToLatLng(
                                        camera.latLngToScreenOffset(
                                              _points[i],
                                            ) +
                                            details.delta,
                                      );
                                      setState(() => _points[i] = next);
                                    };
                                  },
                                ),
                          },
                          child: const Center(
                            child: SizedBox(
                              width: 14,
                              height: 14,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: _outline,
                                  shape: BoxShape.circle,
                                  border: Border.fromBorderSide(
                                    BorderSide(color: Colors.white, width: 2),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SimpleAttributionWidget(
                  source: Text('OpenStreetMap contributors'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _points.isEmpty
                        ? 'Tap each corner, then drag to adjust'
                        : '${_points.length} corners',
                  ),
                ),
                TextButton(
                  onPressed: _points.isEmpty
                      ? null
                      : () => setState(() => _points.removeLast()),
                  child: const Text('Undo'),
                ),
                TextButton(
                  onPressed: _points.isEmpty
                      ? null
                      : () => setState(_points.clear),
                  child: const Text('Clear'),
                ),
                TextButton(
                  onPressed: () => _locate(),
                  child: const Text('My location'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Wins the gesture immediately so dragging a corner does not pan the map.
class _EagerPan extends PanGestureRecognizer {
  @override
  void addAllowedPointer(PointerDownEvent event) {
    super.addAllowedPointer(event);
    resolve(GestureDisposition.accepted);
  }
}
