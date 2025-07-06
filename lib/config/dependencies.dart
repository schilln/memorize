import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/repositories/memo_repository.dart';

List<SingleChildWidget> get providersLocal {
  return [Provider(create: (final context) => MemoRepository())];
}
