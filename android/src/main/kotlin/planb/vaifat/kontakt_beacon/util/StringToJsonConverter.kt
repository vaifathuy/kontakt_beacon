package planb.vaifat.kontakt_beacon.util

import com.google.gson.GsonBuilder
import planb.vaifat.kontakt_beacon.model.Beacon

class StringToJsonConverter {
    companion object {
        private val gsonPretty = GsonBuilder().setPrettyPrinting().create()
        fun convert(beacon: Beacon?): String {
            return try {
                gsonPretty.toJson(beacon)
            } catch (e: Exception) {
                println("error exception ${e.message}")
                e.message.toString()
            }
        }
    }
}