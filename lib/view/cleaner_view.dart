import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strathclean/models/user.dart';

// import 'package:strathclean/viewmodel/login_view_model.dart';

class CleanerView extends StatefulWidget {
  // For the time being don't have this viewModel thing
  // const CleanerView({super.key, required this.viewModel});
  // final LoginViewModel viewModel;
  const CleanerView({super.key, this.user});

  final User? user;

  @override
  State<StatefulWidget> createState() => _CleanerViewState();
}

class _CleanerViewState extends State<CleanerView> {
  User? user;

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final String? userSerialized = sp.getString('user');
    user = userSerialized == null
      ? null
      : User.fromJson(jsonDecode(userSerialized));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cleaner'),
        backgroundColor: const Color.fromARGB(255, 19, 8, 68),
        foregroundColor: Colors.white,
      ),
      body: user == null
        ? Text("woops")
        : Text("username: ${user?.username ?? ""}")
    );
  }
}
