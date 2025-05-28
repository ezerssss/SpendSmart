import 'package:connectivity_plus/connectivity_plus.dart';

Future<bool> hasNetwork() async {
  final List<ConnectivityResult> connectivityResult =
      await (Connectivity().checkConnectivity());

  final hasMobile = connectivityResult.contains(ConnectivityResult.mobile);
  final hasWifi = connectivityResult.contains(ConnectivityResult.wifi);
  final hasEthernet = connectivityResult.contains(ConnectivityResult.ethernet);
  final hasVpn = connectivityResult.contains(ConnectivityResult.vpn);

  return hasMobile || hasWifi || hasEthernet || hasVpn;
}
