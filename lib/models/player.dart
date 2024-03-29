import 'actor.dart';
import 'game_tile.dart';

class Player extends Actor {
  int treasures = 0;
  int energy = 0;
  int maxEnergy;
  int restingCmp = 0;
  int minimumRestingTime;

  // Constructor
  Player({
    required super.name,
    required super.color,
    required this.maxEnergy,
    required this.minimumRestingTime,
  });

  void refillEnergy() {
    energy = energy + maxEnergy ~/ 2;
  }

  // Reset player (usually for a new game)
  void reset({required int maxEnergy, required int minimumRestingTime}) {
    treasures = 0;

    this.maxEnergy = maxEnergy;
    energy = maxEnergy;

    this.minimumRestingTime = minimumRestingTime;
    restingCmp = minimumRestingTime;

    tile = const GameTile.starting();
  }

  ///
  /// Advance the current position to next position in the queue
  @override
  bool march(List<GameTile> otherPlayers) {
    if (isExhausted || !super.march(otherPlayers)) return false;

    energy--;
    restingCmp = 0;

    return true;
  }

  ///
  /// Is the player exhausted (has no energy left)
  bool get isExhausted => energy <= 0;

  ///
  /// Rest the player, returns true if anything changed
  bool rest() {
    // If not rested, then wait
    if (restingCmp < minimumRestingTime) {
      restingCmp++;
      return true;
    }

    // If well rested and not at its maximum stamina
    if (energy < maxEnergy) {
      energy++;
      // Penalize long movement by restarting resting period
      if (nextPosition.isNotEmpty) restingCmp = 0;
      return true;
    }
    return false;
  }
}
