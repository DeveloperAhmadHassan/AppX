import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/country.dart';

class SelectCountryPage extends StatefulWidget {
  const SelectCountryPage({super.key});

  @override
  _SelectCountryPageState createState() => _SelectCountryPageState();
}

class _SelectCountryPageState extends State<SelectCountryPage> {
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _headerKeys = {};

  void scrollToLetter(String letter) {
    final key = _headerKeys[letter];
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Country>>(
        future: loadCountriesFromAssets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Failed to load countries"));
          }

          final grouped = groupCountriesByAlphabet(snapshot.data!);
          final letters = grouped.keys.toList()..sort();
          final items = <Widget>[];
          _headerKeys.clear();

          grouped.forEach((letter, countries) {
            _headerKeys[letter] = GlobalKey();
            items.add(
              Padding(
                key: _headerKeys[letter],
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Text(
                  letter,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );

            for (var country in countries) {
              items.add(
                Column(
                  children: [
                    ListTile(
                      leading: Image.network(
                        country.flagUrl ?? "https://example.com/fallback-flag.png",
                        width: 40,
                        errorBuilder: (_, __, ___) => const Icon(Icons.flag),
                      ),
                      title: Text(country.name),
                      trailing: Text(
                        '${country.telephonyCode}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.withOpacity(0.8),
                        ),
                      ),
                      onTap: () {},
                    ),
                    const Divider(
                      indent: 16,
                      endIndent: 16,
                      height: 1,
                      thickness: 1.2,
                    ),
                  ],
                ),
              );
            }
          });

          return Stack(
            children: [
              Positioned(
                top: MediaQuery.of(context).size.height / 3.5,
                right: 0,
                child: Column(
                  children: letters.map((letter) => InkWell(
                    onTap: () => scrollToLetter(letter),
                    child: Text(
                      letter,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  )).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: ListView(
                  controller: _scrollController,
                  children: items,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Future<List<Country>> loadCountriesFromAssets() async {
  final String jsonString = await rootBundle.loadString('assets/files/country_codes.json');
  final List<dynamic> jsonData = json.decode(jsonString);
  List<Country> countries = jsonData.map((item) => Country.fromJson(item)).toList();
  countries.sort((a, b) => a.name.compareTo(b.name));
  return countries;
}

Map<String, List<Country>> groupCountriesByAlphabet(List<Country> countries) {
  Map<String, List<Country>> grouped = {};

  for (var country in countries) {
    String firstLetter = country.name[0].toUpperCase();
    grouped.putIfAbsent(firstLetter, () => []).add(country);
  }

  for (var group in grouped.values) {
    group.sort((a, b) => a.name.compareTo(b.name));
  }

  return Map.fromEntries(grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
}