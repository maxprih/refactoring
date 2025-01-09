plugins {
    `java-library`
    `maven-publish`
    id("org.springframework.boot") version "3.4.1"
}

repositories {
    mavenLocal()
    maven {
        url = uri("https://repo.maven.apache.org/maven2/")
    }
}

dependencies {
    api(libs.org.springframework.boot.spring.boot.starter.data.jpa)
    api(libs.org.springframework.boot.spring.boot.starter.security)
    api(libs.org.springframework.boot.spring.boot.starter.web)
    api(libs.org.springdoc.springdoc.openapi.starter.webmvc.ui)
    api(libs.io.jsonwebtoken.jjwt.api)
    api(libs.io.jsonwebtoken.jjwt.impl)
    api(libs.org.flywaydb.flyway.core)
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
