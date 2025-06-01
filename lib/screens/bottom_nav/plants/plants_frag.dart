import 'package:flutter/material.dart';
import 'package:garden_buddy/const.dart';
import 'package:garden_buddy/models/purchases_api.dart';
import 'package:garden_buddy/screens/bottom_nav/plants/plant_favorites.dart';
import 'package:garden_buddy/screens/bottom_nav/plants/plant_search.dart';
import 'package:garden_buddy/widgets/objects/banner_ad.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
                Tab(icon: Icon(Icons.favorite), text: "Favorites"),
              ],
            ),
          ),
          body: Column(children: [
            Flexible(
                child: TabBarView(
                    controller: _tabController,
                    children: const [PlantSearch(), FavoritePlants()])),
            BannerAdView(
              androidBannerId: "ca-app-pub-6754306508338066/4358761762",
              iOSBannerId: "ca-app-pub-6754306508338066/9079226397",
              isTest: adTesting,
              isShown: !PurchasesApi.subStatus,
              bannerSize: AdSize.banner,
            ),
          ])),
    );
  }
}
