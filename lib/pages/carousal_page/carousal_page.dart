import 'dart:async';

import 'package:flutter/material.dart';
import 'package:heroapp/pages/carousal_page/_components/carousal_item.dart';
import 'package:heroapp/utils/constants.dart';


import '../../models/reel.dart';
import '_components/two_dimensional_grid_view.dart';

class CarousalPage extends StatefulWidget {

  const CarousalPage({
    super.key,
  });

  @override
  _CarousalPageState createState() => _CarousalPageState();
}

class _CarousalPageState extends State<CarousalPage> {
  late ScrollController _horizontalController;
  late ScrollController _verticalController;

  List<Reel> reels = [
    Reel('assets/reels/a.mp4', thumbnailUrl: 'assets/thumbnails/a.jpg',),
    Reel('assets/reels/b.mp4', thumbnailUrl: 'assets/thumbnails/b.jpg',),
    Reel('assets/reels/c.mp4', thumbnailUrl: 'assets/thumbnails/c.jpg',),
    Reel('assets/reels/d.mp4', thumbnailUrl: 'assets/thumbnails/d.jpg',),
    Reel('assets/reels/e.mp4', thumbnailUrl: 'assets/thumbnails/a.jpg',),
    Reel('assets/reels/f.mp4', thumbnailUrl: 'assets/thumbnails/b.jpg',),
    Reel('assets/reels/g.mp4', thumbnailUrl: 'assets/thumbnails/c.jpg',),
    Reel('assets/reels/h.mp4', thumbnailUrl: 'assets/thumbnails/d.jpg',),
    Reel('assets/reels/i.mp4', thumbnailUrl: 'assets/thumbnails/a.jpg',),
    Reel('assets/reels/j.mp4', thumbnailUrl: 'assets/thumbnails/b.jpg',),
    Reel('assets/reels/k.mp4', thumbnailUrl: 'assets/thumbnails/c.jpg',),
    Reel('assets/reels/l.mp4', thumbnailUrl: 'assets/thumbnails/d.jpg',),
    Reel('assets/reels/a.mp4', thumbnailUrl: 'assets/thumbnails/a.jpg',),
    Reel('assets/reels/b.mp4', thumbnailUrl: 'assets/thumbnails/b.jpg',),
    Reel('assets/reels/c.mp4', thumbnailUrl: 'assets/thumbnails/c.jpg',),
    Reel('assets/reels/d.mp4', thumbnailUrl: 'assets/thumbnails/d.jpg',),
    Reel('assets/reels/e.mp4', thumbnailUrl: 'assets/thumbnails/a.jpg',),
  ];
  final List<String> thumbnails = [
    'assets/thumbnails/a.jpg',
    'assets/thumbnails/b.jpg',
    'assets/thumbnails/c.jpg',
    'assets/thumbnails/d.jpg',
    'assets/thumbnails/b.jpg',
    'assets/thumbnails/c.jpg',
    'assets/thumbnails/a.jpg',
    'assets/thumbnails/d.jpg',
    'assets/thumbnails/c.jpg',
    'assets/thumbnails/a.jpg',
    'assets/thumbnails/b.jpg',
    'assets/thumbnails/d.jpg',
    'assets/thumbnails/a.jpg',
    'assets/thumbnails/b.jpg',
    'assets/thumbnails/c.jpg',
  ];
  var currentReelIndex = 0;

  Timer? _showDialogTimer;
  bool _dialogVisible = false;
  String _selectedText = '';

  @override
  void dispose() {
    _showDialogTimer?.cancel();
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
    super.dispose();
  }

  void _onLongPressStart(LongPressStartDetails details, String text) {
    _selectedText = text;
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
  void initState() {
    super.initState();
    currentReelIndex = 0;

    // for (var reel in reels) {
    //   reel.initialize();
    // }

    final double initialHorizontalOffset = (AppConstants.WIDTH + AppConstants.horizontalGap) * 0.85;
    final double initialVerticalOffset = (AppConstants.HEIGHT + AppConstants.verticalGap) * 0.75;

    _horizontalController = ScrollController(initialScrollOffset: initialHorizontalOffset);
    _verticalController = ScrollController(initialScrollOffset: initialVerticalOffset);
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
    currentReelIndex = 0;
    return Scaffold(
      backgroundColor: Colors.black,
      body: TwoDimensionalGridView(
        diagonalDragBehavior: DiagonalDragBehavior.free,
        horizontalDetails: ScrollableDetails.horizontal(controller: _horizontalController),
        verticalDetails: ScrollableDetails.vertical(controller: _verticalController),
        delegate: TwoDimensionalChildBuilderDelegate(
          maxXIndex: AppConstants.maxXIndex,
          maxYIndex: AppConstants.maxYIndex,
          builder: (BuildContext context, ChildVicinity vicinity) {
            currentReelIndex++;
            int reelIndex = (vicinity.xIndex * AppConstants.maxYIndex + vicinity.yIndex) % reels.length;
            return CarousaItem(
              xIndex: vicinity.xIndex,
              yIndex: vicinity.yIndex,
              onLongPressStart: _onLongPressStart,
              reel: reels[reelIndex],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDialog() {
    return Container(
      height: MediaQuery.of(context).size.height - 100,
      width: MediaQuery.of(context).size.width - 20,
      color: Colors.black.withOpacity(0.5),
      padding: EdgeInsets.all(30.0),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(_selectedText),
        ),
      ),
    );
  }
}