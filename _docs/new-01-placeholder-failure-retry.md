---
docid: placeholder-failure-retry
title: 占位图，失败图与重试图
layout: docs
permalink: /docs/placeholder-failure-retry.html
prev: scaletypes.html
next: rotation.html
---

当你使用网络加载图片时，可能会遇到一些问题：加载时间过长、或者甚至图片本身就不可用。我们已经看到过如何使用 [进度条](progress-bars.html)。本节中，我们会看到当实际图不可用时（或者根本没有时）还能显示哪些其他内容。请注意，这些内容都有可以自定义的、不同的缩放类型。

### 占位图

占位图显示在你设置 URI 或 controller 之前，直到它加载完毕（无论成功或失败）。

#### XML

```xml
<com.facebook.drawee.view.SimpleDraweeView
  android:id="@+id/my_image_view"
  android:layout_width="20dp"
  android:layout_height="20dp"
  fresco:placeholderImage="@drawable/my_placeholder_drawable"
  />
```

#### 代码

```java
mSimpleDraweeView.getHierarchy().setPlaceholderImage(placeholderImage);
```

### 失败图

失败图显示于请求失败时，无论是网络相关的失败（404，超时）或是图片数据相关的失败（格式错误的图片，不支持的格式）。

#### XML

```xml
<com.facebook.drawee.view.SimpleDraweeView
  android:id="@+id/my_image_view"
  android:layout_width="20dp"
  android:layout_height="20dp"
  fresco:failureImage="@drawable/my_failure_drawable"
  />
```

#### 代码

```java
mSimpleDraweeView.getHierarchy().setFailureImage(failureImage);
```

### 重试图

重试图也显示于请求失败时。当用户点击它，请求最多重试 4 次，之后会显示失败图。为了启用重试图，你需要在 controller 中启用对它的支持，就像这样设置你的图片请求：

```java
mSimpleDraweeView.setController(
    Fresco.newDraweeControllerBuilder()
        .setTapToRetryEnabled(true)
        .setUri(uri)
        .build());
```

#### XML

```xml
<com.facebook.drawee.view.SimpleDraweeView
  android:id="@+id/my_image_view"
  android:layout_width="20dp"
  android:layout_height="20dp"
  fresco:failureImage="@drawable/my_failure_drawable"
  />
```

#### 代码

```java
simpleDraweeView.getHierarchy().setRetryImage(retryImage);
```

### 拓展阅读

占位图，失败图和重试图是 Drawee 的 *分支*。尽管上述的这些分支是最常用的，但是除了它们以外，还有其他分支。要阅读所有分支及其工作方式，请查看 [Drawee 的分支](drawee-branches.html)。

### Example

Fresco 示例应用中的 [DraweeHierarchyFragment](https://github.com/facebook/fresco/blob/master/samples/showcase/src/main/java/com/facebook/fresco/samples/showcase/drawee/DraweeHierarchyFragment.java) 演示了使用占位图，失败图和重试图的例子。

![占位图，失败图和重试图的示例](/static/images/docs/01-placeholder-sample.png)
