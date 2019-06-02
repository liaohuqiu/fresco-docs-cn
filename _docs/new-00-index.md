---
docid: index
title: 开始使用 Fresco
layout: docs
permalink: /docs/index.html
---

本文档将引导你完成在你的应用中开始使用 Fresco 所需的步骤，包括使用 Fresco 加载第一张图片。

### 1. 更新 Gradle 配置

编辑 `build.gradle` 文件，你必须添加以下一行代码到 `dependencies` 中:

```groovy
dependencies {
  // app 中的其他依赖
  implementation 'com.facebook.fresco:fresco:{{site.current_version}}'
}
```

下列模块的依赖可根据你的需求添加：

```groovy
dependencies {
  // 支持 GIF 动图
  implementation 'com.facebook.fresco:animated-gif:{{site.current_version}}'

  // 支持 WebP （包含静态图和动态图）
  implementation 'com.facebook.fresco:animated-webp:{{site.current_version}}'
  implementation 'com.facebook.fresco:webpsupport:{{site.current_version}}'

  // 仅支持 WebP 静态图
  implementation 'com.facebook.fresco:webpsupport:{{site.current_version}}'

  // 提供 Android Support 库（你也许已经添加该库或相似的库）
  implementation 'com.android.support:support-core-utils:{{site.support_library_version}}'
}
```

### 2. 初始化 Fresco 并声明权限

Fresco 需要被初始化，并且仅需一次。因此，将初始化操作放到你的 Application 中是一个不错的主意。示例如下：

```java
[MyApplication.java]
public class MyApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        Fresco.initialize(this);
    }
}
```

*注意：*记得在 ```AndroidManifest.xml``` 中声明你的 Application 类，并添加相关权限。通常，你需要添加网络权限。

```xml
  <manifest
    ...
    >
    <uses-permission android:name="android.permission.INTERNET" />
    <application
      ...
      android:label="@string/app_name"
      android:name=".MyApplication"
      >
      ...
    </application>
    ...
  </manifest>
```

### 3. 创建布局

在你的布局文件中，添加一个自定义命名空间到顶层元素。你必须添加它以访问自定义的 `fresco:` 属性，它使你能控制图片的加载与显示方式。(译者注：也可以使用 `app:` 属性而不必添加 `fresco:` 属性)

```xml
<!-- 这里可以放任何有效的元素 -->
<LinearLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:fresco="http://schemas.android.com/apk/res-auto"
    android:layout_height="match_parent"
    android:layout_width="match_parent"
    >
```

然后，添加 ```SimpleDraweeView``` 到布局中：

```xml
<com.facebook.drawee.view.SimpleDraweeView
    android:id="@+id/my_image_view"
    android:layout_width="130dp"
    android:layout_height="130dp"
    fresco:placeholderImage="@drawable/my_drawable"
    />
```

要显示图片，你只需要这样做：

```java
Uri uri = Uri.parse("https://raw.githubusercontent.com/facebook/fresco/master/docs/static/logo.png");
SimpleDraweeView draweeView = (SimpleDraweeView) findViewById(R.id.my_image_view);
draweeView.setImageURI(uri);
```
其余的工作就交给 Fresco 完成吧。

占位图会在图片加载好之前一直显示。图片会被下载、缓存、显示，并在你的 View 离开屏幕时从内存中清空。
