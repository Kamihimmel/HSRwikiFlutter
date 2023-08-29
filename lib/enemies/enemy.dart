import '../utils/helper.dart';

class Enemy {

}

class EnemyStats {
  int level = 72;
  int type = 1;
  int defenceReduce = 0;
  bool weaknessBreak = false;
  Set<ElementType> weakness = Set();

  EnemyStats.empty();
}