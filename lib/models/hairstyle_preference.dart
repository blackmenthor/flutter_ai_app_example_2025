enum HairLength {
  veryShort,
  short,
  medium,
  long,
  veryLong,
}

enum StyleType {
  fade,
  undercut,
  buzzCut,
  crewCut,
  pompadour,
  quiff,
  slickedBack,
  textured,
  curlyWavy,
  naturalMessy,
}

class HairstylePreference {
  HairLength? length;
  List<StyleType> selectedStyles;
  List<String> additionalPreferences;
  String? customRequest;

  HairstylePreference({
    this.length,
    this.selectedStyles = const [],
    this.additionalPreferences = const [],
    this.customRequest,
  });
}
