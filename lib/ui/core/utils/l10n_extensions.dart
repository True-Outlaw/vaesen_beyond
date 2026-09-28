import 'package:flutter/widgets.dart';
import 'package:vaesen_beyond/domain/models/attribute_skill.dart';
import 'package:vaesen_beyond/domain/models/condition.dart';
import 'package:vaesen_beyond/l10n/app_localizations.dart';
export 'package:vaesen_beyond/l10n/app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations? get l10n => AppLocalizations.of(this);
}

extension AttributeLocalization on AttributeType {
  String localizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (this) {
      case AttributeType.physique:
        return l10n?.physique ?? label;
      case AttributeType.precision:
        return l10n?.precision ?? label;
      case AttributeType.logic:
        return l10n?.logic ?? label;
      case AttributeType.empathy:
        return l10n?.empathy ?? label;
    }
  }
}

extension SkillLocalization on SkillType {
  String localizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (this) {
      case SkillType.agility:
        return l10n?.agility ?? label;
      case SkillType.closeCombat:
        return l10n?.closeCombat ?? label;
      case SkillType.force:
        return l10n?.force ?? label;
      case SkillType.medicine:
        return l10n?.medicine ?? label;
      case SkillType.rangedCombat:
        return l10n?.rangedCombat ?? label;
      case SkillType.stealth:
        return l10n?.stealth ?? label;
      case SkillType.investigation:
        return l10n?.investigation ?? label;
      case SkillType.learning:
        return l10n?.learning ?? label;
      case SkillType.vigilance:
        return l10n?.vigilance ?? label;
      case SkillType.inspiration:
        return l10n?.inspiration ?? label;
      case SkillType.manipulation:
        return l10n?.manipulation ?? label;
      case SkillType.observation:
        return l10n?.observation ?? label;
    }
  }
}

extension PhysicalConditionLocalization on PhysicalCondition {
  String localizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (this) {
      case PhysicalCondition.exhausted:
        return l10n?.exhausted ?? label;
      case PhysicalCondition.battered:
        return l10n?.battered ?? label;
      case PhysicalCondition.wounded:
        return l10n?.wounded ?? label;
    }
  }
}

extension MentalConditionLocalization on MentalCondition {
  String localizedName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (this) {
      case MentalCondition.angry:
        return l10n?.angry ?? label;
      case MentalCondition.frightened:
        return l10n?.frightened ?? label;
      case MentalCondition.hopeless:
        return l10n?.hopeless ?? label;
    }
  }
}
