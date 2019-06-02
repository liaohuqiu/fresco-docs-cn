---
docid: proguard
title: 发布使用了 Fresco 的 App
layout: docs
redirect_from: /docs/proguard.html
permalink: /docs/shipping.html
prev: 00-index.html
next: 01-using-simpledraweeview.html
---

Fresco 的体积可能有点庞大，所以我们强烈推荐你使用 ProGuard 工具，并分包构建多 APK 以使得你的应用程序保持较小体积。

### ProGuard

Fresco 从 1.9.0 版本起，本身就已包含一份 ProGuard 配置文件，只需你为你的 app 启用 PorGuard 便可生效。
为了启用 ProGuard，你需要修改 `build.gradle` 并将下列代码片段引入到 `release` 部分中：

```groovy
android {
  buildTypes {
    release {
      minifyEnabled true
      proguardFiles getDefaultProguardFile('proguard-android.txt')
    }
  }
}
```

### 构建多 APK

Fresco 主要用 Java 编写，但也有部分代码是 C++ 写的。C++ 代码必须根据 Android 设备的 CPU 类型（通常称为 “ABIs”）进行编译。目前，Fresco 支持五种 ABI：

1. `armeabiv-v7a`: 第 7 代及以上的 ARM 处理器。用于 2011 到 2015 年间生产的大部分 Android 设备。
2. `arm64-v8a`: 第 8 代、64 位 ARM 处理器，使用在一些新设备中，如：三星 Galaxy S6。 
3. `armeabi`: 第 5 代、第 6 代的 ARM 处理器，早期的手机用的比较多
4. `x86`: 平板、模拟器用得比较多。
5. `x86_64`: 64 位的平板。

Fresco 下载下来之后已经包含了这五种 `.so` 文件，你可以考虑根据不同的处理器类型构建独立的 APK，由此来缩减包体积。

如果你的应用不支持 Android 2.3 (Gingerbread)，你可以不需要 `armeabi` 类的ABI.

启用多 APK 构建，需要在 `build.gradle` 文件的 `android` 部分添加如下所示的 `splits` 部分代码：

```groovy
android {
  // 你的应用程序其余部分的逻辑代码
  splits {
    abi {
        enable true
        reset()
        include 'x86', 'x86_64', 'arm64-v8a', 'armeabi-v7a'
        universalApk false
    }
  }
}
```

参阅 [Android 发布文档](https://developer.android.com/google/play/publishing/multiple-apks.html) 查看关于多 APK 的详细信息。