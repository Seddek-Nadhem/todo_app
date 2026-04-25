// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'My Tasks';

  @override
  String get addTask => 'Add New Task';

  @override
  String get editTask => 'Edit Task';

  @override
  String get titleLabel => 'Title';

  @override
  String get descriptionLabel => 'Description';

  @override
  String get save => 'Save Task';

  @override
  String get emptyStateMessage => 'All caught up!';

  @override
  String get emptyStateSub => 'You don\'t have any tasks right now.';

  @override
  String get titleRequiredError => 'Title is required';
}
