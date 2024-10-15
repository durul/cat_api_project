import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// NetworkInfo class to check the network status and
// notify listeners when the status changes.

// This class uses the Connectivity plugin to check the network status.
// It extends ChangeNotifier to notify listeners when the network status changes.
class ConnectivityMonitor extends ChangeNotifier {
  final Connectivity connectivity;

  // Private property to store the network status
  bool _isConnected = false;

  // Constructor to initialize the Connectivity status in the constructor
  ConnectivityMonitor(this.connectivity);

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
    } on PlatformException catch (e) {
      // Handle platform-specific exceptions
      print('Platform exception checking connectivity: $e');
      if (e.code == 'no_network') {
        // Set _isConnected to false if no network is available
        _isConnected = false;
        notifyListeners();
      } else {
        // Handle other platform exceptions
        print('Unknown platform exception checking connectivity: $e');
      }
    } on SocketException catch (e) {
      // Handle socket exceptions
      print('Socket exception checking connectivity: $e');
      // Set _isConnected to false if socket exception occurs
      _isConnected = false;
      notifyListeners();
    } catch (e) {
      // Handle any other unexpected exceptions
      print('Unexpected exception checking connectivity: $e');
      // Set _isConnected to false and notify listeners
      _isConnected = false;
      notifyListeners();
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
