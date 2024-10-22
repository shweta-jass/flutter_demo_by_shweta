// ignore_for_file: use_build_context_synchronously
import 'dart:developer';

import 'package:demo_project/bloc/data_bloc.dart';
import 'package:demo_project/bloc/data_event.dart';
import 'package:demo_project/bloc/data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

// Logout on icon press
  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // Set login state to false
    Navigator.pushReplacementNamed(
        context, '/login'); // Navigate back to login screen
    log('Logout successful');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home.'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context), // Logout on icon press
          ),
        ],
      ),
      // Display data from API
      body: BlocProvider(
        create: (context) => DataBloc()..add(FetchData()),
        child: BlocBuilder<DataBloc, DataState>(
          builder: (context, state) {
            if (state is DataLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DataLoaded) {
              return ListView.builder(
                itemCount: state.data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(state.data[index]['name'] + "."),
                    subtitle: Text(state.data[index]['data'] != null &&
                            state.data[index]['data']['color'] != null
                        ? state.data[index]['data']['color']
                        : "Not available!"),
                  );
                },
              );
            } else {
              return const Center(child: Text('Error loading data'));
            }
          },
        ),
      ),
    );
  }
}
