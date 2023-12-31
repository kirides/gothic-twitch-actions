## "Installation"

Die `TWI_Kirides.vdf` muss im `Gothic\Data\`-Ordner abgelegt werden.

## Befehle

| Befehl                                             | Beschreibung                                                                                                                                                                 |
| -------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| TWI_Raid_Bandits {optional: `N`}                   | Beschwört einen Banditenüberfall (Kapitelabhängig). `TWI_Raid_Bandits` für 1-3 Banditen, `TWI_Raid_Bandits 5` für 5 Banditen                                                 |
| TWI_Raid_Orcs {optional: `N`}                      | Beschwört einen Orküberfall (Kapitelabhängig). `TWI_Raid_Orcs` für 1-3 Orks, `TWI_Raid_Orcs 5` für 5 Orks                                                                    |
| TWI_SpawnEnemy `INSTANCE` `AMOUNT`                 | Beschwört einen feindlich gesinnten NPC. `TWI_SpawnEnemy Troll 2`                                                                                                            |
| TWI_SpawnNpc `INSTANCE` `AMOUNT`                   | Beschwört einen NPC. `TWI_SpawnNpc VLK_574_Mud 2`                                                                                                                            |
| TWI_SpawnNpcImmortal `INSTANCE` `AMOUNT`           | Beschwört einen unsterblichen NPC. `TWI_SpawnNpcImmortal VLK_574_Mud 2`                                                                                                      |
| TWI_SpawnNpcNamed `NAME` `INSTANCE` `AMOUNT`       | Beschwört einen NPC. `TWI_SpawnNpcNamed Frido VLK_574_Mud 2`                                                                                                                 |
| TWI_RandomWaypoint                                 | Teleportiert den Helden an einen zufälligen Waypoint                                                                                                                         |
| TWI_RandomStats                                    | Gibt dem Helden zufällige Statuswerte. Je nach Kapitel gedeckelt.                                                                                                            |
| TWI_RandomStatsNoLimit                             | Gibt dem Helden zufällige Statuswerte                                                                                                                                        |
| TWI_RandomStatsPool                                | Gibt dem Helden zufällige Statuswerte. Punkte in STR/DEX/MANA werden untereinander aufgeteilt. Ebenso punkte in 1h/2h/...                                                    |
| TWI_RandomTalent                                   | Verändert ein zufälliges Talent des Helden                                                                                                                                   |
| TWI_RandomTalents                                  | Gibt dem Helden zufällige Talente                                                                                                                                            |
| TWI_RandomArmor                                    | Gibt dem Helden eine zufällige Rüstung                                                                                                                                       |
| TWI_SpawnRandomMonster `AMOUNT`                    | Beschwört Random eines der _Monster_ aus dem Spiel, die Monster werden je nach Kapitel oder Helden Level stärker                                                             |
| TWI_SpawnRandomMonsterNoLimit `AMOUNT`             | Beschwört Random eines der _Monster_ aus dem Spiel, hier werden Monster aus allen Levelbereichen auftauchen                                                                  |
| TWI_SpawnRandomMonsterScaled `AMOUNT`              | Beschwört Random eines der _Monster_ aus dem Spiel, das Monster wird dabei auf das Level des Helden skaliert.                                                                |
| TWI_SpawnItemRandom                                | Spawnt ein zufälliges Item                                                                                                                                                   |
| TWI_SpawnRandomItemNoArmorWeapons                  | Spawnt ein zufälliges Item, ausgenommen von Waffen und Rüstungen                                                                                                             |
| TWI_VoicePitch `N`                                 | Stellt den VoicePitch des Helden ein                                                                                                                                         |
| TWI_SpawnNpcOneOf `INSTANCE...`                    | Beschwört zufälligen einen von `INSTANCE` Npcs. "`TWI_SpawnNpcOneOf VLK_574_Mud OrcScout ...`"                                                                               |
| TWI_SpawnEnemyOneOf `INSTANCE...`                  | Beschwört zufälligen einen von `INSTANCE` Npcs der dem Spieler Feindlich gesinnt ist. "`TWI_SpawnEnemyOneOf VLK_574_Mud OrcScout ...`"                                       |
| xxxx                                               | xxxx                                                                                                                                                                         |
| TWI_Money `AMOUNT`                                 | Spende oder Erhalte `AMOUNT` Goldstücke/Währung. `TWI_Money 100`, `TWI_Money -50`                                                                                            |
| TWI_Southpark `SECONDS`                            | 2x Spielgeschwindigkeit für `SECONDS` Sekunden. `TWI_Southpark 10`                                                                                                           |
| TWI_Slowdown `SECONDS`                             | 2.5x Spielgeschwindigkeit für `SECONDS` Sekunden. `TWI_Slowdown 10`                                                                                                          |
| TWI_InvertKeyControls `DurationSeconds`            | Invertiert die Steuerung für mindestens `DurationSeconds` oder bis erneut aufgerufen                                                                                         |
| TWI_Time {00-23}                                   | Setzt die Tageszeit. `TWI_Time 06` bedeutet 06:00. Es gibt alle Zahlen von `0`, `1`, `2`, ...`23`                                                                            |
| TWI_Weakest_Weapon                                 | Es werden die schwächsten Waffen die der Held bei sich trägt angezogen.                                                                                                      |
| TWI_RandomHP_Pct `MIN` `MAX`                       | Setzt die aktuellen HP des Helden auf einen zufälligen %-Wert zwischen `MIN` und `MAX`. `TWI_RandomHP_Pct 1 25`                                                              |
| TWI_FullHeal                                       | Heilt den Helden vollständig (HP & MANA)                                                                                                                                     |
| TWI_SetHP `N`                                      | Setzt die aktuellen HP des Helden auf `N`. `TWI_SetHP 1`                                                                                                                     |
| TWI_SetHP_Timed `AMOUNT` `SECONDS`                 | Setzt die aktuellen HP des Helden für 5 Sekunden auf auf `AMOUNT` für `SECONDS` Sekunden.                                                                                    |
| TWI_SetMana `N`                                    | Setzt das aktuelle Mana des Helden auf `N`. `TWI_SetMana 0`                                                                                                                  |
| TWI_SetMana_Timed `AMOUNT` `SECONDS`               | Setzt das aktuelle Mana des Helden für 5 Sekunden auf auf `AMOUNT` für `SECONDS` Sekunden.                                                                                   |
| TWI_RandomStatBonus `ATR` `MIN` `MAX` `LOW` `HIGH` | Erhöht/Senkt das Attribut `ATR` (Eines von `STR`, `DEX`, `HP`, `MANA`) um einen zufälligen Wert zwischen `LOW` & `HIGH`, aber niemals höher als `MAX` oder weniger als `MIN` |
| xxxx                                               | xxxx                                                                                                                                                                         |

## Zusätzliche Instanzen aus dem Patch

| Instance           | Beschreibung               |
| ------------------ | -------------------------- |
| TWI_BDT_1_Bandit_L | Ein Bandit etwa Kapitel 1  |
| TWI_BDT_2_Bandit_L | Ein Bandit etwa Kapitel 2  |
| TWI_BDT_3_Bandit_L | Ein Bandit etwa Kapitel 3  |
| TWI_BDT_4_Bandit_L | Ein Bandit etwa Kapitel 4+ |
| TWI_Orc_S          | Ein schwacher Ork          |
| TWI_Orc_M          | Ein stärkerer Ork          |
| TWI_Orc_L          | Ein starker Ork            |
| xxxx               | xxxx                       |
| xxxx               | xxxx                       |
