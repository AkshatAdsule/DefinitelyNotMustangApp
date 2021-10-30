import 'package:flutter/material.dart';
import 'package:mustang_app/components/shared/map/zone_grid.dart';
import 'package:mustang_app/pages/scouting/map_scouting.dart';
import 'package:provider/provider.dart';
import '../../models/game_action.dart';

// ignore: must_be_immutable
class DefenseScoutingOverlay extends StatelessWidget {
  DefenseScoutingOverlay();

  @override
  Widget build(BuildContext context) {
    GlobalKey<ZoneGridState> zoneGridKey =
        Provider.of<GlobalKey<ZoneGridState>>(context);
    GlobalKey<MapScoutingState> mapScoutingKey =
        Provider.of<GlobalKey<MapScoutingState>>(context);

    return Stack(
      children: [],
    );
  }
}
