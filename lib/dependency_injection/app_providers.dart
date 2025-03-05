import 'package:expense_app/ui/pages/home/home_controller.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

abstract class AppProviders {
  static List<SingleChildWidget> providers = [
    ChangeNotifierProvider(create: (_) => HomeController.instance),
  ];
}
