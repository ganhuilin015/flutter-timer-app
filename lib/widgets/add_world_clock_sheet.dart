import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timer/models/world_clock_entry.dart';
import 'package:timer/providers/theme_provider.dart';
import 'package:timer/providers/world_clock_provider.dart';
import 'package:uuid/uuid.dart';
import 'color_utils.dart';
import 'package:timer/data/world_cities.dart';

class AddWorldClockSheet extends StatefulWidget {
  const AddWorldClockSheet({super.key});

  @override
  State<AddWorldClockSheet> createState() => _AddWorldClockSheetState();
}

class _AddWorldClockSheetState extends State<AddWorldClockSheet> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  final Map<String, String> _selectedColors = {}; // key -> color
  final Map<String, Map<String, String>> _selectedCities = {}; // key -> city
  String? _activeCityKey;

  String _makeKey(Map<String, String> city) =>
      '${city['city']}_${city['country']}';

  List<Map<String, String>> get _filtered {
    final provider = context.read<WorldClockProvider>();

    final existingKeys = provider.clocks
        .map((c) => '${c.cityName}_${c.countryName}')
        .toSet();

    final q = _query.toLowerCase();

    return kWorldCities.where((c) {
      final key = _makeKey(c);

      final matchesSearch = _query.isEmpty ||
          c['city']!.toLowerCase().contains(q) ||
          c['country']!.toLowerCase().contains(q);

      final notAlreadyAdded = !existingKeys.contains(key);

      return matchesSearch && notAlreadyAdded;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
  }

  void _toggleCity(Map<String, String> city) {
    final key = _makeKey(city);

    setState(() {
      if (_selectedCities.containsKey(key)) {
        _selectedCities.remove(key);
        _selectedColors.remove(key);
        if (_activeCityKey == key) _activeCityKey = null;
      } else {
        _selectedCities[key] = city;

        _selectedColors[key] =
            kPaletteColors[_selectedCities.length % kPaletteColors.length];

        _activeCityKey = key;
      }

      _updateActiveCity();
    });
  }

  void _updateActiveCity() {
    if (_selectedCities.isEmpty) {
      _activeCityKey = null;
      return;
    }

    if (_activeCityKey != null &&
        _selectedCities.containsKey(_activeCityKey)) {
      return;
    }

    _activeCityKey = _selectedCities.keys.last;
  }

  void _addAll() {
    if (_selectedCities.isEmpty) return;

    final provider = context.read<WorldClockProvider>();

    for (final entry in _selectedCities.entries) {
      final city = entry.value;

      provider.addClock(
        WorldClock(
          id: const Uuid().v4(),
          cityName: city['city']!,
          countryName: city['country']!,
          timeZoneName: city['timezone']!,
          color: _selectedColors[entry.key] ?? kPaletteColors[0],
        ),
      );
    }

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.watch<ThemeProvider>();

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: color.surface(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: color.outline(context),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add City',
                      style: TextStyle(
                        color: color.primary(context),
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _query = v),
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search city or country...',
                    prefixIcon: Icon(Icons.search_rounded),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _filtered.length,
              itemBuilder: (context, i) {
                final city = _filtered[i];
                final key = _makeKey(city);

                final isSelected = _selectedCities.containsKey(key);
                final isActive = _activeCityKey == key;

                return ListTile(
                  onTap: () => _toggleCity(city),
                  onLongPress: isSelected
                      ? () => setState(() => _activeCityKey = key)
                      : null,
                  tileColor: isActive ? color.primary(context) : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),

                  leading: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? color.primary(context) : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? color.primary(context)
                            : color.onSurface(context),
                        width: 2,
                      ),
                    ),
                  ),

                  title: Text(
                    city['city']!,
                    style: TextStyle(
                      color: isSelected
                          ? color.primary(context)
                          : color.onSurface(context),
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),

                  subtitle: Text(
                    city['country']!,
                    style: TextStyle(
                      color: color.onSurface(context).withAlpha(150),
                      fontSize: 12,
                    ),
                  ),

                  trailing: isSelected
                      ? Icon(Icons.check_circle,
                          color: color.primary(context), size: 20)
                      : null,

                );
              },
            ),
          ),

          const SizedBox(height: 24),

          Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).viewInsets.bottom + 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addAll,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color.primary(context),
                  foregroundColor: color.onPrimary(context),
                ),
                child: Text(
                  _selectedCities.length == 1
                      ? 'Add ${_selectedCities.values.first['city']}'
                      : 'Add ${_selectedCities.length} Cities',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}