import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loopyfeed/utils/extensions/color.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '_components/carousel_item.dart';
import '_components/two_dimensional_grid_view.dart';
import '../../controllers/carousel_reel_controller.dart';
import '../../models/reel.dart';
import '../../utils/constants.dart';

class CarouselPage extends StatefulWidget {
  final TabController tabController;
  final Function(Reel) onReelSelected;
  const CarouselPage({super.key, required this.tabController, required this.onReelSelected});

  @override
  State<CarouselPage> createState() => _CarouselPageState();
}

class _CarouselPageState extends State<CarouselPage> {
  late ScrollController _horizontalController;
  late ScrollController _verticalController;

  List<List<Reel>> reels = [];
  bool isLoading = true;
  bool hasError = false;
  late CarouselReelController _carouselReelController;

  Timer? _showDialogTimer;

  @override
  void dispose() {
    _showDialogTimer?.cancel();
    _horizontalController.dispose();
    _verticalController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _carouselReelController = CarouselReelController(Dio());

    final double initialHorizontalOffset = (AppConstants.WIDTH + AppConstants.horizontalGap) * 0.90;
    final double initialVerticalOffset = (AppConstants.HEIGHT + AppConstants.verticalGap) * 0.85;

    _horizontalController = ScrollController(initialScrollOffset: initialHorizontalOffset);
    _verticalController = ScrollController(initialScrollOffset: initialVerticalOffset);

    _fetchReels();
  }


  Future<void> _fetchReels() async {
    try {
      List<Reel> fetchedReels = await _carouselReelController.fetchReelsData();

      if (fetchedReels.length % 36 != 0) {
        fetchedReels = fetchedReels.take(fetchedReels.length - fetchedReels.length % 36).toList();
      }

      List<List<Reel>> reels2D = [];
      for (int i = 0; i < fetchedReels.length; i += 6) {
        reels2D.add(fetchedReels.sublist(i, i + 6));
      }

      setState(() {
        reels = reels2D;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
          ? Center(child: const Padding(padding: EdgeInsets.only(top: 16.0), child: Center(child: Text('Some Error Occurred'))))
          : Stack(
            children: [
              TwoDimensionalGridView(
                diagonalDragBehavior: DiagonalDragBehavior.free,
                horizontalDetails: ScrollableDetails.horizontal(controller: _horizontalController),
                verticalDetails: ScrollableDetails.vertical(controller: _verticalController),
                delegate: TwoDimensionalChildBuilderDelegate(
                  maxXIndex: AppConstants.maxXIndex,
                  maxYIndex: AppConstants.maxYIndex,
                  builder: (BuildContext context, ChildVicinity vicinity) {
                    var reel = reels[vicinity.xIndex][vicinity.yIndex];
                    reel.x = vicinity.xIndex;
                    reel.y = vicinity.yIndex;
                    return CarousalItem(
                      xIndex: vicinity.xIndex,
                      yIndex: vicinity.yIndex,
                      onTap: () async {
                        await widget.onReelSelected(reel);
                        Future.delayed(const Duration(milliseconds: 200), () {
                          widget.tabController.animateTo(1);
                        });
                      },
                      reel: reel,
                      horizontalController: _horizontalController,
                      verticalController: _verticalController,
                    );
                  },
                ),
              ),
              Positioned(
                  right: 50,
                  bottom: 80,
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        widget.tabController.animateTo(1);
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: HexColor.fromHex(AppConstants.primaryWhite).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha:0.8),
                            blurRadius: 25,
                            offset: Offset(0, 7),
                          ),
                        ],
                      ),
                      child: Icon(Symbols.chevron_right, size: 30, weight: 800, color: HexColor.fromHex(AppConstants.primaryWhite),),
                    ),
                  )
              ),
            ],
          ),
    );
  }
}
