package planb.vaifat.kontakt_beacon

import android.os.Build
import com.kontakt.sdk.android.ble.device.EddystoneNamespace
import com.kontakt.sdk.android.ble.manager.ProximityManager
import com.kontakt.sdk.android.ble.manager.listeners.EddystoneListener
import com.kontakt.sdk.android.common.profile.IEddystoneNamespace
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import planb.vaifat.kontakt_beacon.model.BeaconEddystone

class KontaktBeaconMethodHandler(private var proximityManager: ProximityManager, var eddystoneListener: EddystoneListener) : MethodChannel.MethodCallHandler {

    private var eddyStoneNamespaces: ArrayList<IEddystoneNamespace> = ArrayList()

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {

            "startScanningBeacon" -> {
                startScanning()
                result.success("beacon scanning")
            }

            "startMonitoringBeacon" -> {
                val eddyStones: ArrayList<BeaconEddystone> = ArrayList()

                val uniqueId: String  = call.argument<String>("uniqueID").toString()
                val nameSpaceID: String = call.argument<String>("nameSpaceID").toString()
                val instanceID: String = call.argument<String>("instanceID").toString()
                if (nameSpaceID.isNotEmpty() && instanceID.isNotEmpty()) {
                    result.success("instance id $instanceID namespace $nameSpaceID")
                    eddyStones.add(BeaconEddystone(identifier = uniqueId, nameSpaceId = nameSpaceID, instanceId = instanceID))
                    initProximityManagerListener(eddyStones = eddyStones)
                }
            }

            "stopScanningBeacon" -> {
                stopScanning()
            }
            "getPlatformVersion" -> {
                result.success("Android ${Build.VERSION.RELEASE}")
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun startScanning() {
        proximityManager.connect {
            proximityManager.startScanning()
        }
    }

    private fun stopScanning() {
        proximityManager.stopScanning()
    }

    private fun initProximityManagerListener(eddyStones: ArrayList<BeaconEddystone>) {
        eddyStones.forEach { item ->
            val namespace: IEddystoneNamespace = EddystoneNamespace.Builder()
                    .identifier(item.identifier)
                    .namespace(item.nameSpaceId)
                    .instanceId(item.instanceId)
                    .build()
            eddyStoneNamespaces.add(namespace)
        }
        proximityManager.apply {
            spaces().eddystoneNamespaces(eddyStoneNamespaces)
            setEddystoneListener(eddystoneListener)
        }
    }
}