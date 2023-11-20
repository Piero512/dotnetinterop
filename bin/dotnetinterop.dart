import 'package:dotnetinterop/main.dart';
import 'package:recharge/recharge.dart';

var recharge = Recharge(
  path: "./lib/",
  onReload: () => main(),
);

void main() async {
  await recharge.init();
  Future.delayed(Duration(days: 1)).then((value) => print("waiting"));
  await restartableMain();
}
