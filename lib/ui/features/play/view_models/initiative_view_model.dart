import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:vaesen_beyond/domain/models/character.dart';
import 'package:vaesen_beyond/domain/models/initiative_combatant.dart';

/// Manages the 10-slot tactile initiative card rack for Vaesen combat.
/// In Vaesen, participants draw cards numbered 1–10. The lowest card acts first.
/// Investigators can swap cards (e.g. using Fast reflexes or coordination).
class InitiativeViewModel extends ChangeNotifier {
  int _round = 1;
  int? _currentTurnCard;
  final List<InitiativeCombatant> _combatants = [];
  String? _selectedCombatantIdForSwap;
  bool _isCombatActive = false;

  int get round => _round;
  int? get currentTurnCard => _currentTurnCard;
  List<InitiativeCombatant> get combatants => List.unmodifiable(_combatants);
  String? get selectedCombatantIdForSwap => _selectedCombatantIdForSwap;
  bool get isCombatActive => _isCombatActive;

  /// Returns sorted combatants in order of turn priority (card 1 through 10).
  List<InitiativeCombatant> get turnOrder {
    final list = List<InitiativeCombatant>.from(_combatants);
    list.sort((a, b) => a.cardNumber.compareTo(b.cardNumber));
    return list;
  }

  /// Combatant currently on turn, if any.
  InitiativeCombatant? get activeTurnCombatant {
    if (_currentTurnCard == null) return null;
    try {
      return _combatants.firstWhere((c) => c.cardNumber == _currentTurnCard);
    } catch (_) {
      return null;
    }
  }

  /// True if all participants in the initiative order have acted this round.
  bool get allHaveActed =>
      _combatants.isNotEmpty && _combatants.every((c) => c.hasActed);

  /// Initializes or resets the initiative rack with the current society party.
  void initializeFromParty(List<Character> party, {List<String>? adversaries}) {
    _combatants.clear();
    _round = 1;
    _selectedCombatantIdForSwap = null;
    _isCombatActive = true;

    final deck = List<int>.generate(10, (i) => i + 1)..shuffle(Random());
    var cardIndex = 0;

    // Add player party investigators
    for (final char in party) {
      if (cardIndex >= 10) break;
      _combatants.add(
        InitiativeCombatant(
          id: 'investigator_${char.id}',
          name: char.name,
          cardNumber: deck[cardIndex++],
          isInvestigator: true,
          characterId: char.id,
          hasActed: false,
          archetypeOrType: char.archetypeName,
          portraitAsset: char.effectivePortraitAsset,
        ),
      );
    }

    // Add any initial adversaries
    if (adversaries != null) {
      for (final advName in adversaries) {
        if (cardIndex >= 10) break;
        _combatants.add(
          InitiativeCombatant(
            id: 'adversary_${DateTime.now().microsecondsSinceEpoch}_$cardIndex',
            name: advName,
            cardNumber: deck[cardIndex++],
            isInvestigator: false,
            hasActed: false,
            archetypeOrType: 'Adversary',
          ),
        );
      }
    }

    _sortCombatants();
    _currentTurnCard = turnOrder.isNotEmpty ? turnOrder.first.cardNumber : null;
    notifyListeners();
  }

  /// Re-deals unique 1–10 cards to all combatants (start of new round or redraw).
  void drawInitiative() {
    if (_combatants.isEmpty) return;

    final deck = List<int>.generate(10, (i) => i + 1)..shuffle(Random());
    for (var i = 0; i < _combatants.length; i++) {
      _combatants[i] = _combatants[i].copyWith(
        cardNumber: deck[i],
        hasActed: false,
      );
    }

    _sortCombatants();
    _selectedCombatantIdForSwap = null;
    _currentTurnCard = turnOrder.isNotEmpty ? turnOrder.first.cardNumber : null;
    notifyListeners();
  }

  /// Advances the round counter, re-deals initiative cards, and resets turn state.
  void nextRound() {
    _round++;
    drawInitiative();
  }

  /// Adds an adversary or NPC to the initiative tracker if a slot is available (max 10).
  void addAdversary(String name, {String type = 'Adversary'}) {
    if (_combatants.length >= 10) return;

    final usedCards = _combatants.map((c) => c.cardNumber).toSet();
    final available = <int>[];
    for (var i = 1; i <= 10; i++) {
      if (!usedCards.contains(i)) available.add(i);
    }
    if (available.isEmpty) return;

    available.shuffle(Random());
    final newCard = available.first;

    _combatants.add(
      InitiativeCombatant(
        id: 'adversary_${DateTime.now().microsecondsSinceEpoch}',
        name: name.trim().isEmpty ? 'Adversary ${_combatants.length + 1}' : name.trim(),
        cardNumber: newCard,
        isInvestigator: false,
        hasActed: false,
        archetypeOrType: type,
      ),
    );

    _sortCombatants();
    _currentTurnCard ??= turnOrder.first.cardNumber;
    notifyListeners();
  }

  /// Removes a combatant from the tracker.
  void removeCombatant(String id) {
    _combatants.removeWhere((c) => c.id == id);
    if (_selectedCombatantIdForSwap == id) {
      _selectedCombatantIdForSwap = null;
    }
    if (_currentTurnCard != null &&
        !_combatants.any((c) => c.cardNumber == _currentTurnCard)) {
      advanceTurn();
    }
    notifyListeners();
  }

  /// Selects a combatant for swapping, or completes the swap if one is already selected.
  void selectCombatantForSwap(String id) {
    if (_selectedCombatantIdForSwap == null) {
      _selectedCombatantIdForSwap = id;
      notifyListeners();
      return;
    }

    if (_selectedCombatantIdForSwap == id) {
      // Deselect if clicked same card
      _selectedCombatantIdForSwap = null;
      notifyListeners();
      return;
    }

    // Execute card swap between the two combatants
    swapCards(_selectedCombatantIdForSwap!, id);
    _selectedCombatantIdForSwap = null;
    notifyListeners();
  }

  /// Swaps the card numbers of two combatants in the initiative rack.
  void swapCards(String idA, String idB) {
    final indexA = _combatants.indexWhere((c) => c.id == idA);
    final indexB = _combatants.indexWhere((c) => c.id == idB);
    if (indexA == -1 || indexB == -1) return;

    final cardA = _combatants[indexA].cardNumber;
    final cardB = _combatants[indexB].cardNumber;

    _combatants[indexA] = _combatants[indexA].copyWith(cardNumber: cardB);
    _combatants[indexB] = _combatants[indexB].copyWith(cardNumber: cardA);

    _sortCombatants();
    notifyListeners();
  }

  /// Toggles whether a combatant has acted in the current round.
  /// If marking as acted, smoothly advances to the next unacted combatant.
  void toggleActed(String id) {
    final index = _combatants.indexWhere((c) => c.id == id);
    if (index == -1) return;

    final updated = _combatants[index].copyWith(
      hasActed: !_combatants[index].hasActed,
    );
    _combatants[index] = updated;

    if (updated.hasActed && _currentTurnCard == updated.cardNumber) {
      advanceTurn();
    } else {
      notifyListeners();
    }
  }

  /// Advances turn pointer to the next combatant in card order who hasn't acted.
  void advanceTurn() {
    final ordered = turnOrder;
    if (ordered.isEmpty) {
      _currentTurnCard = null;
      notifyListeners();
      return;
    }

    // Search after current card
    final unacted = ordered.where((c) => !c.hasActed).toList();
    if (unacted.isEmpty) {
      _currentTurnCard = null; // All done
      notifyListeners();
      return;
    }

    if (_currentTurnCard == null) {
      _currentTurnCard = unacted.first.cardNumber;
    } else {
      final next = unacted.firstWhere(
        (c) => c.cardNumber > _currentTurnCard!,
        orElse: () => unacted.first, // Wrap around to earliest unacted
      );
      _currentTurnCard = next.cardNumber;
    }
    notifyListeners();
  }

  /// Resets the initiative encounter.
  void resetCombat() {
    _combatants.clear();
    _round = 1;
    _currentTurnCard = null;
    _selectedCombatantIdForSwap = null;
    _isCombatActive = false;
    notifyListeners();
  }

  void _sortCombatants() {
    _combatants.sort((a, b) => a.cardNumber.compareTo(b.cardNumber));
  }
}
