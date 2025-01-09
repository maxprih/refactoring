plugins {
    `java`
    `maven-publish`
    id("org.springframework.boot") version "3.4.1"
}

repositories {
    mavenCentral()
    mavenLocal()
}

dependencies {
    implementation(libs.org.springframework.boot.spring.boot.starter.data.jpa)
    implementation(libs.org.springframework.boot.spring.boot.starter.security)
    implementation(libs.org.springframework.boot.spring.boot.starter.web)
    implementation(libs.org.springdoc.springdoc.openapi.starter.webmvc.ui)
    implementation(libs.io.jsonwebtoken.jjwt.api)
    implementation(libs.io.jsonwebtoken.jjwt.impl)
    implementation(libs.org.flywaydb.flyway.core)
    implementation("org.bebra:commons:1.0-SNAPSHOT")
    runtimeOnly(libs.org.postgresql.postgresql)
    runtimeOnly(libs.io.jsonwebtoken.jjwt.jackson)
    testImplementation(libs.org.springframework.boot.spring.boot.starter.test)
    compileOnly(libs.org.projectlombok.lombok)
    annotationProcessor(libs.org.projectlombok.lombok)
}

group = "com.example"
version = "0.0.1-SNAPSHOT"
description = "coursework"
java.sourceCompatibility = JavaVersion.VERSION_17

publishing {
    publications.create<MavenPublication>("maven") {
        from(components["java"])
    }
}

tasks.withType<JavaCompile>() {
    options.encoding = "UTF-8"
}

tasks.withType<Javadoc>() {
    options.encoding = "UTF-8"
}
