plugins {
    alias(libs.plugins.android.application)
    alias(libs.plugins.kotlin.android)
    alias(libs.plugins.kotlin.kapt)
    alias(libs.plugins.hilt.android)
}

android {
    namespace = "com.restroorder.waiter"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.restroorder.waiter"
        minSdk = 24
        targetSdk = 34
        versionCode = 104
        versionName = "1.0.4"

        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }

    buildFeatures {
        viewBinding = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }
}

dependencies {
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("com.google.android.material:material:1.11.0")
    implementation("androidx.constraintlayout:constraintlayout:2.1.4")
    implementation("androidx.webkit:webkit:1.10.0")

    // OkHttp & Persistent Cookies
    implementation("com.squareup.okhttp3:okhttp:4.12.0")
    implementation("com.squareup.okhttp3:logging-interceptor:4.12.0")
    implementation("com.google.code.gson:gson:2.10.1")

    // Room Database (Offline Queue & Snapshots)
    implementation("androidx.room:room-runtime:2.6.1")
    implementation("androidx.room:room-ktx:2.6.1")
    kapt("androidx.room:room-compiler:2.6.1")

    // WorkManager (Background Status Poller & Print Queue)
    implementation("androidx.work:work-runtime-ktx:2.9.0")

    // Thermal Printer ESC/POS
    implementation("com.github.DantSu:ESCPOS-ThermalPrinter-Android:3.3.0")

    // Security & Encrypted SharedPreferences
    implementation("androidx.security:security-crypto:1.1.0-alpha06")
}
