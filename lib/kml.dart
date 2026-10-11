import 'dart:math' as math;

typedef GeoPoint = ({double lat, double lon});

String roomPolygonKml(String name, List<GeoPoint> points) {
  final ring = [
    for (final point in points) _coord(point),
    _coord(points.first),
  ].join(' ');
  return '''<?xml version="1.0" encoding="UTF-8"?>
<kml xmlns="http://www.opengis.net/kml/2.2">
  <Placemark>
    <name>${_xml(name)}</name>
    <Polygon>
      <outerBoundaryIs>
        <LinearRing>
          <coordinates>$ring</coordinates>
        </LinearRing>
      </outerBoundaryIs>
    </Polygon>
  </Placemark>
</kml>
''';
}

/// Rewrites [kml] so the placemark name matches [name]. Null when there is
/// no 3-corner outline.
String? roomKmlFor(String name, String? kml) {
  final points = parseRoomPolygonKml(kml);
  if (points.length < 3) return null;
  return roomPolygonKml(name.isEmpty ? 'Room' : name, points);
}

List<GeoPoint> parseRoomPolygonKml(String? kml) {
  if (kml == null || kml.isEmpty) return const [];
  final match = RegExp(r'<coordinates>\s*([^<]*?)\s*</coordinates>')
      .firstMatch(kml);
  if (match == null) return const [];
  final points = <GeoPoint>[];
  for (final token in match.group(1)!.split(RegExp(r'\s+'))) {
    if (token.isEmpty) continue;
    final parts = token.split(',');
    if (parts.length < 2) continue;
    final lon = double.tryParse(parts[0]);
    final lat = double.tryParse(parts[1]);
    if (lat == null || lon == null) continue;
    points.add((lat: lat, lon: lon));
  }
  if (points.length >= 2 &&
      (points.first.lat - points.last.lat).abs() < 1e-7 &&
      (points.first.lon - points.last.lon).abs() < 1e-7) {
    points.removeLast();
  }
  return points;
}

/// Nearest outline first. [meters] is null when the room has no 3-corner
/// outline; those stay at the end, in their original order.
List<({String name, String? kml, double? meters})> roomsByDistance(
  GeoPoint here,
  Iterable<({String name, String? kml})> rooms,
) {
  final near = <({String name, String? kml, double? meters})>[];
  final rest = <({String name, String? kml, double? meters})>[];
  for (final room in rooms) {
    final points = parseRoomPolygonKml(room.kml);
    if (points.length < 3) {
      rest.add((name: room.name, kml: room.kml, meters: null));
    } else {
      near.add((
        name: room.name,
        kml: room.kml,
        meters: _distanceToPolygon(here, points),
      ));
    }
  }
  near.sort((a, b) => a.meters!.compareTo(b.meters!));
  return [...near, ...rest];
}

double _distanceToPolygon(GeoPoint here, List<GeoPoint> ring) {
  if (_contains(here, ring)) return 0;
  var best = double.infinity;
  for (var i = 0; i < ring.length; i++) {
    final distance = _distanceToSegment(
      here,
      ring[i],
      ring[(i + 1) % ring.length],
    );
    if (distance < best) best = distance;
  }
  return best;
}

bool _contains(GeoPoint here, List<GeoPoint> ring) {
  var inside = false;
  for (var i = 0, j = ring.length - 1; i < ring.length; j = i++) {
    final a = ring[i];
    final b = ring[j];
    final crosses = (a.lat > here.lat) != (b.lat > here.lat);
    if (!crosses) continue;
    final lon = (b.lon - a.lon) * (here.lat - a.lat) / (b.lat - a.lat) + a.lon;
    if (here.lon < lon) inside = !inside;
  }
  return inside;
}

double _distanceToSegment(GeoPoint here, GeoPoint a, GeoPoint b) {
  final px = _east(here.lon, here.lat);
  final py = _north(here.lat);
  final ax = _east(a.lon, here.lat);
  final ay = _north(a.lat);
  final bx = _east(b.lon, here.lat);
  final by = _north(b.lat);
  final dx = bx - ax;
  final dy = by - ay;
  final length = dx * dx + dy * dy;
  final t = length == 0 ? 0.0 : ((px - ax) * dx + (py - ay) * dy) / length;
  final clamped = t.clamp(0.0, 1.0);
  final ex = px - (ax + clamped * dx);
  final ey = py - (ay + clamped * dy);
  return math.sqrt(ex * ex + ey * ey);
}

double _north(double lat) => lat * 111320;

double _east(double lon, double lat) =>
    lon * 111320 * math.cos(lat * math.pi / 180);

String _coord(GeoPoint point) =>
    '${point.lon.toStringAsFixed(7)},${point.lat.toStringAsFixed(7)},0';

String _xml(String value) => value
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');
