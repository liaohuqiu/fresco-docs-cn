---
docid: animations
title: 动画支持
layout: docs
permalink: /docs/animations.html
prev: progressive-jpegs.html
next: requesting-multiple-images.html
---

Fresco 支持 GIF 和 WebP 格式的动画图片。

对于 WebP 格式的动画图的支持包括扩展的 WebP 格式，即使在 Android 2.3 及其以前那些没有原生 WebP 支持的系统。

### 设置动画图自动播放

如果你希望图片下载完之后自动播放，同时，当View从屏幕移除时，停止播放，只需要在 [image request](image-requests.html) 中简单设置，如下:


```java
Uri uri;
DraweeController controller = Fresco.newDraweeControllerBuilder()
    .setUri(uri)
    .setAutoPlayAnimations(true)
    . // 其他设置（如果有的话）
    .build();
mSimpleDraweeView.setController(controller);
```
### 手动控制动画图播放

也许你希望在代码中直接控制动画的播放。这种情况下，你需要监听图片是否加载完毕，然后才能控制动画的播放：

```java
ControllerListener controllerListener = new BaseControllerListener<ImageInfo>() {
    @Override
    public void onFinalImageSet(
        String id,
        @Nullable ImageInfo imageInfo,
        @Nullable Animatable anim) {
        if (anim != null) {
          // 其他控制逻辑
          anim.start();
        }
    }
};

Uri uri;
DraweeController controller = Fresco.newDraweeControllerBuilder()
    .setUri(uri)
    .setControllerListener(controllerListener)
    // 其他设置（如果有的话）
    .build();
mSimpleDraweeView.setController(controller);
```


另外，controller提供对[Animatable](http://developer.android.com/reference/android/graphics/drawable/Animatable.html) 的访问。

如果有可用动画的话，可对动画进行灵活的控制:

```java
Animatable animatable = mSimpleDraweeView.getController().getAnimatable();
if (animatable != null) {
  animatable.start();
  // later
  animatable.stop();
}
```

### 限制

动画现在还不支持 [postprocessors](modifying-image.html) 。
