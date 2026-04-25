import 'package:flutter/material.dart';
import 'package:todo_app/l10n/app_localizations.dart';

extension LocalizedContext on BuildContext {
  // This lets us call context.l10n.appTitle anywhere!
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}