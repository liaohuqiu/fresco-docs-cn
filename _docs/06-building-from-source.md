---
docid: building-from-source
title: 构建源码
layout: docs
permalink: /docs/building-from-source.html
prev: multiple-apks.html
next: sample-code.html
---

你只应该在你需要修改Fresco源码时去构建它。大部分App只需要在项目中[导入依赖](index.html#_)就够了。

### 前置条件

你需要在系统中安装这些工具：

1. 下载 Android [SDK](https://developer.android.com/sdk/index.html#Other)；
2. 通过Android SDK Manager, 安装/升级 Support Library **和** Support Repository至最新；
2. 下载 Android [NDK](https://developer.android.com/tools/sdk/ndk/index.html)。版本不低于10c；
3. 下载[git](http://git-scm.com/)；

你不需要下载Gradle，Android Studio内置了它。

Fresco不支持在Eclipse, Ant, 或 Maven 环境下构建，以后也不准备添加这方面的支持。

### 配置 Gradle

编辑`gradle.properties`文件。它通常在你的`~/.gradle/`目录下。如果没找到，那么创建它。

1. 添加NDK路径
Unix系统下，添加：

```groovy
ndk.path=/path/to/android_ndk/r10e
```

Windows系统下，添加：

```groovy
ndk.path=C\:\\path\\to\\android_ndk\\r10e
```

2. 添加一些基础gradle配置

```groovy
org.gradle.daemon=true
org.gradle.parallel=true
org.gradle.configureondemand=true
```

### 获取源码

```sh
git clone https://github.com/facebook/fresco.git
```

### 由命令行构建源码

在Unix系统下，`cd` 至 Fresco 代码目录下，输入下面的命令:

```sh
./gradlew build
```

在Windows系统下，打开命令行，`cd` 至 Fresco 代码目录下，输入下面的命令:

```bat
gradlew.bat build
```

### 由Android Studio构建 Fresco

在Android Studio中import Fresco项目，它会自动构建。

### Offline builds

第一次构建Fresco时, 你的电脑必须连接至 Internet。 其他情况下可以使用Gradle的`--offline`选项。

### 问题解决

> Could not find com.android.support:...:x.x.x.

请确认你的 Support 库是最新的。

### Windows支持

我们没有人使用Windows电脑进行开发，所以我们无法对Windows上构建Fresco源码有完美的支持（比如CI服务器就无法支持Windows构建）。

如果你在Windows上构建代码碰见了任何问题，请提交一个Issue给我们，我们会尽力解决它：）

### 贡献代码

请参考[CONTRIBUTING](https://github.com/facebook/fresco/blob/master/CONTRIBUTING.md)。
