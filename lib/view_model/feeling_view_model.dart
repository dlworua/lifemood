// lib/view_model/feeling_view_model.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/model/feeling_entry.dart';
import '../data/repository/feeling_repository.dart';
import 'package:uuid/uuid.dart';

final feelingViewModelProvider =
    StateNotifierProvider<FeelingViewModel, List<FeelingEntry>>(
      (ref) => FeelingViewModel(),
    );

class FeelingViewModel extends StateNotifier<List<FeelingEntry>> {
  final _repo = FeelingRepository();

  FeelingViewModel() : super([]) {
    loadFeelings();
  }

  Future<void> loadFeelings() async {
    final feelings = await _repo.getFeelings();
    state = feelings;
  }

  Future<void> addFeeling(String content) async {
    final entry = FeelingEntry(
      id: const Uuid().v4(),
      content: content,
      createdAt: DateTime.now(),
    );

    await _repo.addFeeling(entry);
    state = [entry, ...state];
  }
}
