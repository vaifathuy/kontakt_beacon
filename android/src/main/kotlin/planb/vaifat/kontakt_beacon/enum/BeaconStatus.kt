package planb.vaifat.kontakt_beacon.enum

enum class BeaconStatus(val value: String) {
    DidMonitor("didMonitor"),
    DidFailMonitoring("didFailMonitoring"),
    DidEnter("didEnter"),
    DidExit("didExit"),
}