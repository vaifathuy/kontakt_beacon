package planb.vaifat.kontakt_beacon.model
import planb.vaifat.kontakt_beacon.enum.BeaconStatus

data class BeaconResponse(
        var namespace_id: String? = null,
        var instance_id: String? = null,
        var unique_id: String? = null,
        var status: String? = null,
        var device_info: BeaconDeviceInformation? = null
)