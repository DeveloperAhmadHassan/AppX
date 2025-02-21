import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:heroapp/controllers/carousel_reel_controller.dart';
import 'package:heroapp/models/reel.dart';
import 'package:heroapp/pages/carousal_page/_components/carousal_item.dart';
import 'package:heroapp/pages/carousal_page/_components/long_press_item.dart';
import 'package:heroapp/pages/carousal_page/_components/two_dimensional_grid_view.dart';
import 'package:heroapp/utils/constants.dart';


class CarousalPage extends StatefulWidget {
  final TabController tabController;
  final Function(Reel) onReelSelected;
  const CarousalPage({super.key, required this.tabController, required this.onReelSelected});

  @override
  _CarousalPageState createState() => _CarousalPageState();
}

class _CarousalPageState extends State<CarousalPage> {
  late ScrollController _horizontalController;
  late ScrollController _verticalController;

  List<List<Reel>> reels = [];
  bool isLoading = true;
  bool hasError = false;
  late CarouselReelController _carouselReelController;

  Timer? _showDialogTimer;
  bool _dialogVisible = false;
  Reel _selectedReel = Reel('assets/reels/a.mp4', thumbnailUrl: 'assets/thumbnails/a.jpg');

  @override
  void dispose() {
    _showDialogTimer?.cancel();
    _horizontalController.dispose();
    _verticalController.dispose();

    for (List<Reel> listOfReel in reels) {
      for(Reel reel in listOfReel) {
        reel.dispose();
      }
    }

    _carouselReelController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _carouselReelController = CarouselReelController(Dio());

    final double initialHorizontalOffset = (AppConstants.WIDTH + AppConstants.horizontalGap) * 0.85;
    final double initialVerticalOffset = (AppConstants.HEIGHT + AppConstants.verticalGap) * 0.75;

    _horizontalController = ScrollController(initialScrollOffset: initialHorizontalOffset);
    _verticalController = ScrollController(initialScrollOffset: initialVerticalOffset);

    _fetchReels();
  }

  Future<void> _fetchReels() async {
    try {
      List<Reel> fetchedReels = await _carouselReelController.fetchReelsData();

      if (fetchedReels.length % 9 != 0) {
        fetchedReels = fetchedReels.take(fetchedReels.length - fetchedReels.length % 9).toList();
      }

      List<List<Reel>> reels2D = [];
      for (int i = 0; i < fetchedReels.length; i += 3) {
        reels2D.add(fetchedReels.sublist(i, i + 3));
      }

      setState(() {
        reels = reels2D;
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }


  void _onLongPressStart(LongPressStartDetails details, Reel reel) {
    _selectedReel = reel;
    _showDialogTimer = Timer(Duration(seconds: 1), _showDialog);
  }

  void _onPointerUp(PointerUpEvent event) {
    _showDialogTimer?.cancel();
    _showDialogTimer = null;
    setState(() {
      _dialogVisible = false;
    });
  }

  void _showDialog() {
    setState(() {
      _dialogVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final layers = <Widget>[];

    layers.add(_buildPage());

    if (_dialogVisible) {
      layers.add(_buildDialog());
    }

    return Listener(
      onPointerDown: (event) {},
      onPointerUp: _onPointerUp,
      child: Stack(
        fit: StackFit.expand,
        children: layers,
      ),
    );
  }

  Widget _buildPage() {
    return Scaffold(
      // backgroundColor: Colors.black,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
          ? Center(child: const Padding(padding: EdgeInsets.only(top: 16.0), child: Center(child: Text('Some Error Occurred'))))
          : TwoDimensionalGridView(
        diagonalDragBehavior: DiagonalDragBehavior.free,
        horizontalDetails: ScrollableDetails.horizontal(controller: _horizontalController),
        verticalDetails: ScrollableDetails.vertical(controller: _verticalController),
        delegate: TwoDimensionalChildBuilderDelegate(
          maxXIndex: AppConstants.maxXIndex,
          maxYIndex: AppConstants.maxYIndex,
          builder: (BuildContext context, ChildVicinity vicinity) {
            var reel = reels[vicinity.xIndex][vicinity.yIndex];
            return CarousalItem(
              xIndex: vicinity.xIndex,
              yIndex: vicinity.yIndex,
              onLongPressStart: _onLongPressStart,
              onTap: () async {
                await widget.onReelSelected(reel);
                Future.delayed(const Duration(milliseconds: 200), () {
                  widget.tabController.animateTo(1);
                });
              },
              reel: reel,
            );
          },
        ),
      ),
    );
  }

  Widget _buildDialog() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width - 10,
      color: Colors.black.withValues(alpha: 0.5),
      padding: EdgeInsets.only(bottom: 20.0, top: 20, right: 10, left: 10),
      child: LongPressItem(reel:  _selectedReel),
    );
  }
}
