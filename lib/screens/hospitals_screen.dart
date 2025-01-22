import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class HospitalsScreenContent extends StatefulWidget {
  const HospitalsScreenContent({super.key});

  @override
  _HospitalsScreenContentState createState() => _HospitalsScreenContentState();
}

class _HospitalsScreenContentState extends State<HospitalsScreenContent> 
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final List<Marker> _markers = [];
  final List<String> _lastVisitedHospitals = [];
  GoogleMapController? _mapController;
  Position? _currentPosition;
  bool _isLoading = true;
  String? _error;
  List<Hospital> _hospitals = [];
  final TextEditingController _searchController = TextEditingController();
  List<Hospital> _searchResults = [];
  bool _isSearching = false;
  Timer? _debounce;

  // Add focus node
  final FocusNode _searchFocusNode = FocusNode();

  late AnimationController _animationController;

  final _mapStyle = [
    {
      "featureType": "poi.medical",
      "elementType": "geometry",
      "stylers": [{"color": "#f5f5f5"}]
    },
    {
      "featureType": "poi.medical",
      "elementType": "labels.text",
      "stylers": [{"color": "#cc0000"}]
    }
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchFocusNode.dispose();
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _error = 'Location services are disabled';
          _isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _error = 'Location permissions are denied';
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _error = 'Location permissions are permanently denied';
          _isLoading = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 5),
      );

      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });

      _loadNearbyHospitals();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadNearbyHospitals() async {
    if (_currentPosition == null) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final lat = _currentPosition!.latitude;
      final lng = _currentPosition!.longitude;
      
      print('Loading hospitals at: $lat, $lng'); // Debug coordinates

      final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'
          '?location=$lat,$lng'
          '&radius=10000'
          '&type=hospital'
          '&key=AIzaSyDOKSfbngtNqTwvsixlJqCWNWsH5WetaGk';

      print('Fetching URL: $url'); // Debug URL

      final response = await http.get(Uri.parse(url));
      print('Response status: ${response.statusCode}'); // Debug response
      print('Response body: ${response.body}'); // Debug response data

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List;
        print('Found ${results.length} hospitals'); // Debug results count

        if (results.isEmpty) {
          setState(() {
            _error = 'No hospitals found within 10km';
            _isLoading = false;
          });
          return;
        }

        setState(() {
          _hospitals = results.map((place) {
            final location = place['geometry']['location'];
            return Hospital(
              name: place['name'] ?? 'Unknown Hospital',
              vicinity: place['vicinity'] ?? 'No address available',
              rating: (place['rating'] ?? 0.0).toDouble(),
              location: LatLng(
                location['lat'] as double,
                location['lng'] as double,
              ),
            );
          }).toList();

          _markers.clear();
          for (var hospital in _hospitals) {
            _markers.add(
              Marker(
                markerId: MarkerId(hospital.name),
                position: hospital.location,
                onTap: () => _showHospitalDetails(hospital),
              ),
            );
          }
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load hospitals: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading hospitals: $e'); // Debug error
      setState(() {
        _error = 'Error loading hospitals: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _searchHospitals(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
    });

    try {
      final lat = _currentPosition?.latitude ?? 0;
      final lng = _currentPosition?.longitude ?? 0;
      
      final url = 'https://maps.googleapis.com/maps/api/place/textsearch/json'
          '?query=$query hospital'
          '&location=$lat,$lng'
          '&radius=50000'
          '&type=hospital'
          '&key=AIzaSyDOKSfbngtNqTwvsixlJqCWNWsH5WetaGk';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List;

        setState(() {
          _searchResults = results.map((place) {
            final location = place['geometry']['location'];
            return Hospital(
              name: place['name'] ?? 'Unknown Hospital',
              vicinity: place['formatted_address'] ?? 'No address available',
              rating: (place['rating'] ?? 0.0).toDouble(),
              location: LatLng(
                location['lat'] as double,
                location['lng'] as double,
              ),
            );
          }).toList();
          _isSearching = false;
        });
      }
    } catch (e) {
      print('Search error: $e');
      setState(() => _isSearching = false);
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchHospitals(query);
    });
  }

  void _showHospitalDetails(Hospital hospital) {
    final distance = _currentPosition != null
        ? _calculateDistance(
            LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            hospital.location,
          )
        : null;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hospital.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF07569b),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      index < hospital.rating
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                      size: 20,
                    );
                  }),
                ),
                const SizedBox(width: 8),
                Text(
                  hospital.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.grey, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    hospital.vicinity,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ],
            ),
            if (distance != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.directions_walk, color: Colors.grey, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '${(distance / 1000).toStringAsFixed(1)} km away',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            const Text(
              'Open 24 hours - Emergency services available',
              style: TextStyle(
                fontSize: 14,
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _openMapsApp(hospital.location.latitude, hospital.location.longitude),
                icon: const Icon(Icons.directions),
                label: const Text('Get Directions'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openDirections(Hospital hospital) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=${hospital.location.latitude},${hospital.location.longitude}&travelmode=driving';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void _openMapsApp(double lat, double lng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _addToLastVisited(String hospitalName) {
    setState(() {
      _lastVisitedHospitals.add(hospitalName);
    });
  }

  void _clearSearch() {
    setState(() {
      _searchResults.clear();
      _searchController.clear();
      _searchFocusNode.unfocus();
    });
  }

  void _onHospitalSelected(Hospital hospital) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(hospital.location, 15),
    );
    _showHospitalDetails(hospital);
    _clearSearch();
  }

  double _calculateDistance(LatLng start, LatLng end) {
    return Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Don't forget this line
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Hospitals'),
        elevation: 0,
      ),
      body: Stack(
        children: [
          if (_currentPosition != null)
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                zoom: 14,
              ),
              markers: Set<Marker>.of(_markers),
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                controller.setMapStyle(jsonEncode(_mapStyle));
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              compassEnabled: true,
              mapToolbarEnabled: true,
              padding: const EdgeInsets.only(
                top: 100.0,  // Padding for search bar
                bottom: 10.0,  // Padding for bottom sheet
                right: 16.0,   // Padding from edge
              ),
            ),

          // Updated Search Bar with proper alignment
          Positioned(
            top: 20, // Added margin from top
            left: 16,
            right: 16,
            child: Material(
              elevation: 8,
              shadowColor: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
              child: Container(
                height: 50, // Fixed height
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Center( // Center alignment
                  child: TextField(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onChanged: _onSearchChanged,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'Search hospitals...',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Icon(Icons.search, color: Color(0xFF07569b)),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: _clearSearch,
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14, // Vertical centering
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Compact Search Results
          if (_searchResults.isNotEmpty)
            Positioned(
              top: 70,
              left: 10,
              right: 10,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.4,
                ),
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(15),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final hospital = _searchResults[index];
                      final distance = _currentPosition != null
                          ? _calculateDistance(
                              LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                              hospital.location,
                            )
                          : null;
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              hospital.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF07569b),
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(hospital.vicinity),
                                if (distance != null)
                                  Text(
                                    '${(distance / 1000).toStringAsFixed(1)} km away',
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 20),
                                Text(
                                  hospital.rating.toStringAsFixed(1),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            onTap: () => _onHospitalSelected(hospital),
                          ),
                          if (index != _searchResults.length - 1)
                            const Divider(height: 1),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),

          // Bottom Information Panel
          if (_lastVisitedHospitals.isNotEmpty)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recently Viewed',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF07569b),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _lastVisitedHospitals.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.only(right: 8),
                            child: Container(
                              width: 200,
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _lastVisitedHospitals[index],
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class Hospital {
  final String name;
  final String vicinity;
  final double rating;
  final LatLng location;

  Hospital({
    required this.name,
    required this.vicinity,
    required this.rating,
    required this.location,
  });
}