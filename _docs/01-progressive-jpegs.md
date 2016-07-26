---
docid: progressive-jpegs
title: 渐进式JPEG图
layout: docs
permalink: /docs/progressive-jpegs.html
prev: using-controllerbuilder.html
next: animations.html
---

Fresco 支持渐进式的网络JPEG图。在开始加载之后，图会从模糊到清晰渐渐呈现。

你可以设置一个清晰度标准，在未达到这个清晰度之前，会一直显示占位图。

渐进式JPEG图仅仅支持网络图。本地图片会一次解码完成，所以没必要渐进式加载。你还需要知道的是，并不是所有的JPEG图片都是渐进式编码的，所以对于这类图片，不可能做到渐进式加载。

## 配置

目前[配置Image pipeline时](configure-image-pipeline.html) 需要手动开启渐进式加载：

```java
Uri uri;
ImageRequest request = ImageRequestBuilder.newBuilderWithSource(uri)
    .setProgressiveRenderingEnabled(true)
    .build();
DraweeController controller = Fresco.newDraweeControllerBuilder()
    .setImageRequest(request)
    .setOldController(mSimpleDraweeView.getController())
    .build();
mSimpleDraweeView.setController(controller);
```

我们希望在后续的版本中，在`setImageURI`方法中可以直接支持渐进式图片加载。
