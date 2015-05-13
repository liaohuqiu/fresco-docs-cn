---
id: index
title: 下载Fresco
layout: docs
permalink: /docs/index.html
next: compile-in-android-studio.html
---

类库发布到了Maven中央库:

## Android Studio 或者 Gradle

```groovy
dependencies {
  compile 'com.facebook.fresco:fresco:0.4.0+'
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

## Eclipse ADT

首先，下载[这个文件](https://github.com/facebook/fresco/releases/download/v{{site.current_version}}/frescolib-v{{site.current_version}}.zip).

解压后，你会看到一个目录：frescolib，注意这个目录。

1. 从菜单 “文件(File)”，选择导入(Import)
2. 展开 Android, 选择 "Existing Android Code into Workspace"， 下一步。
3. 浏览，选中刚才解压的的文件中的 frescolib 目录。
4. 这5个项目应该都会被添加到工程： drawee， fbcore， fresco， imagepipeline， imagepipeline-okhttp。请确认前4个项目一定是被选中的。点击完成。
5. 右键，项目，选择属性，然后选择 Android。
6. 点击右下角的 Add 按钮，选择 fresco，点击 OK，再点击 OK。

现在，fresco 就导入到项目中了，你可以开始编译了。如果编译不通过，可以尝试清理资源，或者重启 Eclipse。

如果你想在网络层使用 OkHttp，请看[这里](using-other-network-layers.html#_).

如果 support-v4 包重复了，删掉 frescolib/imagepipeline/libs 下的即可。

```
建议尽早使用 Android Studio。
```
