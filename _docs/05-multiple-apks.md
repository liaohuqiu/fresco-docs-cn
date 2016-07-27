---
docid: multiple-apks
title: 按需打包
layout: docs
permalink: /docs/multiple-apks.html
prev: proguard.html
next: building-from-source.html
---

Fresco 大部分的代码是由Java写的，但是里面也有很多C++的代码。C++代码必须根据Android 设备的CPU类型(通常称为"ABIs")进行编译。目前Fresco支持五种 ABI:

1. `armeabiv-v7a`: 第7代及以上的 ARM 处理器。2011年15月以后的生产的大部分Android设备都使用它。
2. `arm64-v8a`: 第8代、64位ARM处理器，很少设备，三星 Galaxy S6是其中之一。 
1. `armeabi`: 第5代、第6代的ARM处理器，早期的手机用的比较多。
1. `x86`: 平板、模拟器用得比较多。
2. `x86_64`: 64位的平板。

Fresco 下载下来之后已经包含了在这五种`.so`文件，你可以根据不同平台打出不同的App，由此来缩减包体积。

如果你的应用不支持 Android 2.3 (Gingerbread)，你可以不需要 `armeabi` 类的ABI.

### Android Studio / Gradle

编辑 `build.gradle` 文件:

```groovy
android {
  // rest of your app's logic
  splits {
    abi {
        enable true
        reset()
        include 'x86', 'x86_64', 'arm64-v8a', 'armeabi-v7a', 'armeabi'
        universalApk false
    }
  }
}
```

参考[Android Gradle 文档](http://tools.android.com/tech-docs/new-build-system/user-guide/apk-splits)来获取更多信息。

### Eclipse

默认情况下，Eclipse会产生一个含有所有ABI的app。将他们拆分比较困难（相比于Gradle）。

你需要下载[multi-APK zip file](https://github.com/facebook/fresco/releases/download/v{{site.current_version}}/frescolib-v{{site.current_version}}-multi.zip)而不是我们之前提供的标准ZIP包，而且你需要替换你的项目！

1. 根据[Android官方指示](http://developer.android.com/training/multiple-apks/api.html)，你可以将项目拆分成多个项目。你可以使用相同的`AndroidManifest.xml`。
2. 不同ABI需求(flavor)的项目，需要依赖于不同的`fresco-<flavor>`. (如果你使用OkHttp，你需要对应地引入`imagepipeline-okhttp-<flavor>`)


### 上传至Play Store

你可以上传单个Apk，也可以拆分上传。详情可以参考[Play Store文档](http://developer.android.com/google/play/publishing/multiple-apks.html)。
