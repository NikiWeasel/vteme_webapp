import 'package:vteme_tg_miniapp/core/models/combined_regulation_with_time_options.dart';
import 'package:vteme_tg_miniapp/core/models/regulation_with_time_options.dart';

sealed class SelectedRegulationOption {}

class SelectedCombined extends SelectedRegulationOption {
  final CombinedRegulationsWithTimeOptions combined;

  SelectedCombined(this.combined);
}

class SelectedSeparated extends SelectedRegulationOption {
  final List<RegulationWithTimeOptions> separated;

  SelectedSeparated(this.separated);
}
