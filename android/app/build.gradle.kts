import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "id.thangpn.manage_salary"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    buildFeatures {
        buildConfig = true
    }

    flavorDimensions += "environment"
    productFlavors {
        create("development") {
            dimension = "environment"
            applicationId = "id.thangpn.manage_salary.dev"
            resValue("string", "app_name", "Manage Salary Dev")
            buildConfigField(
                "String",
                "FLUTTER_APP_NAME",
                "\"Manage Salary Dev\""
            )
            buildConfigField("String", "FLUTTER_ADS_KEY", "\"\"")
            buildConfigField("boolean", "DEBUG", "true")
            manifestPlaceholders["FLUTTER_APP_NAME"] = "Manage Salary Dev"
            manifestPlaceholders["ADMOB_APP_ID"] = System.getenv("ADMOB_APP_ID")
                ?: "ca-app-pub-2103558986527802~5808548229"
        }
        create("staging") {
            dimension = "environment"
            applicationId = "id.thangpn.manage_salary"
            resValue("string", "app_name", "Manage Salary")
            buildConfigField("String", "FLUTTER_APP_NAME", "\"Manage Salary\"")
            buildConfigField("String", "FLUTTER_ADS_KEY", "\"\"")
            buildConfigField("boolean", "DEBUG", "false")
            manifestPlaceholders["FLUTTER_APP_NAME"] = "Manage Salary"
            manifestPlaceholders["ADMOB_APP_ID"] =
                System.getenv("ADMOB_APP_ID") ?: ""
        }
        create("production") {
            dimension = "environment"
            applicationId = "id.thangpn.manage_salary"
            resValue("string", "app_name", "Manage Salary")
            buildConfigField("String", "FLUTTER_APP_NAME", "\"Manage Salary\"")
            buildConfigField("String", "FLUTTER_ADS_KEY", "\"\"")
            buildConfigField("boolean", "DEBUG", "false")
            manifestPlaceholders["FLUTTER_APP_NAME"] = "Manage Salary"
            manifestPlaceholders["ADMOB_APP_ID"] = System.getenv("ADMOB_APP_ID")
                ?: "ca-app-pub-2103558986527802~5808548229"
        }
    }

    defaultConfig {
        multiDexEnabled = true
        minSdk = 24
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (keystorePropertiesFile.exists()) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String?
                keyPassword = keystoreProperties["keyPassword"] as String?
                storeFile = keystoreProperties["storeFile"]?.let { file(it) }
                storePassword = keystoreProperties["storePassword"] as String?
            }
        }
    }

    buildTypes {
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
        release {
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("com.google.android.material:material:1.12.0")
    implementation("com.google.android.gms:play-services-ads:24.2.0")
    implementation("androidx.multidex:multidex:2.0.1")
}