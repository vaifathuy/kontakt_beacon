package planb.vaifat.kontakt_beacon

import planb.vaifat.kontakt_beacon.Constant.Constants
import planb.vaifat.kontakt_beacon.model.EventSink

class BeaconHandler {
    companion object {
        fun error(): EventSink {
            return EventSink(errorCode = Constants.ERROR_CODE.toString(),errorMessage =  "error beacon", errorDetails = "namespace id and instance id can't empty")
        }
    }
}

