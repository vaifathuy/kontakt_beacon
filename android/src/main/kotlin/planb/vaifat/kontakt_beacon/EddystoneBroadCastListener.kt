package planb.vaifat.kontakt_beacon

import android.content.Context
import com.kontakt.sdk.android.ble.exception.ScanError
import com.kontakt.sdk.android.ble.manager.listeners.EddystoneListener
import com.kontakt.sdk.android.ble.manager.listeners.ScanStatusListener
import com.kontakt.sdk.android.common.profile.IEddystoneDevice
import com.kontakt.sdk.android.common.profile.IEddystoneNamespace
import io.flutter.plugin.common.EventChannel
import planb.vaifat.kontakt_beacon.enum.BeaconStatus
import planb.vaifat.kontakt_beacon.model.Beacon
import planb.vaifat.kontakt_beacon.model.BeaconDeviceInformation
import planb.vaifat.kontakt_beacon.model.BeaconResponse
import planb.vaifat.kontakt_beacon.util.StringToJsonConverter

class EddystoneBroadCastListener(private var context: Context): EventChannel.StreamHandler, EddystoneListener, ScanStatusListener {

    private var events: EventChannel.EventSink? = null
    private var beaconResponse: BeaconResponse? = null
    private var beacon: Beacon? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        this.events = events
    }

    override fun onCancel(arguments: Any?) {
        this.events?.endOfStream()
    }

    override fun onEddystoneDiscovered(eddystone: IEddystoneDevice?, namespace: IEddystoneNamespace?) {
        if(eddystone?.instanceId.equals(namespace?.instanceId)) {
            beaconResponse = BeaconResponse(
                    namespace_id = eddystone?.namespace,
                    instance_id = eddystone?.instanceId,
                    unique_id = eddystone?.uniqueId,
                    status = BeaconStatus.DidEnter.value,
                    device_info = BeaconDeviceInformation(
                            distance = eddystone?.distance,
                            battery_power = eddystone?.batteryPower?.toDouble(),
                            rssi = eddystone?.rssi,
                            txPower = eddystone?.txPower,
                            proximity = eddystone?.proximity,
                            timestamp = eddystone?.timestamp
                    )
            )
            beacon = Beacon(beacon = beaconResponse)
            val beaconToString: String = StringToJsonConverter.convert(beacon = beacon!!)
            events?.success(beaconToString)
        }
    }

    override fun onEddystonesUpdated(eddystones: MutableList<IEddystoneDevice>?, namespace: IEddystoneNamespace?) {
        eddystones?.filter { i -> i.instanceId == namespace?.instanceId }
        eddystones?.forEach { item ->
            beaconResponse = BeaconResponse(
                    namespace_id = item.namespace,
                    instance_id = item.instanceId,
                    unique_id = item.uniqueId,
                    status = BeaconStatus.DidMonitor.value,
                    device_info = BeaconDeviceInformation(
                            distance = item.distance,
                            battery_power = item.batteryPower.toDouble(),
                            rssi = item.rssi,
                            txPower = item.txPower,
                            proximity = item.proximity,
                            timestamp = item.timestamp

                    )
            )
            beacon = Beacon(beacon = beaconResponse)
            val beaconToString: String = StringToJsonConverter.convert(beacon = beacon!!)
            events?.success(beaconToString)
        }

    }

    override fun onEddystoneLost(eddystone: IEddystoneDevice?, namespace: IEddystoneNamespace?) {
        if(eddystone?.namespace == namespace?.namespace) {
            beaconResponse = BeaconResponse(
                    namespace_id = eddystone?.namespace,
                    instance_id = eddystone?.instanceId,
                    unique_id = eddystone?.uniqueId,
                    status = BeaconStatus.DidExit.value,
                    device_info = BeaconDeviceInformation(
                            distance = eddystone?.distance,
                            battery_power = eddystone?.batteryPower?.toDouble(),
                            rssi = eddystone?.rssi,
                            txPower = eddystone?.txPower,
                            proximity = eddystone?.proximity,
                            timestamp = eddystone?.timestamp
                    )
            )
            beacon = Beacon(beacon = beaconResponse)
            val beaconToString: String = StringToJsonConverter.convert(beacon = beacon!!)
            events?.success(beaconToString)
        }
    }

    override fun onMonitoringCycleStop() {

    }

    override fun onScanStop() {
        beaconResponse = BeaconResponse(status = BeaconStatus.DidExit.value)
        beacon = Beacon(beacon = beaconResponse)
        val beaconToString: String = StringToJsonConverter.convert(beacon = beacon!!)
        events?.success(beaconToString)
    }

    override fun onMonitoringCycleStart() {

    }

    override fun onScanStart() {

    }

    override fun onScanError(scanError: ScanError?) {
        beaconResponse = BeaconResponse(status = BeaconStatus.DidExit.value)
        beacon = Beacon(beacon = beaconResponse)
        val beaconToString: String = StringToJsonConverter.convert(beacon = beacon!!)
        events?.success(beaconToString)
    }

}