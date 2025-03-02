part of '../home_page.dart';

class _Graphic extends StatelessWidget {
  const _Graphic();

  @override
  Widget build(BuildContext context) {
    final homeController = context.findAncestorStateOfType<HomePageState>()!.homeController;

    return SizedBox(
      height: 250,
      child: FutureBuilder(
        future: homeController.monthlySummary(),
        builder: (_, snapshot) {
          // -- data loaded
          if (snapshot.connectionState == ConnectionState.done) {
            return MyBarGraph(
              monthlySummary: snapshot.data!,
              startMonth: homeController.startMonth,
            );
          }
          // -- loading...
          else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
