---
docid: proguard
title: 混淆(Proguard)
layout: docs
permalink: /docs/proguard.html
prev: using-other-image-loaders.html
next: multiple-apks.html
---

Fresco的体积可能有点庞大，所以我们强烈推荐你在发布App时进行混淆(Proguard)。

你可以下载 Fresco 的 ProGuard 文件：[proguard-fresco.pro](https://raw.githubusercontent.com/facebook/fresco/master/proguard-fresco.pro), 并将它添加到你的项目中。

### Android Studio / Gradle 示例

编辑你的`build.gradle`，配置proguard文件：

```groovy
android {
  buildTypes {
    release {
      minifyEnabled true
      proguardFiles getDefaultProguardFile('proguard-android.txt'),
        'proguard-fresco.pro'
    }
  }
}
```

### Eclipse

编辑你的[proguard.cfg](http://developer.android.com/tools/help/proguard.html#enabling) 文件，将[proguard-fresco.pro](https://raw.githubusercontent.com/facebook/fresco/master/proguard-fresco.pro) 添加进去。
