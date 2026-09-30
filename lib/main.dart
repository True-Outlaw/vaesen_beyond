import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_theme.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/features/builder/views/character_builder_screen.dart';
import 'package:vaesen_beyond/ui/features/compendium/views/compendium_screen.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/dice_roller_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/initiative_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';
import 'package:flutter/services.dart';
import 'package:vaesen_beyond/ui/core/utils/responsive.dart';
import 'package:vaesen_beyond/ui/features/castle/views/castle_screen.dart';
import 'package:vaesen_beyond/ui/features/play/views/play_screen.dart';
import 'package:vaesen_beyond/l10n/app_localizations.dart';
import 'package:vaesen_beyond/ui/core/view_models/settings_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/party_management_dialog.dart';
import 'package:vaesen_beyond/ui/core/widgets/legal_disclaimer_dialog.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VaesenBeyondApp());
}

class VaesenBeyondApp extends StatelessWidget {
  const VaesenBeyondApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsViewModel()..initialize()),
        ChangeNotifierProvider(create: (_) => PlayViewModel()..initialize()),
        ChangeNotifierProvider(create: (_) => DiceRollerViewModel()),
        ChangeNotifierProvider(create: (_) => InitiativeViewModel()),
      ],
      child: Consumer<SettingsViewModel>(
        builder: (context, settingsVm, _) {
          return MaterialApp(
            title: 'Vaesen: The Society Companion',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.theme,
            locale: settingsVm.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const MainNavigationScreen(),
          );
        },
      ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  bool _checkedDisclaimer = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkDisclaimer();
    });
  }

  Future<void> _checkDisclaimer() async {
    if (_checkedDisclaimer || !mounted) return;
    _checkedDisclaimer = true;

    final playVm = context.read<PlayViewModel>();
    final hasAccepted = await playVm.hasAcceptedDisclaimer();
    if (!hasAccepted && mounted) {
      showLegalDisclaimerDialog(
        context,
        onAcknowledge: () async {
          await playVm.setDisclaimerAccepted(true);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final playVm = context.watch<PlayViewModel>();
    final diceVm = context.watch<DiceRollerViewModel>();
    final isWide = Responsive.isWide(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.shield, color: AppColors.goldBright, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                l10n?.appTitle ?? 'VAESEN BEYOND',
                style: AppTypography.titleLarge.copyWith(fontSize: 14),
              ),
            ),
          ],
        ),
        actions: [
          if (isWide)
            IconButton(
              icon: const Icon(Icons.castle_outlined, color: AppColors.gold),
              tooltip: l10n?.castleTooltip ?? 'Castle Gyllencreutz Headquarters',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Scaffold(
                    appBar: AppBar(
                      title: Row(
                        children: [
                          const Icon(Icons.castle, color: AppColors.goldBright, size: 20),
                          const SizedBox(width: 8),
                          Text(l10n?.castleTitle ?? 'CASTLE GYLLENCREUTZ', style: AppTypography.titleLarge),
                        ],
                      ),
                    ),
                    body: CastleScreen(viewModel: playVm),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu_book, color: AppColors.gold),
            tooltip: l10n?.compendiumTooltip ?? 'The Society Compendium',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CompendiumScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.gold),
            tooltip: l10n?.startNewMysteryTooltip ?? 'Start New Mystery (Reset Solace)',
            onPressed: () async {
              await playVm.resetMystery();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n?.newMysteryStarted ?? 'A new mystery begins. Memento solace has been restored.'),
                    backgroundColor: AppColors.surfaceOverlay,
                  ),
                );
              }
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.gold),
            color: AppColors.surface,
            onSelected: (val) async {
              if (val == 'roster') {
                showPartyManagementDialog(context, playVm);
              } else if (val == 'new_char') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CharacterBuilderScreen(
                      playViewModel: playVm,
                      onFinished: () => Navigator.pop(context),
                    ),
                  ),
                );
              } else if (val == 'export') {
                final jsonStr = playVm.exportCharacterJson();
                if (jsonStr != null) {
                  Clipboard.setData(ClipboardData(text: jsonStr));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: AppColors.gold),
                      ),
                      content: Text(
                        '${playVm.activeCharacter?.name ?? "Investigator"} exported! JSON copied to clipboard.',
                        style: const TextStyle(color: AppColors.goldBright, fontSize: 12),
                      ),
                    ),
                  );
                }
              } else if (val == 'import') {
                showPartyManagementDialog(context, playVm);
              } else if (val == 'language') {
                _showLanguageDialog(context);
              } else if (val == 'legal') {
                showLegalDisclaimerDialog(
                  context,
                  onAcknowledge: () async {
                    await playVm.setDisclaimerAccepted(true);
                  },
                );
              } else if (val == 'gm_mode') {
                final nextState = !playVm.isBestiaryEnabled;
                await playVm.setBestiaryEnabled(nextState);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: AppColors.gold),
                      ),
                      content: Text(
                        nextState
                            ? 'Gamemaster Mode enabled: Society Bestiary unlocked.'
                            : 'Gamemaster Mode disabled: Bestiary locked (spoiler protection active).',
                        style: const TextStyle(color: AppColors.goldBright, fontSize: 12),
                      ),
                    ),
                  );
                }
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'roster',
                child: Row(
                  children: [
                    const Icon(Icons.groups_outlined, size: 16, color: AppColors.goldBright),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(l10n?.rosterAndParty ?? 'Society Roster & Party', style: AppTypography.titleSmall),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'new_char',
                child: Row(
                  children: [
                    const Icon(Icons.person_add, size: 16, color: AppColors.goldBright),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(l10n?.createNewInvestigator ?? 'Create New Investigator', style: AppTypography.titleSmall),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    const Icon(Icons.file_upload_outlined, size: 16, color: AppColors.gold),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(l10n?.exportActiveJson ?? 'Export Active (JSON)', style: AppTypography.titleSmall),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'import',
                child: Row(
                  children: [
                    const Icon(Icons.file_download_outlined, size: 16, color: AppColors.gold),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(l10n?.importInvestigatorJson ?? 'Import Investigator (JSON)', style: AppTypography.titleSmall),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'gm_mode',
                child: Row(
                  children: [
                    Icon(
                      playVm.isBestiaryEnabled ? Icons.lock_open : Icons.lock_outline,
                      size: 16,
                      color: playVm.isBestiaryEnabled ? AppColors.goldBright : AppColors.crimsonLight,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n?.gmBestiary(playVm.isBestiaryEnabled ? (l10n.unlocked) : (l10n.locked)) ??
                            'GM Bestiary: ${playVm.isBestiaryEnabled ? "Unlocked" : "Locked"}',
                        style: AppTypography.titleSmall,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'language',
                child: Row(
                  children: [
                    const Icon(Icons.language, size: 16, color: AppColors.goldBright),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n?.language ?? 'Language',
                        style: AppTypography.titleSmall,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'legal',
                child: Row(
                  children: [
                    const Icon(Icons.gavel_outlined, size: 16, color: AppColors.gold),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n?.legalNotice ?? 'Legal & Copyright Notice',
                        style: AppTypography.titleSmall,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: PlayScreen(viewModel: playVm, diceViewModel: diceVm),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final settingsVm = context.read<SettingsViewModel>();
    final l10n = AppLocalizations.of(context);
    final currentCode = settingsVm.locale?.languageCode ?? 'en';

    showDialog(
      context: context,
      builder: (dialogCtx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.gold, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(200),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.translate, color: AppColors.goldBright, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    l10n?.selectLanguage ?? 'Select Language',
                    style: AppTypography.titleMedium.copyWith(color: AppColors.goldBright),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: currentCode == 'en' ? AppColors.gold : AppColors.surfaceLight,
                  ),
                ),
                tileColor: currentCode == 'en' ? AppColors.surfaceLight : Colors.transparent,
                leading: const Text('🇬🇧', style: TextStyle(fontSize: 20)),
                title: Text(
                  l10n?.english ?? 'English',
                  style: TextStyle(
                    color: currentCode == 'en' ? AppColors.goldBright : AppColors.textPrimary,
                    fontWeight: currentCode == 'en' ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing: currentCode == 'en'
                    ? const Icon(Icons.check, color: AppColors.goldBright, size: 18)
                    : null,
                onTap: () {
                  settingsVm.setLocale(const Locale('en'));
                  Navigator.pop(dialogCtx);
                },
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: Text(AppLocalizations.of(dialogCtx)?.close ?? 'CLOSE', style: const TextStyle(color: AppColors.goldDim)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
