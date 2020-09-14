package planb.vaifat.kontakt_beacon.constant

class Constants  {
    companion object {

        const val METHOD_CHANNEL = "vaifat.planb.kontakt_beacon/methodChannel"
        const val EVENT_CHANNEL = "vaifat.planb.kontakt_beacon/eventChannel"

        const val START_MONITORING = "startMonitoringBeacon"
        const val START_SCANNING = "startScanningBeacon"
        const val STOP_SCANNING = "stopScanningBeacon"

        const val INSTANCE_ID = "instanceID"
        const val NAME_SPACE_ID = "nameSpaceID"

        const val ERROR_CODE = 400
        const val SUCCESS_CODE = 200

        const val DID_EXIT = "Did exit"
        const val DID_ENTER = "Did enter"
        const val SCAN_FAIL = "Scanning fail"
        const val MONITORING_FAIL = "Scanning fail"
        const val SCAN_SUCCESS = "Scanning success"
        const val MONITORING_SUCCESS = "monitoring success"
    }
}