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

  Widget _body() {
    if (!_loaded) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Text(_error!));
    if (_rooms.isEmpty) return const Center(child: Text('No rooms'));
    return ListView.builder(
      itemCount: _rooms.length,
      itemBuilder: (context, index) {
        final name = _rooms[index];
        return ListTile(
          title: Text(name),
          trailing: widget.canEdit
              ? TextButton(onPressed: () {}, child: const Text('Edit'))
              : null,
        );
      },
    );
  }
}
