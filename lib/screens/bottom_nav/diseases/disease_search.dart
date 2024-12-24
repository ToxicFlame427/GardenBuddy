import 'dart:async';

import 'package:flutter/material.dart';
import 'package:garden_buddy/const.dart';
import 'package:garden_buddy/models/api/perenual/diseases_list.dart';
import 'package:garden_buddy/models/services/perenual_api_services.dart';
import 'package:garden_buddy/widgets/gb_icon_text_field.dart';
import 'package:garden_buddy/widgets/lists/list_card_loading.dart';
import 'package:garden_buddy/widgets/lists/plant_list_card.dart';
import 'package:garden_buddy/widgets/no_connection_widget.dart';
import 'package:swipe_refresh/swipe_refresh.dart';

class DiseaseSearch extends StatefulWidget {
  const DiseaseSearch({super.key});

  @override
  State<DiseaseSearch> createState() {
    return _DiseaseSearchState();
  }
}

class _DiseaseSearchState extends State<DiseaseSearch> {
  final _searchBarController = TextEditingController();
  DiseasesList? diseaseList;
  bool diseaseListIsLoaded = false;

  getdiseaseList() async {
    diseaseList = await PerenualAPIServices.getDiseaseList();

    // Check and change according to the plant list
    if (diseaseList != null) {
      setState(() {
        diseaseListIsLoaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    // When loaded, immedialty attempt to fetch the species list
    print("Getting disease list...");
    if (!diseaseListIsLoaded) {
      getdiseaseList();
    }
  }

  // For network integrity
  bool networkIntegrity = checkConnectionIntegrity();
  final StreamController<SwipeRefreshState> _refreshController =
      StreamController<SwipeRefreshState>();

  @override
  void dispose() {
    _searchBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Return the appropriate widget based on connection status
    if (networkIntegrity) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GbIconTextfield(
                hint: "Search diseases",
                controller: _searchBarController,
                icon: Icons.search,
                onPressed: () {
                  print(_searchBarController.text);
                }),
            // MARK: PUT PLANT SPECIES LIST HERE
            Visibility(
              visible: diseaseListIsLoaded,
              replacement: Expanded(
                  child: ListView.builder(
                      itemCount: 7,
                      itemBuilder: (context, index) {
                        return ListCardLoading();
                      })),
              child: Expanded(
                child: ListView.builder(
                    itemCount: diseaseList?.data.length,
                    itemBuilder: (context, index) {
                      // TODO: Replace with custom disease list card
                      return PlantListCard(
                        plantName: diseaseList!.data[index].commonName,
                        scientificName: diseaseList!.data[index].scientificName,
                        imageAddress: diseaseList!.data[index].images.isEmpty
                            ? null
                            : diseaseList!.data[index].images[0].smallUrl,
                        plantId: diseaseList!.data[index].id,
                      );
                    }),
              ),
            )
          ],
        ),
      );
    } else {
      return Stack(children: [
        NoConnectionWidget(),
        SwipeRefresh.adaptive(
          indicatorColor: Theme.of(context).colorScheme.primary,
          stateStream: _refreshController.stream,
          onRefresh: () async {
            await getConnectionTypes();

            setState(() {
              networkIntegrity = checkConnectionIntegrity();
              _refreshController.sink.add(SwipeRefreshState.hidden);
            });
          },
          children: [SizedBox(width: 100)],
        )
      ]);
    }
  }
}
