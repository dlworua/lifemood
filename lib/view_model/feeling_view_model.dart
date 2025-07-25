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
    // 저장 후 반환된 객체로 상태 업데이트
    final savedEntry = await _repository.saveFeeling(entry);
    state = [...state, savedEntry];
  }

  Future<void> updateFeeling(FeelingEntry entry) async {
    await _repository.updateFeeling(entry);
    state = [
      for (final e in state)
        if (e.id == entry.id) entry else e,
    ];
  }
}
