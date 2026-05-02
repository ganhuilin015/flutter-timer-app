import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timer/data/world_cities.dart';
import 'package:timer/providers/theme_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LocalTimeCard extends StatefulWidget {
  const LocalTimeCard({super.key});

  @override
  State<LocalTimeCard> createState() => _LocalTimeCardState();
}

class _LocalTimeCardState extends State<LocalTimeCard> {
  late DateTime _now;
  String _city = 'Loading...';

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();

    _loadLocation();

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;

      setState(() {
        _now = DateTime.now();
      });

      return true;
    });
  }

  String _fallbackCityFromTimezone() {
    final offset = _now.timeZoneOffset.inHours;

    try {
      final match = kWorldCities.firstWhere((c) {
        final cityNow = DateTime.now().toUtc().add(Duration(hours: offset));
        final cityOffset = cityNow.timeZoneOffset.inHours;

        return cityOffset == offset;
      });

      return match['city']!;
    } catch (_) {
      return 'Your Location';
    }
  }

  Future<void> _loadLocation() async {
    final prefs = await SharedPreferences.getInstance();

    final cachedCity = prefs.getString('cached_city');
    if (cachedCity != null) {
      setState(() {
        _city = cachedCity;
      });
      return;
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );

    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;

      final city = (place.locality != null && place.locality!.isNotEmpty)
          ? place.locality!
          : (place.subAdministrativeArea != null &&
                  place.subAdministrativeArea!.isNotEmpty)
              ? place.subAdministrativeArea!
              : (place.administrativeArea != null &&
                      place.administrativeArea!.isNotEmpty)
                  ? place.administrativeArea!
                  : _fallbackCityFromTimezone();

      setState(() {
        _city = city;
      });

      await prefs.setString('cached_city', city);
    } else {
      final fallback = _fallbackCityFromTimezone();

      setState(() {
        _city = fallback;
      });

      await prefs.setString('cached_city', fallback);
    }
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatDate(DateTime time) {
    return DateFormat('EEE, MMM d').format(time);
  }

  String _utcOffset(DateTime time) {
    final offset = time.timeZoneOffset;
    final hours = offset.inHours;
    final minutes = offset.inMinutes.remainder(60);

    final sign = hours >= 0 ? '+' : '-';

    if (minutes == 0) {
      return 'UTC$sign${hours.abs()}';
    }

    return 'UTC$sign${hours.abs()}:${minutes.abs().toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final color = context.watch<ThemeProvider>();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.secondary(context).withAlpha(100),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // LEFT SIDE
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'LOCAL TIME',
                style: TextStyle(
                  color: color.primary(context),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _city,
                style: TextStyle(
                  color: color.onSurface(context),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 6),


              Row (
                children: [
                  Text(
                    _utcOffset(_now),
                    style: TextStyle(
                      color: color.onSurface(context).withAlpha(150),
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Text(
                    _formatDate(_now),
                    style: TextStyle(
                      color: color.onSurface(context).withAlpha(150),
                      fontSize: 12,
                    ),
                  ),
                ],
              )
            ],
          ),

          Text(
            _formatTime(_now),
            style: TextStyle(
              color: color.onSurface(context),
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
