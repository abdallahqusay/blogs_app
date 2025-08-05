import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract interface class ConecChecker{
  Future<bool> get isConnected;
}

class ConecCheckerImpl implements ConecChecker{
  final InternetConnection internetConnection;

  ConecCheckerImpl(this.internetConnection);
  
  @override
 
  Future<bool> get isConnected async => internetConnection.hasInternetAccess; 
  
}