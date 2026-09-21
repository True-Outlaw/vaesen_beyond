import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vaesen_beyond/ui/core/theme/app_colors.dart';
import 'package:vaesen_beyond/ui/core/theme/app_theme.dart';
import 'package:vaesen_beyond/ui/core/theme/app_typography.dart';
import 'package:vaesen_beyond/ui/features/builder/views/character_builder_screen.dart';
import 'package:vaesen_beyond/ui/features/compendium/views/compendium_screen.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/dice_roller_view_model.dart';
import 'package:vaesen_beyond/ui/features/play/view_models/play_view_model.dart';
import 'package:flutter/services.dart';
import 'package:vaesen_beyond/ui/features/play/views/play_screen.dart';
import 'package:vaesen_beyond/ui/features/play/views/widgets/party_management_dialog.dart';

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
        ChangeNotifierProvider(create: (_) => PlayViewModel()..initialize()),
        ChangeNotifierProvider(create: (_) => DiceRollerViewModel()),
      ],
      child: MaterialApp(
        title: 'Vaesen: The Society Companion',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const MainNavigationScreen(),
      ),
    );
  }
}

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final playVm = context.watch<PlayViewModel>();
    final diceVm = context.watch<DiceRollerViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.shield, color: AppColors.goldBright, size: 20),
            const SizedBox(width: 8),
            Text('VAESEN BEYOND', style: AppTypography.titleLarge),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_book, color: AppColors.gold),
            tooltip: 'The Society Compendium',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CompendiumScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.gold),
            tooltip: 'Start New Mystery (Reset Solace)',
            onPressed: () async {
              await playVm.resetMystery();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('A new mystery begins. Memento solace has been restored.'),
                    backgroundColor: AppColors.surfaceOverlay,
                  ),
                );
              }
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.gold),
            color: AppColors.surface,
            onSelected: (val) {
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
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'roster',
                child: Row(
                  children: [
                    const Icon(Icons.groups_outlined, size: 16, color: AppColors.goldBright),
                    const SizedBox(width: 8),
                    Text('Society Roster & Party', style: AppTypography.titleSmall),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'new_char',
                child: Row(
                  children: [
                    const Icon(Icons.person_add, size: 16, color: AppColors.goldBright),
                    const SizedBox(width: 8),
                    Text('Create New Investigator', style: AppTypography.titleSmall),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    const Icon(Icons.file_upload_outlined, size: 16, color: AppColors.gold),
                    const SizedBox(width: 8),
                    Text('Export Active (JSON)', style: AppTypography.titleSmall),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'import',
                child: Row(
                  children: [
                    const Icon(Icons.file_download_outlined, size: 16, color: AppColors.gold),
                    const SizedBox(width: 8),
                    Text('Import Investigator (JSON)', style: AppTypography.titleSmall),
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
}
