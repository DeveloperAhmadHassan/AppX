import 'package:country_codes/country_codes.dart';

Future<String> getCountryName() async {
  final CountryDetails details = CountryCodes.detailsForLocale();
  return details.name ?? "Unknown";
}