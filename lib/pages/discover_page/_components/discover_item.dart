import 'package:flutter/material.dart';
import 'package:loopyfeed/utils/constants.dart';
import 'package:loopyfeed/utils/extensions/color.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../models/reel.dart';

class DiscoverItem extends StatefulWidget {
  final Reel reel;
  final VoidCallback onTap;

  const DiscoverItem({super.key, required this.reel, required this.onTap});

  @override
  State<DiscoverItem> createState() => _DiscoverItemState();
}

class _DiscoverItemState extends State<DiscoverItem> {
  bool _isLoading = true;

  void _setLoadingFalse() {
    if (_isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Future.delayed(const Duration(seconds: 100), () {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        // });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Skeletonizer(
        enabled: _isLoading,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  widget.reel.thumbnailUrl ?? "",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      // return const SizedBox.shrink();
                      _setLoadingFalse();
                      return child;
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey,
                      child: const Center(
                        child: Icon(Icons.broken_image, color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withAlpha(190),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 15,
                left: 15,
                right: 15,
                child: Text(
                  "${widget.reel.title} ${widget.reel.id}",
                  style: TextStyle(
                    color: HexColor.fromHex(AppConstants.primaryWhite),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
