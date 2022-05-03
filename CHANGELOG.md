# CHANGELOG

## 2022-05-03

DOCKERFILE (DEBIAN)
  * Added package "procps" (ps is used in default startup-script)

BUILD-PIPELINE (GITHUB IMAGES)
  * Added builds: 5.17.1, 5.16.5
  * Removed builds: 5.15.*, 5.16.4, 5.17.0
  * Updated postgres jdbc to 42.3.4

---
## 2022-04-01
  * Removed java-version from TAG. All current use jre-11
  * Added 5.17.0 build to pipeline ([Release notes](https://issues.apache.org/jira/secure/ReleaseNote.jspa?projectId=12311210&version=12346476)) (docker pull ghcr.io/kreditorforeningens-driftssentral-da/container-image-activemq:11-5.17.0)
---
## 2022-01-26
  * Combined Docker Hub & GitHub docker-action.
---
## 2022-01-26
  * Updated documentation/README.md
  * Added scheduled builds for 5.16.x & 5.15.x (jre-11)
  * Added dockerfile builds to actions (automated). Pushes to GitHub registry.
---
## 5.16.3 (Unreleased)

CHANGES
  * Changed TAG to follow activemq release
  * Changed distribution: ALPINE:3
  * Reworked provisoning-steps
  * Added ansible for pre-start configuration (runtime). Customize using environment-variables

VERSIONS
  * **JAVA:** openjdk-11 (jre-headless)
  * **ACTIVEMQ:** 5.16.3
  * **HAWTIO:** 2.14.0
  * **JDBC:** 42.2.24
---
## 0.2.0 (2021-03-11)

NEW FEATURE(S)
  * Added support for using postgres persistence driver (configured via env)

CHANGES
  * Cleanup of unused config-files and example folders
  * Split build into 2 separate runs (prepare & provision)

VERSIONS
  * **IMAGE:** Ubuntu 20.04
  * **JAVA:** openjdk-11-jre-headless
  * **ACTIVEMQ:** 5.16.1
  * **HAWTIO:** 2.13.0
  * **JDBC (POSTGRES):** 42.2.19
---
## 0.1.0 (2021-03-10)
CHANGES
  * Initial release

VERSIONS
  * **IMAGE:** Official Ubuntu 20.04
  * **JAVA:** openjdk-11-jre-headless
  * **ACTIVEMQ:** 5.16.1
  * **HAWTIO:** 2.13.0
  * **JDBC (POSTGRES):** 42.2.19
