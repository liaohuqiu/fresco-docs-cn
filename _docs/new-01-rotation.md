---
docid: rotation
title: 旋转
layout: docs
permalink: /docs/rotation.html
prev: placeholder-failure-retry.html
next: resizing.html
---

你可以在图片请求中指定旋转角度来旋转图片，如下所示：

```java
final ImageRequest imageRequest = ImageRequestBuilder.newBuilderWithSource(uri)
    .setRotationOptions(RotationOptions.forceRotation(RotationOptions.ROTATE_90))
    .build();
mSimpleDraweeView.setController(
    Fresco.newDraweeControllerBuilder()
        .setImageRequest(imageRequest)
        .build());
```

### 自动旋转

JPEG 文件有时将方向信息存储在图片的元数据中。如果你希望图片自动旋转以匹配设备的方向，你可以在图片请求中执行这个操作：

```java
final ImageRequest imageRequest = ImageRequestBuilder.newBuilderWithSource(uri)
    .setRotationOptions(RotationOptions.autoRotate())
    .build();
mSimpleDraweeView.setController(
    Fresco.newDraweeControllerBuilder()
        .setImageRequest(imageRequest)
        .build());
```

### 组合旋转

如果你加载的是 EXIF 数据中包含了旋转信息的 JPEG 文件，调用 `forceRotaion` 会将其 **添加** 到图片默认的旋转信息中。例如，如果 EXIF 头指定了旋转 90 度，当你调用 `forceRotation(ROTATE_90)` 后，原图片将被旋转 180 度。

### Examples

示例应用中的 [DraweeRotationFragment](https://github.com/facebook/fresco/blob/master/samples/showcase/src/main/java/com/facebook/fresco/samples/showcase/drawee/DraweeRotationFragment.java) 演示了多种旋转设置。你可以使用此处的 [示例图片](https://github.com/recurser/exif-orientation-examples)。

![实例应用中关于旋转的例子](/static/images/docs/01-rotation-sample.png)
