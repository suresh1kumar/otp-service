# NEOM Domain Service Template

## About The Project

Use this NEOM Base app starter template for Creating Domain Layer Microservices.

* [Base app template Git Location](https://github.com/NEOM-KSA/neom-fss-neompay-otp-api)

## Built With - Frameworks, Tools & technologies

* [JDK 11](https://jdk.java.net/11/)
* SpringBoot <version> - MicroService Implementation. It has been tested with two oAuth providers
    * [GitHub API](https://docs.github.com/en/rest)
* Spring Security - Securing the service and implementing zero trust model standards
* Mockito Spring boot & Junit - Unit & Component Testing
* Helm - for packing and deploying the service to any kubernetes platform
* Docker - for building java containers alternative to Google JIB
* Gradle - Build Tool
* Jenkins & shared libraries for build and deploy

## Prerequisites

* JDK 11
* Java IDE, you can use any IDE whichever you want, examples:
    * IntelliJ
    * Eclipse

## About springboot micro service module

This has been built as multi-model app which contains below modules

* ***service***
    * service module will be for the micro-service and business orchestration
* ***library***
    * Library module will be responsible for Swagger, Api docs, Api models, auto generated models by
      protocol buffer and swagger utility

#### Microservice packages roles & responsibility

Rename or define classes under package service, controller, client layer.

* Controller - classes for request and response transfer tasks to service package layer and map data
  in respective model
* Service - classes to execute or orchestration of business implementation or fetch data from other
  service/back end systems by calling client layer
* Client - classes to interact with backend service and play as a wrapper for all types of
  communication with backend system
* Repository - classes for all communication with the microservice database
* Config - classes for defining configuration and beans
* Constants - enum type constants
* Utils - microservice level utilities only

#### Update library module

Rename or define protobuf schema and swagger docs under this module.

## Endpoints Available
