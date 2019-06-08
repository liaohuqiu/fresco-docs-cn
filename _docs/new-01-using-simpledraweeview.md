---
docid: using-simpledraweeview
title: 使用 SimpleDraweeView
layout: docs
permalink: /docs/using-simpledraweeview.html
prev: proguard.html
next: rounded-corners-and-circles.html
redirect_from:
  - /docs/using-drawees-xml.html
  - /docs/using-drawees-code.htm
---

使用 Fresco 时，你需要用 `SimpleDraweeView` 来显示图片。它可以在 XML 布局中使用，下面是一个使用 `SimpleDraweeView` 的最简单的例子：

```xml
<com.facebook.drawee.view.SimpleDraweeView
  android:id="@+id/my_image_view"
  android:layout_width="20dp"
  android:layout_height="20dp"
  />
```

**注意：** `SimpleDraweeView` 不支持对 `layout_width` 或 `layout_height` 属性设置 `wrap_content` 的属性值。更多信息可以在[这里](faq.html)了解到。 关于这点有一个例外情况，仅当你对 `SimpleDraweeView` 设置了纵横比时，才可设置 `wrap_content` 属性，就像下面这样：

```xml
<com.facebook.drawee.view.SimpleDraweeView
    android:id="@+id/my_image_view"
    android:layout_width="20dp"
    android:layout_height="wrap_content"
    fresco:viewAspectRatio="1.33"
    />
```

### 加载图片

加载图片到 `SimpleDraweeView` 中的最简单的方法就是调用 `setImageURI`：

```java
mSimpleDraweeView.setImageURI(uri);
```

就这样，你现在正在用 Fresco 显示图片呢！

### 更多 XML 属性

`SimpleDraweeView` 可不像它的名字那样简单，它支持大量的自定义 XML 属性，下面的例子展示了所有的自定义属性：

```xml
<com.facebook.drawee.view.SimpleDraweeView
  android:id="@+id/my_image_view"
  android:layout_width="20dp"
  android:layout_height="20dp"
  fresco:fadeDuration="300"
  fresco:actualImageScaleType="focusCrop"
  fresco:placeholderImage="@color/wait_color"
  fresco:placeholderImageScaleType="fitCenter"
  fresco:failureImage="@drawable/error"
  fresco:failureImageScaleType="centerInside"
  fresco:retryImage="@drawable/retrying"
  fresco:retryImageScaleType="centerCrop"
  fresco:progressBarImage="@drawable/progress_bar"
  fresco:progressBarImageScaleType="centerInside"
  fresco:progressBarAutoRotateInterval="1000"
  fresco:backgroundImage="@color/blue"
  fresco:overlayImage="@drawable/watermark"
  fresco:pressedStateOverlayImage="@color/red"
  fresco:roundAsCircle="false"
  fresco:roundedCornerRadius="1dp"
  fresco:roundTopLeft="true"
  fresco:roundTopRight="false"
  fresco:roundBottomLeft="false"
  fresco:roundBottomRight="true"
  fresco:roundTopStart="false"
  fresco:roundTopEnd="false"
  fresco:roundBottomStart="false"
  fresco:roundBottomEnd="false"
  fresco:roundWithOverlayColor="@color/corner_color"
  fresco:roundingBorderWidth="2dp"
  fresco:roundingBorderColor="@color/border_color"
  />
```

### 使用代码自定义显示效果

通常更推荐在 XML 中设置这些选项，但所有的属性都能通过代码设置。为了自定义显示效果，你需要在设置图片的 URI 之前创建一个 `DraweeHierarchy`:

```java
GenericDraweeHierarchy hierarchy =
    GenericDraweeHierarchyBuilder.newInstance(getResources())
        .setActualImageColorFilter(colorFilter)
        .setActualImageFocusPoint(focusPoint)
        .setActualImageScaleType(scaleType)
        .setBackground(background)
        .setDesiredAspectRatio(desiredAspectRatio)
        .setFadeDuration(fadeDuration)
        .setFailureImage(failureImage)
        .setFailureImageScaleType(scaleType)
        .setOverlays(overlays)
        .setPlaceholderImage(placeholderImage)
        .setPlaceholderImageScaleType(scaleType)
        .setPressedStateOverlay(overlay)
        .setProgressBarImage(progressBarImage)
        .setProgressBarImageScaleType(scaleType)
        .setRetryImage(retryImage)
        .setRetryImageScaleType(scaleType)
        .setRoundingParams(roundingParams)
        .build();
mSimpleDraweeView.setHierarchy(hierarchy);
mSimpleDraweeView.setImageURI(uri);
```

**注意：** 一些属性可以被设置到已存在的层级（hierarchy）上，而不用新建一个层级。于是，你可以轻松地从 `SimpleDraweeView` 拿到已存在的层级，并对它调用任何 setter 方法：

```java
mSimpleDraweeView.getHierarchy().setPlaceHolderImage(placeholderImage);
```

### 完整示例

完整示例请参阅示例应用中的 `DraweeSimpleFragment`：[DraweeSimpleFragment.java](https://github.com/facebook/fresco/blob/master/samples/showcase/src/main/java/com/facebook/fresco/samples/showcase/drawee/DraweeSimpleFragment.java)

![使用缩放类型的示例图片](/static/images/docs/01-using-simpledraweeview-sample.png)
