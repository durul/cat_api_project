import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

// NetworkInfo class to check the network status and
// notify listeners when the status changes.

// This class uses the Connectivity plugin to check the network status.
// It extends ChangeNotifier to notify listeners when the network status changes.
class NetworkInfo extends ChangeNotifier {
  final Connectivity connectivity;

  // Private property to store the network status
  bool _isConnected = false;

  // Constructor to initialize the Connectivity status in the constructor
  NetworkInfo(this.connectivity);

  bool get isConnected => _isConnected; // Synchronous getter

  // Asynchronous method to update connectivity
  Future<void> checkConnectivity() async {
    try {
      final connectivityResult = await connectivity.checkConnectivity();
      final newIsConnected =
          !connectivityResult.contains(ConnectivityResult.none);
      if (_isConnected != newIsConnected) {
        // Only notify if the status changes.
        _isConnected = newIsConnected;
        notifyListeners();
      }
    } catch (e) {
      print('Error checking connectivity: $e');
      // Handle the error appropriately, e.g., set _isConnected to false and
      // notify listeners if needed
    }
  }

  // It allows consumers of this class to listen to connectivity
  // changes as a stream of boolean values.
  Stream<bool> get onConnectivityChanged =>
      connectivity.onConnectivityChanged.map(
        (List<ConnectivityResult> results) =>
            results.isNotEmpty && results.first != ConnectivityResult.none,
      );
}
