import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:heroapp/utils/constants.dart';

class RenderTwoDimensionalGridViewport extends RenderTwoDimensionalViewport {
  RenderTwoDimensionalGridViewport({
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required TwoDimensionalChildBuilderDelegate delegate,
    required super.mainAxis,
    required super.childManager,
    super.cacheExtent,
    super.clipBehavior = Clip.hardEdge,
  }) : super(delegate: delegate);

  @override
  void layoutChildSequence() {
    final double horizontalPixels = horizontalOffset.pixels;
    final double verticalPixels = verticalOffset.pixels;
    final double viewportWidth = viewportDimension.width + cacheExtent;
    final double viewportHeight = viewportDimension.height + cacheExtent;
    final TwoDimensionalChildBuilderDelegate builderDelegate =
    delegate as TwoDimensionalChildBuilderDelegate;

    final int maxRowIndex = builderDelegate.maxYIndex!;
    final int maxColumnIndex = builderDelegate.maxXIndex!;

    final int leadingColumn = math.max((horizontalPixels / (AppConstants.WIDTH + AppConstants.horizontalGap)).floor(), 0);
    final int leadingRow = math.max((verticalPixels / (AppConstants.HEIGHT + AppConstants.verticalGap)).floor(), 0);
    final int trailingColumn = math.min(
      ((horizontalPixels + viewportWidth) / (AppConstants.WIDTH + AppConstants.horizontalGap)).ceil(),
      maxColumnIndex,
    );
    final int trailingRow = math.min(
      ((verticalPixels + viewportHeight) / (AppConstants.HEIGHT + AppConstants.verticalGap)).ceil(),
      maxRowIndex,
    );

    double xLayoutOffset = (leadingColumn * (AppConstants.WIDTH + AppConstants.horizontalGap)) - horizontalOffset.pixels;
    for (int column = leadingColumn; column <= trailingColumn; column++) {
      double yLayoutOffset = (leadingRow * (AppConstants.HEIGHT + AppConstants.verticalGap)) - verticalOffset.pixels;
      for (int row = leadingRow; row <= trailingRow; row++) {
        final ChildVicinity vicinity =
        ChildVicinity(xIndex: column, yIndex: row);
        final RenderBox child = buildOrObtainChildFor(vicinity)!;
        child.layout(constraints.loosen());

        parentDataOf(child).layoutOffset = Offset(
            xLayoutOffset,
            yLayoutOffset
        );
        yLayoutOffset += (AppConstants.HEIGHT + AppConstants.verticalGap); // vertical gap
      }
      xLayoutOffset += (AppConstants.WIDTH + AppConstants.horizontalGap); // horizontal gap
    }

    final double verticalExtent = (AppConstants.HEIGHT + AppConstants.verticalGap) * (maxRowIndex + 1.065); // vertical gap
    verticalOffset.applyContentDimensions(
      0.0,
      clampDouble(
          verticalExtent - viewportDimension.height, 0.0, double.infinity),
    );
    final double horizontalExtent = (AppConstants.WIDTH + AppConstants.horizontalGap) * (maxColumnIndex + 1.08); // horizontal gap
    horizontalOffset.applyContentDimensions(
      0.0,
      clampDouble(
          horizontalExtent - viewportDimension.width, 0.0, double.infinity),
    );
  }
}