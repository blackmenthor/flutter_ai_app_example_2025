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
    List<StyleType>? selectedStyles,
    List<String>? additionalPreferences,
    this.customRequest,
  }) : selectedStyles = selectedStyles ?? [],
       additionalPreferences = additionalPreferences ?? [];
}
