package planb.vaifat.kontakt_beacon

import android.content.Context
import androidx.annotation.NonNull
import com.kontakt.sdk.android.ble.configuration.ScanMode
import com.kontakt.sdk.android.ble.configuration.ScanPeriod
import com.kontakt.sdk.android.ble.manager.ProximityManager
import com.kontakt.sdk.android.ble.manager.ProximityManagerFactory
import com.kontakt.sdk.android.common.KontaktSDK
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry.Registrar
import planb.vaifat.kontakt_beacon.constant.Constants
import java.util.concurrent.TimeUnit

/** KontaktBeaconPlugin */
class KontaktBeaconPlugin : FlutterPlugin {

  private var proximityManager: ProximityManager? = null
  private var methodChannel: MethodChannel? = null
  private var eventChannel: EventChannel? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    setUpProximityManager(flutterPluginBinding.applicationContext)
    setupChannels(flutterPluginBinding.binaryMessenger, flutterPluginBinding.applicationContext)
  }

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val plugin = KontaktBeaconPlugin()
      plugin.setUpProximityManager(registrar.context())
      plugin.setupChannels(registrar.messenger(), registrar.context())
    }
  }

  private fun setUpProximityManager(context: Context) {
    KontaktSDK.initialize(context)
    proximityManager = ProximityManagerFactory.create(context)
    proximityManager?.configuration()?.scanMode(ScanMode.BALANCED)?.scanPeriod(ScanPeriod.RANGING)?.deviceUpdateCallbackInterval(TimeUnit.SECONDS.toMillis(1))
  }

  private fun setupChannels(messenger: BinaryMessenger, context: Context) {
    methodChannel = MethodChannel(messenger, Constants.METHOD_CHANNEL)
    eventChannel = EventChannel(messenger, Constants.EVENT_CHANNEL)

    KontaktSDK.initialize(context)
    val receiver = EddystoneBroadCastListener(context = context)
    val methodChannelHandler = KontaktBeaconMethodHandler(proximityManager = proximityManager!!, eddystoneListener = receiver)
    
    methodChannel?.setMethodCallHandler(methodChannelHandler)
    eventChannel?.setStreamHandler(receiver)
    
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    teardownChannels()
  }

  private fun teardownChannels() {
    methodChannel?.setMethodCallHandler(null)
    eventChannel?.setStreamHandler(null)
    methodChannel = null
    eventChannel = null
  }
}
