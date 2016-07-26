---
docid: getting-started
title: 开始使用 Fresco
layout: docs
permalink: /docs/getting-started.html
prev: index.html
next: concepts.html
---

如果你仅仅是想简单下载一张网络图片，在下载完成之前，显示一张占位图，那么简单使用 [SimpleDraweeView](../javadoc/reference/com/facebook/drawee/view/SimpleDraweeView.html) 即可。

在加载图片之前，你必须初始化`Fresco`类。你只需要调用`Fresco.initialize`一次即可完成初始化，在 `Application` 里面做这件事再适合不过了（如下面的代码），注意多次的调用初始化是无意义的。

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

做完上面的工作后，你需要在 `AndroidManifest.xml` 中指定你的 Application 类。为了下载网络图片，请确认你声明了网络请求的权限。

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


在xml布局文件中, 加入命名空间：

```xml
<!-- 其他元素-->
<LinearLayout
    xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:fresco="http://schemas.android.com/apk/res-auto"
    android:layout_height="match_parent"
    android:layout_width="match_parent">
```

加入`SimpleDraweeView`:

```xml
<com.facebook.drawee.view.SimpleDraweeView
    android:id="@+id/my_image_view"
    android:layout_width="130dp"
    android:layout_height="130dp"
    fresco:placeholderImage="@drawable/my_drawable"
  />
```

开始加载图片:

```java
Uri uri = Uri.parse("https://raw.githubusercontent.com/facebook/fresco/gh-pages/static/logo.png");
SimpleDraweeView draweeView = (SimpleDraweeView) findViewById(R.id.my_image_view);
draweeView.setImageURI(uri);
```

剩下的，Fresco会替你完成: 

* 显示占位图直到加载完成；
* 下载图片；
* 缓存图片；
* 图片不再显示时，从内存中移除；

等等等等。
