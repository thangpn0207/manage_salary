package id.thangpn.manage_salary

class ConfigHelper {
    companion object {
        @JvmStatic
        fun getAppName(): String = BuildConfig.FLUTTER_APP_NAME

        @JvmStatic
        fun getAdsKey(): String = BuildConfig.FLUTTER_ADS_KEY

        @JvmStatic
        fun isDebug(): Boolean = BuildConfig.DEBUG
    }
}