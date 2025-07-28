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

/// 감정별 맞춤 조언 (기존보다 더 따뜻하고 구체적으로)
const Map<String, String> emotionAdvice = {
  '행복':
      '지금 이 순간의 따뜻함이 마음 깊숙이 자리잡았네요. 이런 기쁨의 순간들을 천천히 음미하며, 주변 사람들에게도 그 온기를 나눠보세요.',
  '슬픔':
      '마음이 무거웠던 시간들을 혼자 견뎌내느라 정말 수고 많았어요. 슬픔도 당신 마음의 소중한 일부분이니, 억지로 밀어내려 하지 마세요.',
  '분노':
      '화가 났던 순간들 뒤에 숨어있는 진짜 마음은 무엇일까요? 그 감정을 통해서도 자신을 더 깊이 이해할 수 있어요. 천천히 숨을 고르며 마음을 들여다보세요.',
  '불안':
      '마음이 불안했던 시간들이 많았네요. 미래에 대한 걱정이 클 때일수록 지금 이 순간에 집중해보세요. 당신은 지금까지도 충분히 잘 해내고 있어요.',
  '설렘':
      '가슴이 두근거렸던 순간들이 많았네요. 이런 설렘이야말로 삶을 살아갈 이유 중 하나예요. 그 떨림을 마음껏 즐기고 오래 기억하세요.',
  '우울':
      '마음이 먹구름에 가려진 듯한 날들이었네요. 이런 때일수록 스스로를 다그치지 말고 따뜻하게 안아주세요. 작은 것에서 위안을 찾아보세요.',
  '무감정':
      '감정의 파도가 잔잔했던 시기네요. 때로는 이런 평온함도 필요해요. 하지만 마음 깊은 곳의 작은 소리에도 귀 기울여보는 건 어떨까요?',
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
  if (freq.length > 1) {
    for (final count in freq.values) {
      final p = count / total;
      entropy -= p * (log(p) / ln2);
    }
  }

  // 3. 기록 빈도 분석
  int recordDays = entries
      .map((e) => DateTime(e.date.year, e.date.month, e.date.day))
      .toSet()
      .length;
  int periodDays = _getPeriodDays(filter, entries);

  // 4. 이전 기간과 비교
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
      trendMsg =
          '\n지난 기간의 $prevTopType에서 이번에는 $type으로 마음의 중심이 이동했네요. 마음도 계절처럼 변화하는 법이에요.';
    } else if (prevTopType == type) {
      final prevRatio = prevSorted.isNotEmpty
          ? prevSorted.first.value / prevEntries.length
          : 0;
      if ((ratio - prevRatio).abs() > 0.1) {
        if (ratio > prevRatio) {
          trendMsg = '\n지난 기간보다 $type 감정이 더욱 깊어졌어요. 이런 변화도 마음 성장의 한 과정이에요.';
        } else {
          trendMsg = '\n지난 기간보다 $type 감정이 조금 완화되었네요. 마음의 균형을 찾아가는 과정 같아요.';
        }
      }
    }
  }

  // 5. 감정별 맞춤 조언
  String advice =
      emotionAdvice[type] ??
      '당신만의 특별한 감정 여행이었어요. 이 모든 순간들이 당신을 더욱 풍요롭게 만들어가고 있어요.';

  // 6. 메시지 조합 - 더 따뜻하고 개인적인 톤으로
  StringBuffer buf = StringBuffer();

  // 기간별 앞 문구 (더 따뜻하게)
  switch (filter) {
    case StatisticsFilter.day:
      buf.write('오늘 하루, 당신의 마음을 들여다보니');
      break;
    case StatisticsFilter.week:
      buf.write('일주일간의 마음 여정을 되돌아보니');
      break;
    case StatisticsFilter.month:
      buf.write('한 달간의 감정 변화를 살펴보니');
      break;
    case StatisticsFilter.year:
      buf.write('일 년간의 마음 일기를 펼쳐보니');
      break;
  }

  // 기록 빈도 (더 격려하는 톤으로)
  buf.write(' $periodDays일 중 $recordDays일의 소중한 감정들을 기록해두셨네요.');

  // 기록 빈도에 따른 추가 메시지
  double recordRatio = recordDays / periodDays;
  if (recordRatio >= 0.8) {
    buf.write(' 꾸준히 자신의 마음을 돌보는 모습이 정말 인상적이에요.');
  } else if (recordRatio >= 0.5) {
    buf.write(' 마음을 기록하는 습관이 조금씩 자리잡고 있는 것 같아요.');
  } else {
    buf.write(' 바쁜 일상 속에서도 자신을 돌아보는 시간을 가졌네요.');
  }
  buf.write('\n\n');

  // 감정 분포 (더 구체적이고 따뜻하게)
  if (ratio > 0.7) {
    buf.write('특히 $type 감정이 마음의 중심을 차지했던 시기였어요. 이런 집중된 감정의 시간도 의미가 깊어요.');
  } else if (entropy > 1.5) {
    buf.write('마음의 스펙트럼이 정말 다채로웠네요. 다양한 감정을 고루 경험하며 풍성한 시간을 보내셨군요.');
  } else {
    buf.write('여러 감정들이 조화롭게 어우러진 시간들이었어요.');
  }

  // 트렌드 메시지
  if (trendMsg.isNotEmpty) buf.write(trendMsg);
  buf.write('\n\n');

  // 맞춤 조언
  buf.write(advice);

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
