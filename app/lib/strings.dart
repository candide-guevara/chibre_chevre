import 'package:chibre_core/chibre_core.dart';

/// Every text shown to the user, in French.
abstract final class Strings {
  // ------------------------------------------------------------- Game concepts

  static String rankIndex(Rank rank) => switch (rank) {
    Rank.jack => 'J',
    Rank.queen => 'Q',
    Rank.king => 'K',
    Rank.ace => 'A',
    _ => rank.label,
  };

  static String rankName(Rank rank) => switch (rank) {
    Rank.jack => 'valet',
    Rank.queen => 'dame',
    Rank.king => 'roi',
    Rank.ace => 'as',
    _ => rank.label,
  };

  static String suitName(Suit suit) => switch (suit) {
    Suit.diamonds => 'carreau',
    Suit.hearts => 'cœur',
    Suit.spades => 'pique',
    Suit.clubs => 'trèfle',
  };

  static String cardName(Card card) =>
      '${rankName(card.rank)} de ${suitName(card.suit)}';

  static String shortCard(Card card) =>
      '${rankIndex(card.rank)}${card.suit.symbol}';

  static const obenabe = 'Obenabe';
  static const undenufe = 'Undenufe';

  static String modeName(TrumpMode mode) => switch (mode) {
    TrumpMode.obenabe => obenabe,
    TrumpMode.undenufe => undenufe,
    _ => 'Atout ${suitName(mode.trumpSuit!)}',
  };

  static String modeSymbol(TrumpMode mode) => switch (mode) {
    TrumpMode.obenabe => '⬇',
    TrumpMode.undenufe => '⬆',
    _ => mode.trumpSuit!.symbol,
  };

  /// The trump alone: the suit's name, or Obenabe / Undenufe.
  static String trumpName(TrumpMode mode) =>
      mode.trumpSuit == null ? modeName(mode) : suitName(mode.trumpSuit!);

  /// "♥ cœur", "⬇ Obenabe".
  static String trumpWithSymbol(TrumpMode mode) =>
      '${modeSymbol(mode)} ${trumpName(mode)}';

  static const chibrer = 'Chibrer';

  static String trumpOptionName(TrumpOption option) =>
      option.isChibrer ? chibrer : modeName(option.mode!);

  static String meldName(Meld meld) {
    final cards = meld.cards.cards.map(shortCard).join(' ');
    return '${meld.value} ($cards)';
  }

  static const stoeck = 'Stöck';

  static String blunderTitle(BlunderKind kind) => switch (kind) {
    BlunderKind.trumpChoice => 'Choix de l\'atout',
    BlunderKind.cardPlay => 'Carte jouée',
    BlunderKind.missedMeld => 'Annonce oubliée',
    BlunderKind.missedStoeck => 'Stöck oublié',
  };

  // ------------------------------------------------------------- Common

  static const appTitle = 'Chibre Chèvre';
  static const home = 'Accueil';
  static const cancel = 'Annuler';
  static const save = 'Enregistrer';
  static const ok = 'OK';
  static const tapToContinue = 'Touchez pour continuer';
  static const defaultSettings = 'Paramètres par défaut';
  static const joinGame = 'Rejoindre une partie';
  static const createGame = 'Créer une partie';
  static const playAlone = 'Jouer seul';
  static const profile = 'Profil';
  static const gameAnalysis = 'Analyse de la partie';
  static const playedCards = 'Cartes jouées';
  static const announcements = 'Annonces';

  /// A team's score, from the player's point of view.
  static String ourScore(int points) => 'Nous $points';
  static String theirScore(int points) => 'Ordi $points';

  /// Points a team gains, from the player's point of view.
  static String gain({required bool ours, required int points}) =>
      '${ours ? 'Nous' : 'Ordi'} +$points';

  /// "Alice : …", what a player announced.
  static String playerLine(String nickname, String text) => '$nickname : $text';
  static const callSeparator = ' · ';
  static const listSeparator = ', ';

  // ------------------------------------------------------------- Start screen

  static String resume(String gameName) => 'Reprendre « $gameName »';

  // ------------------------------------------------------------- Profile

  static const nickname = 'Pseudo';
  static const cardDeck = 'Jeu de cartes';
  static const vintageCards = 'Vintage';
  static const ivoryCards = 'Ivoire';
  static const midnightCards = 'Minuit';

  // ------------------------------------------------------------- Host screen

  static const soloGameName = 'Partie solo';
  static String gameNameOf(String? nickname) => 'Partie de $nickname';
  static const fallbackGameName = 'Chibre';
  static const startGame = 'Lancer la partie';
  static const gameName = 'Nom de la partie';
  static const targetScore = 'Nombre de points';
  static const trumps = 'Atouts';
  static const fourSuits = '4 couleurs';
  static const withObenUnde = '+ Obenabe, Undenufe';
  static const multipliers = 'Multiplicateurs';
  static const multipliersDetail = '♦♥ ×1, ♠♣ ×2, Obenabe et Undenufe ×3';
  static const finishLastRound = 'Finir la dernière manche';
  static const finishLastRoundOff =
      'L\'équipe qui atteint le score en premier gagne.';
  static const loadDefaults = 'Par défaut';
  static const advanced = 'Avancé';

  // ------------------------------------------------------------- Advanced settings

  static const advancedSettings = 'Paramètres avancés';
  static String trickHold(Duration hold) =>
      'Pause avant de ramasser un pli : ${seconds(hold)}';
  static String thinkingTime(Duration time) =>
      'Réflexion des ordinateurs : ${seconds(time)}';
  static const assistance = 'Aide de jeu';
  static const assistanceDetail =
      'Boutons « Jouer pour moi » et « Cartes jouées »';
  static const sortByTrump = 'Trier la main selon l\'atout';
  static const sortByTrumpOff = 'Sinon : ♥ ♠ ♦ ♣, du 6 à l\'as';
  static const autoAnnounce = 'Annonces automatiques';
  static const autoAnnounceDetail =
      'Stöck annoncé tout seul, annonces proposées en début de manche';

  /// "1,5 s": French decimal comma.
  static String seconds(Duration duration) =>
      '${(duration.inMilliseconds / 1000).toStringAsFixed(1).replaceAll('.', ',')} s';

  // ------------------------------------------------------------- Join and wait

  static const address = 'Adresse (hôte:port)';
  static String addressIs(String address) => 'Adresse : $address';
  static const versionMismatch =
      'Les deux téléphones n\'ont pas la même version de l\'app.';
  static const gameFull = 'La partie est complète.';
  static const cannotJoin = 'Impossible de rejoindre la partie.';
  static const waitingForPlayer = 'En attente d\'un joueur…';
  static const searchingGames = 'Recherche de parties sur le réseau…';
  static String pausedScores(List<int> scores) =>
      'En pause — ${scores[0]} : ${scores[1]}';
  static String hostIs(String nickname) => 'Hôte : $nickname';
  static const resumeGame = 'Reprendre';
  static const paused = 'En pause';

  // ------------------------------------------------------------- Play screen

  static const gameEnded = 'Partie terminée';
  static String leftGame(String nickname) => '$nickname a quitté la partie.';
  static const leaveGame = 'Quitter la partie ?';
  static const leaveGameDetail =
      'La partie sera terminée pour les deux joueurs.';
  static const continueGame = 'Continuer';
  static const leave = 'Quitter';
  static const notAMeld = 'Ces cartes ne forment pas une annonce.';
  static const partnerChibred =
      'Votre partenaire a chibré : choisissez l\'atout';
  static const chooseTrump = 'Choisissez l\'atout';
  static const chooseMelds = 'Choisissez votre annonce';
  static const yourTurn = 'À vous de jouer';
  static String readsAnnouncements(String nickname) =>
      '$nickname lit les annonces…';
  static String readsRoundSummary(String nickname) =>
      '$nickname lit le résumé de la manche…';
  static String choosesMelds(String nickname) =>
      '$nickname choisit son annonce…';
  static String choosesTrump(String nickname) => '$nickname choisit l\'atout…';
  static String plays(String nickname) => '$nickname joue…';
  static String waitingFor(String nickname) => 'En attente de $nickname…';
  static const abandon = 'Abandonner';
  static const playForMe = 'Jouer pour moi';
  static const validateMelds = 'Valider l\'annonce';
  static const skipMelds = 'Ne pas annoncer, jouer';
  static const yourMelds = 'Vos annonces';
  static const keepSecret = 'Garder secret';
  static const announce = 'Annoncer';
  static const roundOver = 'Manche terminée';
  static const noAnnouncement = 'Aucune annonce';
  static const trump = 'Atout';
  static String trumpIs(TrumpMode mode) => 'Atout : ${modeName(mode)}';
  static const trumpLabel = 'Atout :';
  static String multiplier(int multiplier) => '×$multiplier';
  static String outOf(int target) => '/ $target';

  // ------------------------------------------------------------- End and insights

  static const victory = 'Victoire !';
  static const defeat = 'Défaite';
  static const analysing = 'L\'expert analyse la partie…';
  static const noBlunder = 'Aucune erreur notable. Bravo !';
  static String round(int index) => 'Manche ${index + 1}';
  static String roundAndTrick(int round, int trick) =>
      'Manche ${round + 1}, pli ${trick + 1}';
  static String pointsLost(double points) => '−${points.round()} pts';
  static const hand = 'Main';
  static const onTheTable = 'Sur la table';
  static String chosenAndBetter(TrumpOption chosen, TrumpOption best) =>
      'Choisi : ${trumpOptionName(chosen)}. '
      'Mieux : ${trumpOptionName(best)}.';
  static const played = 'Joué : ';
  static const better = '. Mieux : ';
  static const sentenceEnd = '.';
  static const notAnnounced = 'Non annoncé : ';
  static const stoeckNotAnnounced = 'Le Stöck n\'a pas été annoncé avec ';
  static String waitingForAnswer(String nickname) =>
      'En attente de la réponse de $nickname…';
  static String proposesRematch(String nickname, {required bool sameCards}) =>
      sameCards
      ? '$nickname propose une revanche avec les mêmes cartes'
      : '$nickname propose une revanche';
  static const accept = 'Accepter';
  static const refuse = 'Refuser';
  static const rematch = 'Revanche';
  static const rematchSameCards = 'Revanche, mêmes cartes';
}
