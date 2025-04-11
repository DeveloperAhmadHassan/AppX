import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/country.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';


class SelectCountryPage extends StatefulWidget {
  const SelectCountryPage({super.key});

  @override
  _SelectCountryPageState createState() => _SelectCountryPageState();
}

class _SelectCountryPageState extends State<SelectCountryPage> {
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener = ItemPositionsListener.create();
  final Map<String, int> _letterIndexMap = {};

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
          _letterIndexMap.clear();

          int currentIndex = 0;
          grouped.forEach((letter, countries) {
            _letterIndexMap[letter] = currentIndex;
            items.add(
              Padding(
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
            currentIndex++;

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
              currentIndex++;
            }
          });

          void scrollToLetter(String letter) {
            final index = _letterIndexMap[letter];
            if (index != null) {
              _itemScrollController.scrollTo(
                index: index,
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
              );
            } else {
              print("Index not found for $letter");
            }
          }

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
                child: ScrollablePositionedList.builder(
                  itemScrollController: _itemScrollController,
                  itemPositionsListener: _itemPositionsListener,
                  itemCount: items.length,
                  itemBuilder: (context, index) => items[index],
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