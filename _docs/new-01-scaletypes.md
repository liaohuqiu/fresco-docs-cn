---
docid: scaletypes
title: 缩放类型
layout: docs
permalink: /docs/scaletypes.html
prev: progress-bars.html
next: placeholder-failure-retry.html
---

你可以对 Drawee 中不同的 `drawables` 使用不同的缩放类型。

### 可用的缩放类型

| 缩放类型              | 保持纵横比 | 总是充满整个 View | 是否缩放 | 说明 |
| ---------               | :-:                    | :-:               | :-:              | ----------- |
| center                  | ✓                      |                   |                  | 居中，无缩放。 |
| centerCrop              | ✓                      | ✓                 | ✓                | 保持纵横比缩小或放大，使得两边都大于或等于<br/>视图边界，其中宽或高与视图边界<br/>完全契合。居中显示。 |
| focusCrop               | ✓                      | ✓                 | ✓                | 同centerCrop, 但居中点不是中点，而是某个指定的焦点。|
| centerInside            | ✓                      |                   | ✓                | 如果图片大小超过视图边界，保持纵横比地缩小<br/>图片使之完全在视图区域内与<br/> `fitCenter` 不同，不会对图片进行放大。 |
| fitCenter               | ✓                      |                   | ✓                | 保持纵横比缩放图片，使之完全在视图区域内，<br/>其中宽或高与视图边界完全契合。<br/>图片在视图区域内居中。|
| fitStart                | ✓                      |                   | ✓                | 保持纵横比缩放图片，使之完全在视图区域内，<br/>其中宽或高与视图边界完全契合。<br/>图片对齐视图区域左上角。|
| fitEnd                  | ✓                      |                   | ✓                | 保持纵横比缩放图片，使之完全在试图区域内，<br/>其中宽或高与视图边界完全契合。<br/>图片对齐视图区域右下角。 |
| fitXY                   |                        | ✓                 | ✓                | 独立缩放宽高，使图片刚好充满视图。|
| none                    | ✓                      |                   |                  | 用于 Android 的 tile mode. |

这些缩放类型和 Android [ImageView](http://developer.android.com/reference/android/widget/ImageView.ScaleType.html) 支持的缩放类型几乎一样。唯一不支持的缩放类型是 `matrix`。Fresco 提供了 `focusCrop` 作为补充，通常这个使用效果更佳。

### 怎样设置缩放类型

实际图、占位图、重试图、失败图的缩放类型都可以在 XML 中使用像 `fresco:actualImageScaleType` 这样的属性设置。你也可以在代码中使用 [GenericDraweeHierarchyBuilder](../javadoc/reference/com/facebook/drawee/generic/GenericDraweeHierarchyBuilder.html) 类来设置它们。

即使在你的层级已经构建完成，也可通过 [GenericDraweeHierarchy](../javadoc/reference/com/facebook/drawee/generic/GenericDraweeHierarchy.html) 动态修改实际图的缩放类型。

然而，不要使用 `android:scaleType` 属性，也不要使用 `setScaleType()` 方法，它们对 Drawees 无效。

### 缩放类型: "focusCrop"

Android, 和 Fresco, 都提供了 `centerCrop` 缩放类型, 它能保持纵横比地缩放图片使之填满整个视图，同时进行必要的裁剪。

该缩放类型非常有用，但问题是它裁剪的位置不一定在你想要裁减的地方。例如：你想要裁剪一张位于图片右下角的脸时，`centerCrop` 便不能满足。

通过指定一个居中点，你能够指定图片的哪个部分需要被放在视图的中心。如果你指定的居中点在图片的顶部，例如 (0.5f, 0f)，我们保证无论如何，该点将尽可能在视图内可见并居中。

居中点是以相对坐标的方式给出的，例如，(0f, 0f) 是指左上角，(1f, 1f) 是指右下角。相对坐标非常实用，它使得居中点不随坐标系尺寸变化而变化。

居中点为 (0.5f, 0.5f) 的效果与缩放类型 `centerCrop` 相同。

要使用这种缩放类型，你必须先在 XML 中设置相应的缩放类型：

```xml
  fresco:actualImageScaleType="focusCrop"
```

在 Java 代码中，给你的图片指定居中点：

```java
PointF focusPoint = new PointF(0f, 0.5f);
mSimpleDraweeView
    .getHierarchy()
    .setActualImageFocusPoint(focusPoint);
```

### 缩放类型: "none"

如果你正在使用的是使用了 Android 中 tile mode 的 Drawable，则需要使用缩放类型 `none` 才能保证它显示正确。

### 缩放类型: 自定义缩放类型

有时候现有的 ScaleType 不符合你的需求。Drawee 允许你通过简单地实现自己的 `ScalingUtils.ScaleType` 来自定义缩放类型。这个接口里面只有一个方法，`getTransform`，它会基于以下参数来计算转换矩阵：

* parent bounds (View 坐标系中，图片可以放置的区域)
* child size （图片的实际宽高）
* focus point （图片在坐标系中的居中点位置）

当然，你的类里面应该包含了你需要的额外数据。

我们来看一个例子，假设 View 应用了一些 padding， `parentBounds` 为 `(100, 150, 500, 450)`， 图片大小为 `(420,210)`。那么我们知道 View 的宽度度为 `500 - 100 = 400`， 高度为 `450 - 150 = 300`。如果我们不做任何处理，图片在 View 坐标系中就会被画在 `(0, 0, 420, 210)`。但是 `ScaleTypeDrawable` 会使用 `parentBounds` 来进行限制，那么画布就会被裁剪到 `(100, 150, 500, 450)` 这块矩阵内。这意味着只有图像的右下角才会被显示，其区域为：`(100, 150, 420, 210)`。

为了避免这种情况，我们可以变换 `(parentBounds.left, parentBounds.top)`，在这个例子中是 `(100, 150)`。现在图片右边部分被裁剪了，因为图片比 View 还宽。无论是将图片放置在 `(100, 150, 500, 360)` 还是 `(0, 0, 400, 210)`，我们都会损失右侧 20 像素的宽度。

为了避免图片被裁剪，我们可以将它缩小一点。我们已 `400/420` 的比例缩放，它将使得图片大小变为 `(400,200)`。
现在，图像水平方向完全契合了，但垂直方向仍然没有居中。

为了使图片居中，我们需要进一步处理。我们知道，现在在水平方向的剩余的空间为 `400 - 400 = 0`，垂直方向的剩余空间为 `300 - 200 = 100`。如果我们将水平方向剩余的空间分配到图片两侧，这样就使得图片居中了！

真棒！你已经实现了 `FIT_CENTER` 这种缩放类型：

```java
  public class AbstractScaleType implements ScaleType {
    @Override
    public Matrix getTransform(Matrix outTransform, Rect parentRect, int childWidth, int childHeight, float focusX, float focusY) {
      // calculate scale; we take the smaller of the horizontal and vertical scale factor so that the image always fits
      final float scaleX = (float) parentRect.width() / (float) childWidth;
      final float scaleY = (float) parentRect.height() / (float) childHeight;
      final float scale = Math.min(scaleX, scaleY);

      // calculate translation; we offset by parent bounds, and by half of the empty space
      // note that the child dimensions need to be adjusted by the scale factor
      final float dx = parentRect.left + (parentRect.width() - childWidth * scale) * 0.5f;
      final float dy = parentRect.top + (parentRect.height() - childHeight * scale) * 0.5f;

      // finally, set and return the transform
      outTransform.setScale(scale, scale);
      outTransform.postTranslate((int) (dx + 0.5f), (int) (dy + 0.5f));
      return outTransform;
    }
  }
```

### Full Sample

完整的例子见示例应用的 `DraweeScaleTypeFragment`: [DraweeScaleTypeFragment.java](https://github.com/facebook/fresco/blob/master/samples/showcase/src/main/java/com/facebook/fresco/samples/showcase/drawee/DraweeScaleTypeFragment.java)

![示例应用中关于缩放类型的例子一](/static/images/docs/01-scaletypes-sample-1.png)

![示例应用中关于缩放类型的例子二](/static/images/docs/01-scaletypes-sample-2.png)
