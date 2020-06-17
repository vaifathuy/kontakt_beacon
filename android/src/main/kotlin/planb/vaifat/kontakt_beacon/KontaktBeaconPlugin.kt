package planb.vaifat.kontakt_beacon

import android.content.Context
import android.os.Build
import androidx.annotation.NonNull
import com.kontakt.sdk.android.ble.configuration.ActivityCheckConfiguration
import com.kontakt.sdk.android.ble.configuration.ForceScanConfiguration
import com.kontakt.sdk.android.ble.device.EddystoneNamespace
import com.kontakt.sdk.android.ble.exception.ScanError
import com.kontakt.sdk.android.ble.manager.ProximityManager
import com.kontakt.sdk.android.ble.manager.ProximityManagerFactory
import com.kontakt.sdk.android.ble.manager.listeners.EddystoneListener
import com.kontakt.sdk.android.ble.manager.listeners.ScanStatusListener
import com.kontakt.sdk.android.ble.manager.listeners.SpaceListener
import com.kontakt.sdk.android.ble.manager.listeners.simple.SimpleEddystoneListener
import com.kontakt.sdk.android.ble.rssi.RssiCalculators
import com.kontakt.sdk.android.ble.spec.EddystoneFrameType
import com.kontakt.sdk.android.common.KontaktSDK
import com.kontakt.sdk.android.common.profile.IBeaconRegion
import com.kontakt.sdk.android.common.profile.IEddystoneDevice
import com.kontakt.sdk.android.common.profile.IEddystoneNamespace
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import planb.vaifat.kontakt_beacon.Constant.Constants
import planb.vaifat.kontakt_beacon.model.Eddystone
import planb.vaifat.kontakt_beacon.model.EventSink
import java.util.concurrent.TimeUnit


/** KontaktBeaconPlugin */
class KontaktBeaconPlugin : FlutterPlugin, MethodCallHandler {

  private lateinit var channel: MethodChannel
  private val streamEventChannel = "vaifat.planb.kontakt_beacon/eventChannel"

  var eddyStoneNamespaces: ArrayList<IEddystoneNamespace> = ArrayList()
  private lateinit var proximityManager: ProximityManager
  private lateinit var eventChannel: EventChannel
  private var eventSink: EventChannel.EventSink? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {

    channel = MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "vaifat.planb.kontakt_beacon/methodChannel")
    channel.setMethodCallHandler(this)
    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, streamEventChannel)
    KontaktSDK.initialize(flutterPluginBinding.applicationContext)
    configureProximityManager(flutterPluginBinding.applicationContext)
    createEventChannelListener(eventChannel = eventChannel)
    initProximityManagerListener()

  }

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar, kontaktBeaconPlugin: KontaktBeaconPlugin) {
      val methodChannel = MethodChannel(registrar.messenger(), "vaifat.planb.kontakt_beacon/methodChannel")
      methodChannel.setMethodCallHandler(KontaktBeaconPlugin())
    }
  }


  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${Build.VERSION.RELEASE}")
      }
      "startScanningBeacon" -> {
        startScanning()
      }
      "stopScanningBeacon" -> {
        stopScanning()
      }
      "startMonitoringBeacon" -> {
        val eddyStones: ArrayList<Eddystone> = ArrayList()
        val nameSpaceID: String = call.argument<String>(Constants.NAME_SPACE_ID).toString()
        val instanceID: String = call.argument<String>(Constants.INSTANCE_ID).toString()


        if (nameSpaceID.isNotEmpty() && instanceID.isNotEmpty()) {
          eddyStones.add(Eddystone(identifier = "", nameSpaceId = nameSpaceID, instanceId = instanceID))
          HrScanStatusListener(eddyStones = eddyStones)
        } else {
          val handler: EventSink = BeaconHandler.error()
          eventSink?.error(handler.errorCode, handler.errorMessage, handler.errorDetails)
        }
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun createEventChannelListener(eventChannel: EventChannel) {
    eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
      override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        if (events != null) {
          eventSink = events
          eventSink?.success("connect success")
        }
      }

      override fun onCancel(arguments: Any?) {

      }
    })
  }

  private fun configureProximityManager(context: Context) {

    proximityManager = ProximityManagerFactory.create(context)
    proximityManager.configuration()
            .activityCheckConfiguration(ActivityCheckConfiguration.DISABLED)
            .forceScanConfiguration(ForceScanConfiguration.DISABLED)
            .deviceUpdateCallbackInterval(TimeUnit.SECONDS.toMillis(3))
            .rssiCalculator(RssiCalculators.DEFAULT)
            .cacheFileName("Example")
            .monitoringEnabled(true)
            .eddystoneFrameTypes(listOf(EddystoneFrameType.UID, EddystoneFrameType.URL))
  }

  private fun startScanning() {
    eventSink?.success("start scanning")
    proximityManager.connect {
      proximityManager.startScanning()
    }
  }

  private fun stopScanning() {
    eventSink?.success("stop scanning")
    proximityManager.stopScanning()
  }

  private fun HrScanStatusListener(eddyStones: List<Eddystone>) {
    eddyStones.forEach { item ->
      eddyStoneNamespaces.add(EddystoneNamespace.Builder().identifier(item.identifier).namespace(item.nameSpaceId).instanceId(item.instanceId).build())
    }
    proximityManager.spaces().eddystoneNamespaces(eddyStoneNamespaces)
  }

  private fun initProximityManagerListener() {
    proximityManager.setScanStatusListener(createScanStatusListener())
    proximityManager.setSpaceListener(createSpaceListener())
    proximityManager.setEddystoneListener(createEddystoneListener())
  }

  private fun createEddystoneListener(): EddystoneListener? {
    return object : SimpleEddystoneListener() {
      override fun onEddystoneDiscovered(eddystone: IEddystoneDevice, namespace: IEddystoneNamespace) {

        println("Sample: Eddystone discovered: $eddystone")
        println("Sample: Eddystone discovered: $eddystone")

      }

      override fun onEddystonesUpdated(eddystones: MutableList<IEddystoneDevice>?, namespace: IEddystoneNamespace?) {
        super.onEddystonesUpdated(eddystones, namespace)

        println("Sample: Eddystone size: ${eddystones?.size}")
        eddystones?.forEach { item ->
          println("Sample: each eddystone $eddystones")
          eventSink?.success("$item")
        }
      }

      override fun onEddystoneLost(eddystone: IEddystoneDevice?, namespace: IEddystoneNamespace?) {
        super.onEddystoneLost(eddystone, namespace)
        println("Sample: Eddystone lost: $eddystone")
      }
    }
  }

  private fun createSpaceListener(): SpaceListener? {
    return object : SpaceListener {
      override fun onRegionEntered(region: IBeaconRegion?) {
        println("Sample: region enter $region")
      }

      override fun onRegionAbandoned(region: IBeaconRegion?) {
        println("Sample: region abandoned $region")

      }

      override fun onNamespaceAbandoned(namespace: IEddystoneNamespace?) {
        println("Sample: region name space abandoned $namespace")
      }

      override fun onNamespaceEntered(namespace: IEddystoneNamespace?) {
        println("Sample: region namespace enter $namespace")
      }
    }
  }

  private fun createScanStatusListener(): ScanStatusListener? {
    return object : ScanStatusListener {
      override fun onMonitoringCycleStop() {
        println("Sample: on monitoring cycle stop")
        eventSink?.success("on monitoring cycle stop")
      }

      override fun onScanStop() {
        println("Sample: on scan stop")
        eventSink?.success("on scan stop")


      }

      override fun onMonitoringCycleStart() {
        println("Sample: on monitoring cycle start")
        eventSink?.success("on monitoring cycle start")
      }

      override fun onScanStart() {
        println("Sample: on scan start")
        eventSink?.success("on scan start")
      }

      override fun onScanError(scanError: ScanError?) {
        println("Sample: on scan error ${scanError?.message}")
        eventSink?.success("on scan error")
      }
    }
  }
}
