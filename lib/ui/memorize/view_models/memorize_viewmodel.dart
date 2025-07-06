import 'package:flutter/widgets.dart';

import '../../../domain/models/memo/memo.dart';

class MemorizeViewModel extends ChangeNotifier {
  MemorizeViewModel({required final Memo memo}) : _memo = memo;

  Memo get memo => _memo;

  final Memo _memo;
}
