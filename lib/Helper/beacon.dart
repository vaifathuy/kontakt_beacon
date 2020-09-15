class Beacon {
  String _uniqueID;
  String _nameSpaceID;
  String _instanceID;

  Beacon(String _uniqueID, String _nameSpaceID, String instanceID) {
    this._uniqueID = _uniqueID;
    this._nameSpaceID = _nameSpaceID;
    this._instanceID = instanceID;
  }

  String get nameSpaceID => _nameSpaceID;
  String get instanceID => _instanceID;
  String get uniqueID => _uniqueID;
}