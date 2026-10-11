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

String _coord(GeoPoint point) =>
    '${point.lon.toStringAsFixed(7)},${point.lat.toStringAsFixed(7)},0';

String _xml(String value) => value
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');
