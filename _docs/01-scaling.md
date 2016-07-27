---
docid: scaling
title: 缩放
layout: docs
permalink: /docs/scaling.html
prev: progress-bars.html
next: rounded-corners-and-circles.html
---

对于 Drawee 的[各种效果配置](drawee-branches.html)，其中一些是支持缩放类型的。

### 可用的缩放类型

| 类型 | 描述 |
| --------- | ----------- |
| center | 居中，无缩放。 |
| centerCrop | 保持宽高比缩小或放大，使得两边都大于或等于显示边界，且宽或高契合显示边界。居中显示。|
| [focusCrop](#focusCrop) | 同centerCrop, 但居中点不是中点，而是指定的某个点。|
| centerInside | 缩放图片使两边都在显示边界内，居中显示。和 `fitCenter` 不同，不会对图片进行放大。<br/>如果图尺寸大于显示边界，则保持长宽比缩小图片。|
| fitCenter | 保持宽高比，缩小或者放大，使得图片完全显示在显示边界内，且宽或高契合显示边界。居中显示。|
| fitStart | 同上。但不居中，和显示边界左上对齐。|
| fitEnd | 同fitCenter， 但不居中，和显示边界右下对齐。|
| fitXY | 不保存宽高比，填充满显示边界。|
| [none](#none) | 如要使用tile mode显示, 需要设置为none|

这些缩放类型和Android [ImageView](http://developer.android.com/reference/android/widget/ImageView.ScaleType.html) 支持的缩放类型几乎一样.

唯一不支持的缩放类型是 `matrix`。Fresco 提供了 `focusCrop` 作为补充，通常这个使用效果更佳。

### 怎样设置
实际图片，占位图，重试图和失败图都可以在 xml 中进行设置，用 `fresco:actualImageScaleType` 这样的属性。你也可以使用 `GenericDraweeHierarchyBuilder` 类在代码中进行设置。
即使显示效果已经构建完成，实际图片的缩放类型仍然可以通过 `GenericDraweeHierarchy` 类在运行中进行修改。
不要使用 `android:scaleType` 属性，也不要使用 `setScaleType()` 方法，它们对 Drawees 无效。

### focusCrop

`centerCrop`缩放模式会保持长宽比，放大或缩小图片，填充满显示边界，居中显示。这个缩放模式在通常情况下很有用。

但是对于人脸等图片时，一味地居中显示，这个模式可能会裁剪掉一些有用的信息。

以人脸图片为例，借助一些类库，我们可以识别出人脸所在位置。如果可以设置以人脸位置居中裁剪显示，那么效果会好很多。

Fresco的focusCrop缩放模式正是为此而设计。只要提供一个居中聚焦点，显示时就会**尽量**以此点为中心。

居中点是以相对方式给出的，比如 (0f, 0f) 是左上对齐显示，(1f, 1f) 是右下角对齐。相对坐标使得居中点位置和具体尺寸无关，这是非常实用的。

(0.5f, 0.5f) 的居中点位置和缩放类型 `centerCrop` 是等价的。 

如果要使用此缩放模式，首先在 XML 中指定缩放模式:

```xml
  fresco:actualImageScaleType="focusCrop"
```

在Java代码中，给你的图片指定居中点：

```java
PointF focusPoint;
// your app populates the focus point
mSimpleDraweeView
    .getHierarchy()
    .setActualImageFocusPoint(focusPoint);
```

### 自定义 SacleType

有时候现有的 ScaleType 不符合你的需求，我们允许你通过实现 `ScalingUtils.ScaleType` 来拓展它，这个接口里面只有一个方法：`getTransform`，它会基于以下参数来计算转换矩阵：

* parent bounds (View 坐标系中对图片的限制区域)
* child size （要放置的图片高宽）
* focus point （图片坐标系中的聚焦点位置）

当然，你的类里面应该包含了你需要额外信息。

我们来看一个例子，假设 View 应用了一些 padding， `parentBounds` 为 `(100, 150, 500, 450)`， 图片大小为`(420,210)`。那么我们知道 View 的宽度度为 `500 - 100 = 400`， 高度为 `450 - 150 = 300`。那么如果我们不做任何处理，图片在 View 坐标系中就会被画在`(0, 0, 420, 210)`。但是 `ScaleTypeDrawable` 会使用 `parentBounds` 来进行限制，那么画布就会被 `(100, 150, 500, 450)` 这块矩阵裁切，那么最后图片显示区域就是 `(100, 150, 420, 210)`。

为了避免这种情况，我们可以变换 `(parentBounds.left, parentBounds.top)` （在这个例子中是`(100, 150)`）。现在图片比 View 还宽，现在无论是将图片放置在 `(100, 150, 500, 360)` 还是 `(0, 0, 400, 210)`，我们都会损失右侧20像素的宽度。

那么我们可以将它缩小一点（`400/420`的缩放比例），让它能够放置在 View 给它分配的区域中(缩放后变成了`400, 200`)。那么现在宽度刚刚好，但是高度却不是了。

我们需要进一步处理，我们可以算一下高度还剩余的空间 `300 - 200 = 100`。我们可以将他们平均分配在上下两侧，这样图片就被居中了，真棒！你可以通过实现 `FIT_CENTER` 来让它做到这点。那么来看代码吧：

```java
  public static abstract class AbstractScaleType implements ScaleType {
    @Override
    public Matrix getTransform(Matrix outTransform, Rect parentRect, int childWidth, int childHeight, float focusX, float focusY) {
      // 取宽度和高度需要缩放的倍数中最大的一个
      final float sX = (float) parentRect.width() / (float) childWidth;
      final float sY = (float) parentRect.height() / (float) childHeight;
      float scale = Math.min(scaleX, scaleY);
      
      // 计算为了均分空白区域，需要偏移的x、y方向的距离
      float dx = parentRect.left + (parentRect.width() - childWidth * scale) * 0.5f;
      float dy = parentRect.top + (parentRect.height() - childHeight * scale) * 0.5f;
      
      // 最后我们应用它
      outTransform.setScale(scale, scale);
      outTransform.postTranslate((int) (dx + 0.5f), (int) (dy + 0.5f));
      return outTransform;
    }
  }
```

### none

如果你要使用tile mode进行显示，那么需要将scale type 设置为none.

