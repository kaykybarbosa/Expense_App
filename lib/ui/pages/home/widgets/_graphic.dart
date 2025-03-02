part of '../home_page.dart';

class _Graphic extends StatelessWidget {
  const _Graphic();

  @override
  Widget build(BuildContext context) {
    final homeController =
        context.findAncestorStateOfType<HomePageState>()!.homeController;

    return SizedBox(
      height: 250,
      child: MyBarGraph(
        monthlySummary: homeController.monthlySummary(),
        startMonth: homeController.startMonth,
      ),
    );
  }
}
