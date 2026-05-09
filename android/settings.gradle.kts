pluginManagement {
    val flutterSdkPath = run {
        val localProps = file("local.properties")
        if (localProps.exists()) {
            val properties = java.util.Properties()
            localProps.inputStream().use { properties.load(it) }
            properties.getProperty("flutter.sdk") ?: System.getenv("FLUTTER_ROOT")
        } else {
            System.getenv("FLUTTER_ROOT") ?: error("FLUTTER_ROOT not set and local.properties not found")
        }
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
    id("com.android.application") version "8.11.1" apply false
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
    id("com.google.gms.google-services") version "4.4.2" apply false
}

include(":app")
