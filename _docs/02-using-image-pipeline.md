---
docid: using-image-pipeline
title: 直接使用Image Pipeline
layout: docs
permalink: /docs/using-image-pipeline.html
prev: caching.html
next: datasources-datasubscribers.html
---

本页介绍Image pipeline的高级用法，大部分的应用使用[Drawees](using-drawees-xml.html) 和image pipeline打交道就好了。

直接使用Image pipeline是较为有挑战的事情，这意味着要维护图片的内存使用。Drawees
会根据各种情况确定图片是否需要在内存缓存中，在需要时加载，在不需要时移除。直接使用的话，你需要自己完成这些逻辑。

Image pipeline返回的是一个[CloseableReference](closeable-references.html)对象。在这些对象不需要时，Drawees会调用`.close()`方法。如果你的应用不使用Drawees，那你需要自己完成这个事情。

Java的GC机制会在Bitmap不使用时，清理掉Bitmap。但要GC时总是太迟了，另外GC是很昂贵的开销。GC大对象也会带来性能问题，尤其是在5.0以下系统。

#### 调用 pipeline

首先[创建一个image request](image-requests.html). 然后传递给 `ImagePipeline:`

```java
ImagePipeline imagePipeline = Fresco.getImagePipeline();
DataSource<CloseableReference<CloseableImage>>
    dataSource = imagePipeline.fetchDecodedImage(imageRequest, callerContext);
```

关于如果接收数据，请参考[数据源](datasources-datasubscribers.html) 章节。

#### 忽略解码

如果你不保持图片原始格式，不执行解码，使用`fetchEncodedImage`即可:

```java
DataSource<CloseableReference<PooledByteBuffer>>
    dataSource = imagePipeline.fetchEncodedImage(imageRequest, callerContext);
```

#### 从Bitmap缓存中立刻取到结果

不像其他缓存，如果图片在内存缓存中有的话，可以在UI线程立刻拿到结果。

```java
DataSource<CloseableReference<CloseableImage>> dataSource =
    imagePipeline.fetchImageFromBitmapCache(imageRequest, callerContext);
try {
  CloseableReference<CloseableImage> imageReference = dataSource.getResult();
  if (imageReference != null) {
    try {
      // Do something with the image, but do not keep the reference to it!
      // The image may get recycled as soon as the reference gets closed below.
      // If you need to keep a reference to the image, read the following sections.
    } finally {
      CloseableReference.closeSafely(imageReference);
    }
  } else {
    // cache miss
    ...
  }
} finally {
  dataSource.close();
}
```

千万 **不要** 省略掉 `finally` 中的代码!

#### 预加载图片

预加载图片可减少用户等待的时间，如果预加载的图片用户没有真正呈现给用户，那么就浪费了用户的流量，电量，内存等资源了。大多数应用，并不需要预加载。

需要注意的是，你可以预加载图片到磁盘、内存缓存中，但是它们在并不会被立即解码（除非马上要显示），这样会节省一部分CPU操作。

预加载到磁盘缓存:

```java
imagePipeline.prefetchToDiskCache(imageRequest, callerContext);
```

预加载到内存缓存:

```java
imagePipeline.prefetchToBitmapCache(imageRequest, callerContext);
```

取消预加载:

```java
DataSource<Void> prefetchDataSource = imagePipeline.prefetchTo...;
prefetchDataSource.close();
```

取消一个预加载已经完成的数据源是无效的，不过如果你一定要这么做，也不会发生问题。

#### callerContext

你会发现所有的`ImagePipeline`获取时都会加上一个`callerContext`，它的类型是`Object`。你可以把他堪称一个[上下文设计模式](https://www.dre.vanderbilt.edu/~schmidt/PDF/Context-Object-Pattern.pdf)。它主要的目的是为了让`ImageRequest`能够有更多扩展用途（比如打Log）。这个对象可以被所有`ImagePipeline`中实现的`Producer`获取到。


