import 'package:flutter/material.dart';
import 'package:garden_buddy/screens/bottom_nav/diseases/disease_search.dart';

class DiseasesFragment extends StatefulWidget {
  const DiseasesFragment({super.key});

  @override
  State<DiseasesFragment> createState() {
    return _DiseasesFragmentState();
  }
}

class _DiseasesFragmentState extends State<DiseasesFragment>
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
          bottom: TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(context).colorScheme.primary,
            indicatorColor: Theme.of(context).colorScheme.primary,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [
              Tab(
                icon: Icon(Icons.search),
                text: "Search",
              ),
              Tab(icon: Icon(Icons.bookmark), text: "Saved"),
            ],
          ),
        ),
        body: TabBarView(
            controller: _tabController,
            children: const [DiseaseSearch(), Text("Saved Diseases")]),
      ),
    );
  }
}
