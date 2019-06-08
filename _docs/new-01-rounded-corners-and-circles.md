---
docid: rounded-corners-and-circles
title: 圆角和圆形
layout: docs
permalink: /docs/rounded-corners-and-circles.html
prev: using-simpledraweeview.html
next: using-controllerbuilder.html
---

不是每一张图都是矩形。应用经常需要让图片有圆角或者变成圆形来显得更柔和，Drawee 可以轻松支持圆角、圆形等多种场景，并且不会有复制 Bitmap 对象的额外内存开销。

## 圆角的呈现方式

圆角实际有 2 种呈现方式:

1. 圆形 - 设置 `roundAsCircle` 为 true。
2. 圆角矩形 - 设置 `roundedCornerRadius` 为某个值。

设置为圆角矩形时，4 个角可以为不同的半径。但这仅可在 Java 代码中设置，而不是 XML 中设置。

### 如何设置圆角

可使用以下两种方式:

1. `BITMAP_ONLY` - 使用位图的 shader 来绘制带有圆角的位图。这是默认的绘制圆角的方法。这种方式不支持动画，并且**不支持**任何除了 `centerCrop`（默认）, `focusCrop` 和 `fit_xy` 之外的缩放类型。 如果你使用这种设置圆角的方法，并且使用了其他缩放类型，如 `center`，你不会得到异常信息，但是图片看上去也许不是你所期望的那样（可能由于 Android 中 shader 的工作原理而出现重复的边缘），特别是当原始图片小于 View 时。更多介绍请参阅本节末尾的警告。
2. `OVERLAY_COLOR` - 通过对覆盖层指定的不透明色来绘制圆角。Drawee 的背景需要固定成相同的不透明色。可以在 XML 中指定 `roundWithOverlayColor`, 或者通过调用 `setOverlayColor` 方法来完成此设定。

### 在 XML 中设置

`SimpleDraweeView` 支持如下几种圆角属性:

```xml
<com.facebook.drawee.view.SimpleDraweeView
   ...
   fresco:roundedCornerRadius="5dp"
   fresco:roundBottomLeft="false"
   fresco:roundBottomRight="false"
   fresco:roundWithOverlayColor="@color/blue"
   fresco:roundingBorderWidth="1dp"
   fresco:roundingBorderColor="@color/red"
```

### 代码中设置

在创建 [DraweeHierarchy](using-simpledraweeview.html) 时，可以给 `GenericDraweeHierarchyBuilder` 指定一个 [RoundingParams](../javadoc/reference/com/facebook/drawee/generic/RoundingParams.html) 实例用来绘制圆角效果。

```java
int overlayColor = getResources().getColor(R.color.green);
RoundingParams roundingParams = RoundingParams.fromCornersRadius(7f);
mSimpleDraweeView.setHierarchy(new GenericDraweeHierarchyBuilder(getResources())
        .setRoundingParams(roundingParams)
        .build());
```

你也可以在层级构建好后修改所有的圆形参数：

```java
int color = getResources().getColor(R.color.red);
RoundingParams roundingParams = RoundingParams.fromCornersRadius(5f);
roundingParams.setBorder(color, 1.0f);
roundingParams.setRoundAsCircle(true);
mSimpleDraweeView.getHierarchy().setRoundingParams(roundingParams);
```

### 警告

当使用 `BITMAP_ONLY`（默认）模式时的限制：

- 只有 `BitmapDrawable` 和 `ColorDrawable` 类型的图片可以实现圆角。我们目前不支持包括 `NinePatchDrawable` 和 `ShapeDrawable` 在内的其他类型图片。（无论它们是在 XML 或是程序中指定的）
- 动图不能被圆角化。
- 由于 Android 的 `BitmapShader` 的限制，当一个图片不能覆盖全部的 View 时候，边缘部分会被重复显示，而非留白。对这种情况可以使用不同的缩放类型（比如 centerCrop）来保证图片覆盖了整个 View。另一种解决办法是使用包含 1px 透明边框的图片文件，以便重复边缘的透明像素。这是 PNG 图像的最佳解决方案。

如果对 `BITMAP_ONLY` 模式的限制影响到你的图片显示，请考虑使用 `OVERLAY_COLOR` 模式。该模式没有上述限制，但由于该模式采用在图片上覆盖一个纯色图层的方式来模拟圆角效果，因此只有在图片背景是静止的并且与覆盖层同色的情况下才会看起来一切正常。

Drawee 内部实现了一个 `CLIPPING` 模式。但由于有些 `Canvas` 的实现并不支持路径剪裁（Path Clipping），因此这个模式被禁用了且不对外开放。而且由于路径剪裁不支持抗锯齿，会导致圆角的边缘呈现像素化的效果。

最后，如果使用生成临时 bitmap 的方法，上述所有问题都可以避免。但是这个方法并不被支持，因为这会导致很严重的内存问题。

综上所述，在 Android 中没有一个实现圆角效果的完美方案，你必须在上述的方案中进行选择。

### 完整示例

在示例应用中的 `DraweeRoundedCornersFragment` 可看到完整示例： [DraweeRoundedCornersFragment.java](https://github.com/facebook/fresco/blob/master/samples/showcase/src/main/java/com/facebook/fresco/samples/showcase/drawee/DraweeRoundedCornersFragment.java)

![使用缩放类型的示例图片](/static/images/docs/01-rounded-corners-and-circles-sample.png)