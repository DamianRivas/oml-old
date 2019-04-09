# Ontology Modeling Language 

[![Gitpod - Code Now](https://img.shields.io/badge/Gitpod-code%20now-blue.svg?longCache=true)](https://gitpod.io#https://github.com/opencaesar/oml)
[![Build Status](https://travis-ci.org/opencaesar/oml.svg?branch=master)](https://travis-ci.org/opencaesar/oml)
[ ![Download](https://api.bintray.com/packages/opencaesar/oml/io.opencaesar.oml/images/download.svg) ](https://bintray.com/opencaesar/oml/io.opencaesar.oml/_latestVersion)

A language server for the Ontology Modeling Language (OML)

## Clone
```
  git clone https://github.com/opencaesar/oml.git
```

## Build

Dependencies: Gradle 4.9, Java 8
```
  cd oml
  cd io.opencaesar.oml.parent
  ./gradlew build
```

## Release

Replace \<version\> by the version, e.g., 1.2
```
  cd oml
  git tag -a v<version> -m "v<version>"
  git push origin v<version>
```