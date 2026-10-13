pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    // یہاں AGP ورژن کو 8.2.2 سے گوگل جیمنائی کے کہنے پر بڑھا کر  8.5.1 اور پھر 8.7.0 کیا گیا
    id("com.android.application") version "8.7.0" apply false
    // START: FlutterFire Configuration
    id("com.google.gms.google-services") version "4.3.15" apply false
    id("com.google.firebase.crashlytics") version "2.8.1" apply false
    // END: FlutterFire Configuration
    // کوٹلن ورژن کو اپ ڈیٹ کر دیا گیا ہے تاکہ فائر بیس ایرر ختم ہو جائے
    id("org.jetbrains.kotlin.android") version "2.1.10" apply false
}

include(":app")