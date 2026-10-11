import 'package:flutter/material.dart';
import 'package:strathclean/models/roles.dart';
import 'package:strathclean/models/user.dart';
import 'package:strathclean/services/clean_service.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key, required this.user, required this.cleanService});

  final User user;
  final CleanService cleanService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Strath Clean'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Hello, ${user.username}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                  if (user.role == Role.cleaner) ...[
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        '/log-clean',
                        arguments: user,
                      ),
                      child: const Text('Log cleans'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        '/log-issue',
                        arguments: user,
                      ),
                      child: const Text('Log issue'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        '/rooms',
                        arguments: user,
                      ),
                      child: const Text('View rooms'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        '/issues',
                        arguments: user,
                      ),
                      child: const Text('View issues'),
                    ),
                  ],
                  if (user.role == Role.supervisor) ...[
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        '/manage-rooms',
                        arguments: user,
                      ),
                      child: const Text('Manage rooms'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        '/manage-issues',
                        arguments: user,
                      ),
                      child: const Text('Manage issues'),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        '/log-issue',
                        arguments: user,
                      ),
                      child: const Text('Log issue'),
                    ),
                    const SizedBox(height: 12),
                    _BeginAudit(user: user, cleanService: cleanService),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(
                        context,
                        '/add-room',
                        arguments: user,
                      ),
                      child: const Text('Add new room'),
                    ),
                  ],
                ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BeginAudit extends StatefulWidget {
  const _BeginAudit({required this.user, required this.cleanService});

  final User user;
  final CleanService cleanService;

  @override
  State<_BeginAudit> createState() => _BeginAuditState();
}

class _BeginAuditState extends State<_BeginAudit> {
  var _started = false;
  var _loading = false;
  String? _error;
  List<({String room, String cleaner, DateTime cleanTime, String? issues})>
      _rooms = [];

  Future<void> _load() async {
    setState(() {
      _started = true;
      _loading = true;
    });
    try {
      final rooms = await widget.cleanService.pendingAudits();
      if (!mounted) return;
      setState(() {
        _rooms = rooms;
        _error = null;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString();
        _loading = false;
      });
    }
  }

  String _when(DateTime time) {
    final day = time.day.toString().padLeft(2, '0');
    final month = time.month.toString().padLeft(2, '0');
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$day/$month/${time.year} $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: _load,
          child: const Text('Begin audit'),
        ),
        if (_started) ...[
          const SizedBox(height: 12),
          if (_loading)
            const CircularProgressIndicator()
          else if (_error != null)
            Text(_error!)
          else if (_rooms.isEmpty)
            const Text('No rooms to audit')
          else
            for (final room in _rooms)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  '${room.room}\n'
                  'Cleaned by ${room.cleaner}\n'
                  'Last cleaned ${_when(room.cleanTime)}'
                  '${room.issues == null || room.issues!.isEmpty ? '' : '\nIssues: ${room.issues}'}',
                  textAlign: TextAlign.center,
                ),
              ),
        ],
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () async {
            await Navigator.pushNamed(
              context,
              '/audit',
              arguments: widget.user,
            );
            if (_started) _load();
          },
          child: const Text('Audit'),
        ),
      ],
    );
  }
}