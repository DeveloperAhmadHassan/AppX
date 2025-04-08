class Country {
  final String name;
  final String? flagUrl;
  final String? telephonyCode;
  final Map<String, dynamic>? countryCodes;

  Country({
    required this.name,
    required this.flagUrl,
    required this.telephonyCode,
    this.countryCodes,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['country_name'],
      flagUrl: json['flag_url'],
      telephonyCode: json['telephony_code'],
      countryCodes: json['country_codes'],
    );
  }
}
