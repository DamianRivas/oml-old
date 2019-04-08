# OML Language Server 

[![Gitpod - Code Now](https://img.shields.io/badge/Gitpod-code%20now-blue.svg?longCache=true)](https://gitpod.io#https://github.com/opencaesar/oml-language-server)
[![Build Status](https://travis-ci.org/opencaesar/oml-language-server.svg?branch=master)](https://travis-ci.org/opencaesar/oml-language-server)
[ ![Download](https://api.bintray.com/packages/opencaesar/oml-language-server/io.opencaesar.oml/images/download.svg) ](https://bintray.com/opencaesar/oml-language-server/io.opencaesar.oml/_latestVersion)

A language server for the Ontology Modeling Language (OML)

## Clone
```
  git clone https://github.com/opencaesar/oml-language-server.git
```

## Build

Dependencies: Gradle 4.9, Java 8
```
  cd oml-language-server
  cd io.opencaesar.oml.parent
  ./gradlew build
```

## Release

Replace \<version\> by the version, e.g., 1.2
```
  cd oml-language-server
  git tag -a v<version> -m "v<version>"
  git push origin v<version>
```

