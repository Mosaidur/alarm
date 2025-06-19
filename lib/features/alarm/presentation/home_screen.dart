import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../helpers/notification_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../common_widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _alarms = [];
  final NotificationHelper _notificationHelper = NotificationHelper();

  @override
  void initState() {
    super.initState();
    _notificationHelper.initializeNotifications(context).then((granted) {
      if (!granted && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notifications are disabled. Alarms may not work.'),
          ),
        );
      }
    });
    _loadAlarms();
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

  Future<void> _saveAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmsJson = jsonEncode(_alarms);
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
        await _notificationHelper.scheduleNotification(alarmTime, _alarms.length - 1);
      }
    }
  }

  void _toggleAlarm(int index, bool value) async {
    setState(() {
      _alarms[index]['enabled'] = value;
    });
    await _saveAlarms();
    if (value) {
      await _notificationHelper.scheduleNotification(_alarms[index]['time'], index);
    } else {
      await _notificationHelper.cancelNotification(index);
    }
  }

  void _deleteAlarm(int index) async {
    setState(() {
      _alarms.removeAt(index);
    });
    await _saveAlarms();
    await _notificationHelper.cancelNotification(index);
  }

  @override
  Widget build(BuildContext context) {
    final location = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      backgroundColor: const Color(0xFF1D1B20), // Dark background
      appBar: AppBar(
        backgroundColor: const Color(0xFF1D1B20),
        elevation: 0,
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (location != null)
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.white70, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Selected Location: $location',
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              CustomButton(
                onPressed: _addAlarm,
                label: 'Add Alarm',
                backgroundColor: const Color(0xFFAB47BC), // Purple accent
              ),
              const SizedBox(height: 16),
              const Text(
                'Alarms',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: _alarms.isEmpty
                    ? const Center(
                  child: Text(
                    'No alarms set yet.',
                    style: TextStyle(color: Colors.white70),
                  ),
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