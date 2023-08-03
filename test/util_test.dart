import 'package:hsrwikiproject/utils/logging.dart';

RegExp regExp =
    new RegExp(r"{param(?<index>\d+):(?:F(?<precision>\d+))?(?<percent>P?)}");

String parseDesc(String desc, List<num> params) {
  Iterable<RegExpMatch> matches = regExp.allMatches(desc);
  var result = desc;
  for (RegExpMatch match in matches) {
    String? placeholder = match.group(0);
    String? index = match.namedGroup("index");
    String? precision = match.namedGroup("precision");
    String? percent = match.namedGroup("percent");
    if (placeholder != null && index != null) {
      var value = params[int.parse(index) - 1];
      var fixed = precision == null ? 0 : int.parse(precision);
      var per;
      if (percent == null || percent.isEmpty) {
        per = '';
      } else {
        value *= 100;
        per = '%';
      }
      result = result.replaceFirst(
          placeholder, "${value.toStringAsFixed(fixed)}${per}");
    }
  }
  return result;
}

void main() {
  const desc = [
    "一回押しダメージ|{param1:F1P}",
    "長押しダメージ|{param2:F1P}",
    "滅浄三業ダメージ|{param3:F1P}攻撃力+{param4:F1P}元素熟知",
    "滅浄三業の発動間隔|{param5:F1}秒",
    "蘊種印の継続時間|{param6:F1}秒",
    "一回押しクールタイム|{param7:F1}秒",
    "長押しクールタイム|{param8:F1}秒",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    ""
  ];
  const params = [
    0.984,
    1.304,
    1.032,
    2.064,
    2.5,
    25,
    5,
    6,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ];

  for (var i = 0; i < desc.length; i++) {
    var d = desc[i];
    if (d.isEmpty) {
      continue;
    }
    logger.i(desc[i]);
    logger.i(parseDesc(desc[i], params));
    logger.i('------------------------------------------');
  }
}
