// ignore: one_member_abstracts
abstract class RemoteConfigRepository {
  Future<bool> getDownForMaintenanceStatus();
  Future<double> getBookingFee();
}
