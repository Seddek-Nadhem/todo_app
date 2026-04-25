// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'مهامي';

  @override
  String get addTask => 'إضافة مهمة جديدة';

  @override
  String get editTask => 'تعديل';

  @override
  String get titleLabel => 'عنوان';

  @override
  String get descriptionLabel => 'تفاصيل';

  @override
  String get save => 'حفظ';

  @override
  String get emptyStateMessage => 'لقد أنجزت كل مهامك!';

  @override
  String get emptyStateSub => 'ليس لديك أي مهام حالياً. استمتع بوقتك!';

  @override
  String get titleRequiredError => 'العنوان مطلوب';
}
