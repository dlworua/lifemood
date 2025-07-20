import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/model/feeling_entry.dart';
import '../data/repository/feeling_repository.dart';

final feelingViewModelProvider =
    StateNotifierProvider<FeelingViewModel, List<FeelingEntry>>(
      (ref) => FeelingViewModel(),
    );

class FeelingViewModel extends StateNotifier<List<FeelingEntry>> {
  final _repository = FeelingRepository();

  FeelingViewModel() : super([]);

  Future<void> loadFeelings() async {
    state = await _repository.getFeelings();
  }

  Future<void> addFeeling(FeelingEntry entry) async {
    await _repository.saveFeeling(entry);
    state = [...state, entry];
  }
}
