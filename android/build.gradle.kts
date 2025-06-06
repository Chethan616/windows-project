// ======================
// 🔧 Gradle Build Config
// ======================

// --- Buildscript block ---
buildscript {
    ext.kotlin_version = '1.9.0'
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath 'com.android.tools.build:gradle:7.3.0'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        classpath 'com.google.gms:google-services:4.4.0' // 🔑 Google services plugin
    }
}

// --- Allprojects repositories ---
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// --- Custom build directories ---
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

// --- Clean task ---
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
