import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';

import '../../../helpers/awsom_notficationa_helper.dart';
import '../../../common_widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _alarms = [];
  String? _formattedAddress;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
    _loadAlarms();
    AwesomeNotificationHelper.initialize(context);
    _rescheduleAlarms();
  }

  Future<void> _initializeLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _formattedAddress = 'Location services are disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _formattedAddress = 'Location permission denied.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => _formattedAddress = 'Location permission permanently denied.');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _convertLatLngToAddress(position.latitude, position.longitude);
    } catch (e) {
      setState(() => _formattedAddress = 'Error getting location: $e');
    }
  }

  Future<void> _convertLatLngToAddress(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        final address = [
          place.street,
          place.locality,
          place.administrativeArea,
          place.country
        ].where((e) => e != null && e.isNotEmpty).join(', ');

        setState(() => _formattedAddress = address.isNotEmpty ? address : 'Address not found');
      } else {
        setState(() => _formattedAddress = 'No address found');
      }
    } catch (e) {
      setState(() => _formattedAddress = 'Failed to convert location: $e');
    }
  }

  Future<void> _loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmsJson = prefs.getString('alarms');
    if (alarmsJson != null) {
      setState(() {
        _alarms = List<Map<String, dynamic>>.from(
          jsonDecode(alarmsJson).map((alarm) => {
            'time': DateTime.parse(alarm['time']),
            'enabled': alarm['enabled'],
          }),
        );
      });
    }
  }

  // Future<void> _saveAlarms() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final alarmsJson = jsonEncode(_alarms);
  //   await prefs.setString('alarms', alarmsJson);
  // }

  Future<void> _saveAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedAlarms = _alarms.map((alarm) {
      return {
        'time': (alarm['time'] as DateTime).toIso8601String(),
        'enabled': alarm['enabled'],
      };
    }).toList();
    final alarmsJson = jsonEncode(encodedAlarms);
    await prefs.setString('alarms', alarmsJson);
  }


  Future<void> _addAlarm() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final now = DateTime.now();
      final alarmTime = DateTime(
        now.year,
        now.month,
        now.day,
        pickedTime.hour,
        pickedTime.minute,
      );

      setState(() {
        _alarms.add({
          'time': alarmTime,
          'enabled': true,
        });
      });

      await _saveAlarms();
      if (_alarms.last['enabled']) {
        await AwesomeNotificationHelper.scheduleAlarmNotification(
          id: _alarms.length - 1,
          dateTime: alarmTime,
        );
      }
    }
  }

  Future<void> _toggleAlarm(int index, bool value) async {
    setState(() => _alarms[index]['enabled'] = value);
    await _saveAlarms();
    if (value) {
      await AwesomeNotificationHelper.scheduleAlarmNotification(
        id: index,
        dateTime: _alarms[index]['time'],
      );
    } else {
      await AwesomeNotificationHelper.cancelAlarm(index);
    }
  }

  Future<void> _deleteAlarm(int index) async {
    setState(() => _alarms.removeAt(index));
    await _saveAlarms();
    await AwesomeNotificationHelper.cancelAlarm(index);
  }

  Future<void> _rescheduleAlarms() async {
    for (var i = 0; i < _alarms.length; i++) {
      if (_alarms[i]['enabled']) {
        await AwesomeNotificationHelper.scheduleAlarmNotification(
          id: i,
          dateTime: _alarms[i]['time'],
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D1B20),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              const Padding(
                padding: EdgeInsets.only(top: 0, bottom: 15, left: 20, right: 20),
                child: Text(
                  'Selected Location',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              if (_formattedAddress != null)
                Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 0, left: 25, right: 20),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.white70, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _formattedAddress!,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              CustomButton(
                onPressed: _addAlarm,
                label: 'Add Alarm',
                backgroundColor: const Color(0xFFAB47BC),
              ),
              const SizedBox(height: 16),
              const Text(
                'Alarms',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _alarms.isEmpty
                    ? const Center(
                  child: Text('No alarms set yet.', style: TextStyle(color: Colors.white70)),
                )
                    : ListView.builder(
                  itemCount: _alarms.length,
                  itemBuilder: (context, index) {
                    final alarm = _alarms[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        title: Text(
                          DateFormat.jm().format(alarm['time']),
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          DateFormat('EEE dd MMM yyyy').format(alarm['time']),
                          style: const TextStyle(color: Colors.white70),
                        ),
                        trailing: Switch(
                          value: alarm['enabled'],
                          onChanged: (value) => _toggleAlarm(index, value),
                          activeColor: const Color(0xFFAB47BC),
                        ),
                        onLongPress: () => _deleteAlarm(index),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
