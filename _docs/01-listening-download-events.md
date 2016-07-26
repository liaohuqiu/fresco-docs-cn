---
docid: listening-download-events
title: 监听下载事件
layout: docs
permalink: /docs/listening-download-events.html
prev: requesting-multiple-images.html
next: resizing-rotating.html
---

## 动机

你也许想在图片下载完成后执行一些动作，比如使某个别的 `View` 可见，或者显示一些文字。你也许还想在下载失败后做一些事，比如向用户显示一条失败信息。

图片是后台线程异步加载的，所以你需要某一方式来监听 `DraweeController` 传递的事件。我们可以使用一个 `ControllerListener` 实现事件的监听。

*在监听事件回调时，无法修改图片，如果需要修改图片，可使用[后处理器(Postprocessor)](modifying-image.html)*


## 使用方法

简单定义一个`ControllerListener`即可，推荐继承`BaseControllerListener`:

```java
ControllerListener controllerListener = new BaseControllerListener<ImageInfo>() {
    @Override
    public void onFinalImageSet(
        String id,
        @Nullable ImageInfo imageInfo,
        @Nullable Animatable anim) {
      if (imageInfo == null) {
        return;
      }
      QualityInfo qualityInfo = imageInfo.getQualityInfo();
      FLog.d("Final image received! " +
          "Size %d x %d",
          "Quality level %d, good enough: %s, full quality: %s",
          imageInfo.getWidth(),
          imageInfo.getHeight(),
          qualityInfo.getQuality(),
          qualityInfo.isOfGoodEnoughQuality(),
          qualityInfo.isOfFullQuality());
    }

    @Override
    public void onIntermediateImageSet(String id, @Nullable ImageInfo imageInfo) {
      FLog.d("Intermediate image received");
    }

    @Override
    public void onFailure(String id, Throwable throwable) {
      FLog.e(getClass(), throwable, "Error loading %s", id)
    }
};

Uri uri;
DraweeController controller = Fresco.newDraweeControllerBuilder()
    .setControllerListener(controllerListener)
    .setUri(uri)
    // other setters
    .build();
mSimpleDraweeView.setController(controller);
```

所有的图片加载，`onFinalImageSet` 或者 `onFailure` 都会被触发。前者在成功时，后者在失败时。

如果允许呈现[渐进式JPEG](progressive-jpegs.html)，同时图片也是渐进式图片，`onIntermediateImageSet`会在每个扫描被解码后回调。具体图片的那个扫描会被解码，参见[渐进式JPEG图](progressive-jpegs.html)
