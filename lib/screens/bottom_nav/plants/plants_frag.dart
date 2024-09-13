import 'package:flutter/material.dart';

class PlantsFragment extends StatefulWidget {
  const PlantsFragment({super.key});

  @override
  State<PlantsFragment> createState() {
    return _PlantsFragmentState();
  }
}

class _PlantsFragmentState extends State<PlantsFragment>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom:
              TabBar(
                controller: _tabController,
                labelColor: Colors.green,
                unselectedLabelColor: Colors.green,
                indicatorColor: Colors.green,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(
                    icon: Icon(Icons.search),
                    text: "Search",
                  ),
                  Tab(icon: Icon(Icons.favorite), text: "Favorites"),
                ],
              ),
        ),
        body: TabBarView(
            controller: _tabController,
            children: const [Text("Plant search"), Text("Plant favorites")]),
      ),
    );
  }
}
