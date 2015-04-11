---
id: download-fresco
title: 下载Fresco
layout: docs
permalink: /docs/download-fresco.html
next: compile-in-android-studio.html
---

类库发布到了Maven中央库:

## Gradle:

```groovy
dependencies {
  compile 'com.facebook.fresco:fresco:0.1.0+'
}
```

## Maven:

```xml
<dependency>
  <groupId>com.facebook.fresco</groupId>
  <artifactId>fresco</artifactId>
  <version>LATEST</version>
</dependency>
```

## Eclipse

```
呵呵
```

Eclipse对aar的支持需要借助maven插件，如果是仅仅想使用，勉强可行，具体办法自行摸索。

但是如果想编译源码, 运行demo，可以通过gradle或者Android Studio，而Eclipse是真的不行了。
