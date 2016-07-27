---
docid: index
title: 引入Fresco
layout: docs
permalink: /docs/index.html
next: getting-started.html
---

这里告诉你如何在项目中引入 Fresco.

### 使用 Android Studio 或者其他 Gradle 构建的项目

编辑 `build.gradle` 文件:

```groovy
dependencies {
  // 其他依赖
  compile 'com.facebook.fresco:fresco:{{site.current_version}}'
}
```

下面的依赖需要根据需求添加：

```groovy
dependencies {
  // 在 API < 14 上的机器支持 WebP 时，需要添加
  compile 'com.facebook.fresco:animated-base-support:{{site.current_version}}'

  // 支持 GIF 动图，需要添加
  compile 'com.facebook.fresco:animated-gif:{{site.current_version}}'

  // 支持 WebP （静态图+动图），需要添加
  compile 'com.facebook.fresco:animated-webp:{{site.current_version}}'
  compile 'com.facebook.fresco:webpsupport:{{site.current_version}}'

  // 仅支持 WebP 静态图，需要添加
  compile 'com.facebook.fresco:webpsupport:{{site.current_version}}'
}
```

### Eclipse ADT

下载 [zip 文件](https://github.com/facebook/fresco/releases/download/v{{site.current_version}}/frescolib-v{{site.current_version}}.zip).

解压后，你会看到一个目录：frescolib，注意这个目录。

1. 从菜单 “文件(File)”，选择导入(Import)
2. 展开 Android, 选择 "Existing Android Code into Workspace"， 下一步。
3. 浏览，选中刚才解压的的文件中的 frescolib 目录。
4. 这5个项目应该被添加到工程： `drawee`, `fbcore`, `fresco`, `imagepipeline`, `imagepipeline-base`。请确认这5个项目一定是被选中的。点击完成。其他的项目参考之前 Gradle的额外依赖介绍。
5. 右键，项目，选择属性，然后选择 Android。
6. 点击右下角的 Add 按钮，选择 fresco，点击 OK，再点击 OK。


现在，fresco 就导入到项目中了，你可以开始编译了。如果编译不通过，可以尝试清理资源，或者重启 Eclipse。

如果你想在网络层使用 OkHttp，请看[这里](using-other-network-layers.html#_).

如果 support-v4 包重复了，删掉 frescolib/imagepipeline/libs 下的即可。

> 建议尽早使用 Android Studio。



