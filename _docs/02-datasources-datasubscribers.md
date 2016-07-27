---
docid: datasources-datasubscribers
title: 数据源和数据订阅者
layout: docs
permalink: /docs/datasources-datasubscribers.html
prev: using-image-pipeline.html
next: closeable-references.html
---

[数据源](http://frescolib.org/javadoc/reference/com/facebook/datasource/DataSource.html) 和 [Future](http://developer.android.com/reference/java/util/concurrent/Future.html), 有些相似，都是异步计算的结果。

不同点在于，数据源对于一个调用会返回一系列结果，Future只返回一个。


提交一个Image request之后，Image
pipeline返回一个数据源。从中获取数据需要使用[数据订阅者(DataSubscriber)](http://frescolib.org/javadoc/reference/com/facebook/datasource/DataSubscriber.html)。

### 执行器（Executor）

当你订阅一个数据源时，必须制定一个Executor去执行。它主要是为了让你在制定的线程调度机制上执行 Runnable。Fresco提供了一些[Executors](https://github.com/facebook/fresco/tree/0f3d52318631f2125e080d2a19f6fa13a31efb31/fbcore/src/main/java/com/facebook/common/executors)，你在使用它们的时候需要注意：

* 如果你想要在回调中进行任何UI操作，你需要使用`UiThreadImmediateExecutorService.getInstance()`。因为Android系统仅允许在UI线程中做一些UI操作。
* 如果回调里面做的事情比较少，并且不涉及UI，你可以使用`CallerThreadExecutor.getInstance()`。这个 Executor 会在调用者线程中执行回调。这个回调的执行线程是得不到保证的，所以需要谨慎使用这个Executor。重申一遍，只有少量工作、没有UI操作的回调才适合在这个Executor中操作。
* 你需要做一些比较复杂、耗时的操作，并且不涉及UI（如数据库读写、文件IO），你就**不能用上面两个Executor**。你需要开启一个后台Executor，可以参考[DefaultExecutorSupplier.forBackgroundTasks](https://github.com/facebook/fresco/blob/0f3d52318631f2125e080d2a19f6fa13a31efb31/imagepipeline/src/main/java/com/facebook/imagepipeline/core/DefaultExecutorSupplier.java)。

### 从数据源中获取结果

这里展示了从数据源中获取目标类型为`T`的`CloseableReference<T>`的例子，注意此时获取结果对象仅仅在`onNewResultImpl`有使用意义。当回调结束之后，这个对象就不能被使用了！（如果你希望保持这个对象并在外部使用，请继续往下看）

```java
    DataSource<CloseableReference<T>> dataSource = ...;

    DataSubscriber<CloseableReference<T>> dataSubscriber =
        new BaseDataSubscriber<CloseableReference<T>>() {
          @Override
          protected void onNewResultImpl(
              DataSource<CloseableReference<T>> dataSource) {
            if (!dataSource.isFinished()) {
              return;
            }
            CloseableReference<T> ref = dataSource.getResult();
            if (ref != null) {
              try {
                T result = ref.get();
                ...
              } finally {
                CloseableReference.closeSafely(ref);
              }
            }
          }

          @Override
          protected void onFailureImpl(DataSource<CloseableReference<T>> dataSource) {
            Throwable t = dataSource.getFailureCause();
            // handle failure
          }
        };

    dataSource.subscribe(dataSubscriber, executor);
```

### 保持数据源结果的引用

上面的例子中我们在回调执行完就将对象释放了。如果你需要保持这个对象有效，那么你可以不在这里`close`它，参照如下例子：

```java
    DataSource<CloseableReference<T>> dataSource = ...;

    DataSubscriber<CloseableReference<T>> dataSubscriber =
        new BaseDataSubscriber<CloseableReference<T>>() {
          @Override
          protected void onNewResultImpl(
              DataSource<CloseableReference<T>> dataSource) {
            if (!dataSource.isFinished()) {
              return;
            }
            mRef = dataSource.getResult();
            T result = mRef.get();
            ...
          }

          @Override
          protected void onFailureImpl(DataSource<CloseableReference<T>> dataSource) {
            Throwable t = dataSource.getFailureCause();
            // handle failure
          }
        };

    dataSource.subscribe(dataSubscriber, executor);
```

**你必须要在使用完它之后对它回收，否则会造成内存泄漏！**

参考[可关闭的引用](closeable-references.html) 来获取更多信息。

```java
    CloseableReference.closeSafely(mRef);
    mRef = null;
```

### 获取未解码的图片

```java
    DataSource<CloseableReference<PooledByteBuffer>> dataSource =
        mImagePipeline.fetchEncodedImage(imageRequest, CALLER_CONTEXT);
```

Image pipeline 使用 `PooledByteBuffer` 来存储未解码的图片。 此处我们继续使用上面的目标类型 `T`来举个例子， 通过创建`InputStream` 来读取图片字节流:

```java
      InputStream is = new PooledByteBufferInputStream(result);
      try {
        ImageFormat imageFormat = ImageFormatChecker.getImageFormat(is);
        Files.copy(is, path);
      } catch (...) {
        ...
      } finally {
        Closeables.closeQuietly(is);
      }
```

### 获取已解码的图片

```java
DataSource<CloseableReference<CloseableImage>>
    dataSource = imagePipeline.fetchDecodedImage(imageRequest, callerContext);
```

Image pipeline `CloseableImage` 来承载已解码的图片。下面例子描述如何从`CloseableImage`拿出一个`Bitmap`对象:

```java
	CloseableImage image = ref.get();
	if (image instanceof CloseableBitmap) {
	  // do something with the bitmap
	  Bitmap bitmap = (CloseableBitmap image).getUnderlyingBitmap();
	  ...
	}
```


### 只想要Bitmap不想要别的...

如果你向ImagePipeline请求一个[Bitmap](http://developer.android.com/reference/android/graphics/Bitmap.html), 你可以使用我们的 [BaseBitmapDataSubscriber](http://frescolib.org/javadoc/reference/com/facebook/imagepipeline/datasource/BaseBitmapDataSubscriber):

```java
dataSource.subscribe(new BaseBitmapDataSubscriber() {
    @Override
    public void onNewResultImpl(@Nullable Bitmap bitmap) {
      // 你可以直接在这里使用Bitmap，没有别的限制要求，也不需要回收
    }

    @Override
    public void onFailureImpl(DataSource dataSource) {
    }
  },
  executor);
```

**注意，这里有一些要求！**

* 这个数据源无法用来获取动图。
* 你无法在`onNewResultImpl`之外的地方使用这个`Bitmap`。原因是`BaseBitmapDataSubscriber`数据源的获取结束之后，image pipeline就会回收这个Bitmap。如果你此时再用它来显示，会报`IllegalStateException`！
* 当然你可以将它传给Android的[通知栏](https://developer.android.com/reference/android/support/v4/app/NotificationCompat.Builder.html#setLargeIcon\(android.graphics.Bitmap\))或者[RemoveView][remote view](http://developer.android.com/reference/android/widget/RemoteViews.html#setImageViewBitmap\(int, android.graphics.Bitmap\))。Android系统会在共享内存区域保存一份Bitmap的拷贝，Fresco的回收不会影响它。

如果这些要求导致你不能使用`BaseBitmapDataSubscriber`，你可以使用上述的其他数据源。
