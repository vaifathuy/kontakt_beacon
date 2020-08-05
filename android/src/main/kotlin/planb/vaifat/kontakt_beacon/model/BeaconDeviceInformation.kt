package planb.vaifat.kontakt_beacon.model

import com.kontakt.sdk.android.common.Proximity

data class BeaconDeviceInformation(
        var distance: Double? = null,
        var battery_power: Double? =  null,
        var rssi: Int? = null,
        var txPower: Int? = null,
        var proximity: Proximity? = null,
        var timestamp: Long? =  null
)