import 'feeling_entry.dart';
import 'statistics_filter.dart';
import 'dart:math';

/// 감정 이모지별 대표 감정 매핑
const Map<String, String> emojiType = {
  '😊': '행복', '😄': '행복', '😁': '행복', '😃': '행복',
  '😢': '슬픔', '😭': '슬픔', '🥲': '슬픔',
  '😡': '분노', '😠': '분노',
  '😱': '불안', '😨': '불안', '😰': '불안',
  '😐': '무감정', '😶': '무감정',
  '😍': '설렘', '🥰': '설렘',
  '😔': '우울', '😞': '우울',
  // 기타 이모지도 자유롭게 추가 가능
};

/// 감정별 맞춤 조언
const Map<String, String> emotionAdvice = {
  '행복': '행복한 순간을 주변 사람들과 나눠보세요. 그 기쁨이 더 커질 거예요!',
  '슬픔': '마음이 힘들 땐 스스로를 토닥여 주세요. 작은 기쁨도 놓치지 마세요.',
  '분노': '화가 날 땐 깊게 숨을 쉬고, 감정을 솔직하게 기록해보세요.',
  '불안': '불안한 마음이 들 땐 잠시 쉬어가며 나를 돌보는 시간을 가져보세요.',
  '설렘': '설렘이 가득한 순간, 그 두근거림을 오래 기억하세요.',
  '우울': '우울한 날엔 스스로를 다그치지 말고, 작은 변화부터 시작해보세요.',
  '무감정': '감정의 변화가 적었던 시기네요. 마음의 소리에 더 귀 기울여보는 건 어떨까요?',
};

String getFeelingAnalysisMessage(
  StatisticsFilter filter,
  List<FeelingEntry> entries, {
  List<FeelingEntry>? prevEntries, // 이전 기간 데이터(선택)
}) {
  if (entries.isEmpty) {
    return '아직 감정 기록이 없어요. 오늘의 마음을 한 줄로 남겨보는 건 어떨까요?\n작은 기록이 쌓여 당신의 마음을 더 잘 이해하게 해줄 거예요.';
  }

  // 1. 감정 분포 분석
  final Map<String, int> freq = {};
  for (final e in entries) {
    freq[e.emoji] = (freq[e.emoji] ?? 0) + 1;
  }
  final sorted = freq.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  final topEmoji = sorted.first.key;
  final topCount = sorted.first.value;
  final total = entries.length;
  final ratio = topCount / total;
  final type = emojiType[topEmoji] ?? '다양한 감정';

  // 2. 감정 다양성(엔트로피) 분석
  double entropy = 0;
  for (final count in freq.values) {
    final p = count / total;
    entropy -= p * (log(p) / ln2);
  }
  // 엔트로피가 높으면 다양, 낮으면 한 감정에 치우침

  // 3. 기록 빈도 분석
  // (예: 7일 중 5일 기록, 30일 중 20일 기록 등)
  int recordDays = entries
      .map((e) => DateTime(e.date.year, e.date.month, e.date.day))
      .toSet()
      .length;
  int periodDays = _getPeriodDays(filter, entries);

  // 4. 이전 기간과 비교 (가장 많은 감정 변화)
  String trendMsg = '';
  if (prevEntries != null && prevEntries.isNotEmpty) {
    final Map<String, int> prevFreq = {};
    for (final e in prevEntries) {
      prevFreq[e.emoji] = (prevFreq[e.emoji] ?? 0) + 1;
    }
    final prevSorted = prevFreq.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final prevTopEmoji = prevSorted.isNotEmpty ? prevSorted.first.key : null;
    final prevTopType = prevTopEmoji != null
        ? (emojiType[prevTopEmoji] ?? '다양한 감정')
        : null;
    if (prevTopType != null && prevTopType != type) {
      trendMsg = '\n지난 기간에는 ${prevTopType}이(가) 많았지만, 이번에는 ${type}이(가) 두드러졌어요.';
    } else if (prevTopType == type) {
      final prevRatio = prevSorted.isNotEmpty
          ? prevSorted.first.value / prevEntries.length
          : 0;
      if ((ratio - prevRatio).abs() > 0.1) {
        if (ratio > prevRatio) {
          trendMsg = '\n지난 기간보다 ${type} 감정이 더 많아졌어요!';
        } else {
          trendMsg = '\n지난 기간보다 ${type} 감정이 줄었어요.';
        }
      }
    }
  }

  // 5. 감정별 맞춤 조언
  String advice = emotionAdvice[type] ?? '';

  // 6. 메시지 조합
  StringBuffer buf = StringBuffer();
  // 기간별 앞 문구
  switch (filter) {
    case StatisticsFilter.day:
      buf.write('오늘 하루, ');
      break;
    case StatisticsFilter.week:
      buf.write('이번 주, ');
      break;
    case StatisticsFilter.month:
      buf.write('이번 달, ');
      break;
    case StatisticsFilter.year:
      buf.write('올해, ');
      break;
  }
  // 기록 빈도
  buf.write('$periodDays일 중 $recordDays일 감정을 기록했어요.\n');
  // 감정 분포
  if (ratio > 0.7) {
    buf.write('특히 $type 감정이 두드러졌어요.\n');
  } else if (entropy > 1.5) {
    buf.write('다양한 감정을 골고루 경험하셨네요.\n');
  } else {
    buf.write('여러 감정이 어우러진 시간들이었어요.\n');
  }
  // 트렌드 메시지
  if (trendMsg.isNotEmpty) buf.write(trendMsg + '\n');
  // 맞춤 조언
  if (advice.isNotEmpty) buf.write(advice);

  return buf.toString().trim();
}

// 기간 내 실제 일수 계산 (entries가 비어있으면 7, 30, 365 등 기본값)
int _getPeriodDays(StatisticsFilter filter, List<FeelingEntry> entries) {
  if (entries.isEmpty) {
    switch (filter) {
      case StatisticsFilter.day:
        return 1;
      case StatisticsFilter.week:
        return 7;
      case StatisticsFilter.month:
        return 30;
      case StatisticsFilter.year:
        return 365;
    }
  }
  final dates = entries
      .map((e) => DateTime(e.date.year, e.date.month, e.date.day))
      .toSet()
      .toList();
  dates.sort();
  final first = dates.first;
  final last = dates.last;
  return last.difference(first).inDays + 1;
}
