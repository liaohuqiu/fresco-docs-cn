---
id: modifying-image
title: 修改图片
layout: docs
permalink: /docs/modifying-image.html
prev: resizing-rotating.html
next: image-requests.html
---

### 动机

有时，我们想对从服务器下载，或者本地获取的图片做些修改，比如在某个坐标统一加个网格什么的。你可以使用 `Postprocessor`，最好的方式是继承 [BasePostprocessor](../javadoc/reference/com/facebook/imagepipeline/request/BasePostprocessor.html)。

### 例子

下面的例子给图片加了红色网格：

```java
Uri uri;
Postprocessor redMeshPostprocessor = new BasePostprocessor() { 
  @Override
  public String getName() {
    return "redMeshPostprocessor";
  }
  
  @Override
  public void process(Bitmap bitmap) {
    for (int x = 0; x < bitmap.getWidth(); x+=2) {
      for (int y = 0; y < bitmap.getHeight(); y+=2) {
        bitmap.setPixel(x, y, Color.RED);
      }
    }
  }
}

ImageRequest request = ImageRequestBuilder.newBuilderWithSource(uri)
    .setPostprocessor(redMeshPostprocessor)
    .build();
    
PipelineDraweeController controller = (PipelineDraweeController) 
    Fresco.newDraweeControllerBuilder()
    .setImageRequest(request)
    .setOldController(mSimpleDraweeView.getController())
    // other setters as you need
    .build();
mSimpleDraweeView.setController(controller);
```

### 注意点

图片在进入后处理器(postprocessor)的图片是原图的一个完整拷贝，原来的图片不受修改的影响。在5.0以前的机器上，拷贝后的图片也在native内存中。

在开始一个图片显示时，即使是反复显示同一个图片，在每次进行显示时，都需要指定后处理器。对于同一个图片，每次显示可以使用不同的后处理器。

后处理器现在不支持动画图片。

### 复制 bitmap

可能会出现即时的后处理无法实现的情况。如果出现该情况，`BasePostprocessor` 还有一个接收两个参数的 process 方法。下面的例子实现了水平翻转图片：

```java
@Override
public void process(Bitmap destBitmap, Bitmap sourceBitmap) {
  for (int x = 0; x < destBitmap.getWidth(); x++) {
    for (int y = 0; y < destBitmap.getHeight(); y++) {
      destBitmap.setPixel(destBitmap.getWidth() - x, y, sourceBitmap.getPixel(x, y));
    }
  }
}
```

源图片和目标图片具有相同的大小。

 - 不要修改源图片。在未来的版本中这会抛出一个异常。
 - 不要保存对任何一个图片的引用。它们的内存会由 image pipeline 进行管理，目标图片会在 Drawww 或 DataSource 中正常地销毁。

### 复制成不同大小

如果处理后的图片大小需要和原图片不同，我们有第三个 process 方法。你可以使用 `PlatformBitmapFactory` 类以指定的大小安全地创建一张图片，在 Java Heap 之外。

下面的例子将源图片复制为 1 / 4 大小。

```Java
@Override
public CloseableReference<Bitmap> process(
    Bitmap sourceBitmap,
    PlatformBitmapFactory bitmapFactory) {
  CloseableReference<Bitmap> bitmapRef = bitmapFactory.createBitmap(
      sourceBitmap.getWidth() / 2,
      sourceBitmap.getHeight() / 2);
  try {
    Bitmap destBitmap = bitmapRef.get();
     for (int x = 0; x < destBitmap.getWidth(); x+=2) {
       for (int y = 0; y < destBitmap.getHeight(); y+=2) {
         destBitmap.setPixel(x, y, sourceBitmap.getPixel(x, y));
       }
     }
     return CloseableReference.cloneOrNull(bitmapRef);
  } finally {
    CloseableReference.closeSafely(bitmapRef);
  } 
}
```

你必须遵循 [closeable references](../docs/closeable-references.html) 的规则。

**不要使用** Android 中 Bitmap.createBitmap() 方法，它会在 Java 堆内存中产生一个 bitmap 对象。

### 应该 Override 哪个方法？

不要重写多于 1 个的 process 方法。这么做可能造成无法预测的结果。

### 缓存处理后的图片

你可以选择性地缓存后处理器的输出结果。它会和原始图片一起放在缓存里。

如果要这样做，你的后处理器必须实现 `getPostprocessorCacheKey` 方法，并返回一个非空的结果。

为实现缓存命中，随后的请求中使用的后处理器必须是同一个类并返回同样的键。否则，它的返回结果将会覆盖之前缓存的条目。

例子：

``` java
public class OperationPostprocessor extends BasePostprocessor {
  private int myParameter;

  public OperationPostprocessor(int param) {
    myParameter = param;
  }

  public void process(Bitmap bitmap) { 
    doSomething(myParameter);
  }

  public CacheKey getPostprocessorCacheKey() {
    return new MyCacheKey(myParameter);
  }
}
```

如果你想要缓存总是命中，只需在 `getPostprocessorCacheKey` 中返回一个常量值。如果你的 `postprocessor` 总是返回不同的结果，而你也不想要缓存命中，返回 null。

### 重复的后处理

如果想对同一个图片进行多次后处理，那么继承[BaseRepeatedPostprocessor](../javadoc/reference/com/facebook/imagepipeline/request/BaseRepatedPostprocessor.html)即可。该类有一个`update`方法，需要执行后处理时，调用该方法即可。

下面的例子展示了在运行时，后处理改变图片网格的颜色:

```java
public class MeshPostprocessor extends BaseRepeatedPostprocessor { 
  private int mColor = Color.TRANSPARENT;

  public void setColor(int color) {
    mColor = color;
    update();
  }
  
  @Override
  public String getName() {
    return "meshPostprocessor";
  }
  
  @Override
  public void process(Bitmap bitmap) {
    for (int x = 0; x < bitmap.getWidth(); x+=2) {
      for (int y = 0; y < bitmap.getHeight(); y+=2) {
        bitmap.setPixel(x, y, mColor);
      }
    }
  }
}
MeshPostprocessor meshPostprocessor = new MeshPostprocessor();

// setPostprocessor as in above example

// 改变颜色
meshPostprocessor.setColor(Color.RED);
meshPostprocessor.setColor(Color.BLUE);
```

每个 image request, 应该只有一个`Postprocessor`，但是这个后处理器是状态相关了。

### 透明的图片

根据 postprocessor 的性质，目标图片不会永远是完全不透明的。由于 `Bitmap.hasAlpha` 方法的返回值，这有时会导致问题。也就是说如果该方法返回 false(默认值)，Android 会选择不进行混合地快速绘制。这会导致出现一张用黑色代替透明像素的半透明图片。为了解决这一问题，将目标图片中该值设为 true。

```java
destinationBitmap.setHasAlpha(true);
```