abstract class LocalizationState {}

class LocalizationLoaded extends LocalizationState {
  final Map<String, String> localizedStrings;

  LocalizationLoaded(this.localizedStrings);
}

class LocalizationInitial extends LocalizationState {}
