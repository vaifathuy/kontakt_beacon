class Beacon {
  String _nameSpaceID;
  String _instanceID;

  Beacon(String _nameSpaceID, String instanceID) {
    this._nameSpaceID = _nameSpaceID;
    this._instanceID = instanceID;
  }

  String get nameSpaceID => _nameSpaceID;
  String get instanceID => _instanceID;
}