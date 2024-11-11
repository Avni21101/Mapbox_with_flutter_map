import 'package:flutter/material.dart';
import 'package:map_box_implementation/models/map_marker.dart';

class MarkerDetailCards extends StatefulWidget {
  const MarkerDetailCards({
    super.key,
    required this.mapMarkerList,
    required this.pageController,
    required this.onBackTap,
  });

  final List<MapMarker> mapMarkerList;
  final PageController pageController;
  final VoidCallback onBackTap;

  @override
  State<MarkerDetailCards> createState() => _MarkerDetailCardsState();
}

class _MarkerDetailCardsState extends State<MarkerDetailCards> {
  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: widget.pageController,
      itemCount: mapMarkers.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Card(
              margin: const EdgeInsets.all(20),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: const Color.fromARGB(255, 30, 29, 29),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: RatingStars(
                              rating: widget.mapMarkerList[index].rating ?? 4,
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: AddressColumn(
                              title: widget.mapMarkerList[index].title ?? '',
                              address:
                                  widget.mapMarkerList[index].address ?? '',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ImageWidget(
                          image: widget.mapMarkerList[index].image!),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                onPressed: widget.onBackTap,
                icon: const Padding(
                  padding: EdgeInsets.all(20),
                  child: Icon(
                    Icons.cancel_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}

class RatingStars extends StatelessWidget {
  const RatingStars({super.key, required this.rating});

  final int rating;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.horizontal,
      itemCount: rating,
      itemBuilder: (BuildContext context, int index) {
        return const Icon(
          Icons.star,
          color: Colors.orange,
        );
      },
    );
  }
}

class AddressColumn extends StatelessWidget {
  const AddressColumn({super.key, required this.title, required this.address});

  final String title;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          address,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class ImageWidget extends StatelessWidget {
  const ImageWidget({
    super.key,
    required this.image,
  });

  final String image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          image,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
