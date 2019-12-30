---
docid: datasources-datasubscribers
title: DataSources and DataSubscribers
layout: docs
permalink: /docs/datasources-datasubscribers.html
prev: customizing-image-formats.html
next: image-requests.html
---

[DataSources](../javadoc/reference/com/facebook/datasource/DataSource.html) 就像 Java 中的 [Future](http://developer.android.com/reference/java/util/concurrent/Future.html), 是异步计算的结果。与 Future 不一样的是，DataSource 返回单个命令产生的一系列结果，而不仅是其中一个结果。

在提交一个图像请求之后，图片管道返回一个数据源。为了从中得到结果，你需要用到 [DataSubscriber](../javadoc/reference/com/facebook/datasource/DataSubscriber.html)。

### Executors

在订阅到 data sources 时，需要先提供 executors。executor 的任务是在特殊的线程、特定策略下执行 runnable（在本例中，就是 subscriber 的回调方法）。Fresco 提供了几个 [executors](https://github.com/facebook/fresco/tree/master/fbcore/src/main/java/com/facebook/common/executors)，其中一个要小心使用：

* 如果你需要在回调中操作 UI（访问视图, 可绘制对象等），你必须用 `UiThreadImmediateExecutorService.getInstance()`。Android 视图系统是线程不安全的，并且仅可在主线程访问（UI 线程）。
* 如果回调是轻量级的，并且不用操作 UI, 你可以使用 `CallerThreadExecutor.getInstance()`。这个执行者会在调用者的线程执行。它的回调可能在 UI 线程执行，也可能在后台线程执行，这取决于它在哪个线程被调用。因为它不能保证在哪个线程执行，因此要小心地使用它。再强调一遍，它仅适用于与 UI 无关的、轻量的操作。
* 如果你需要做一些与 UI 无关的重量级的操作（访问数据库，读写磁盘或者其他耗时操作）， 则不应该使用 `CallerThreadExecutor` 或 `UiThreadExecutorService`，而是使用后台线程执行者。有关示例实现详见 [DefaultExecutorSupplier.forBackgroundTasks](https://github.com/facebook/fresco/blob/master/imagepipeline-base/src/main/java/com/facebook/imagepipeline/core/DefaultExecutorSupplier.java）。

### 从 data source 获取结果

这是关于怎样从任意类型 `T` 的 `CloseableReference<T>` 数据源获取结果的泛型示例。这个结果仅在作用域 `onNewResultImpl` 回调中有效。一旦这个回调被执行后，该结果就不再有效。如果该结果需要保留，参看下一个示例：

```java
    DataSource<CloseableReference<T>> dataSource = ...;

    DataSubscriber<CloseableReference<T>> dataSubscriber =
        new BaseDataSubscriber<CloseableReference<T>>() {
          @Override
          protected void onNewResultImpl(
              DataSource<CloseableReference<T>> dataSource) {
            if (!dataSource.isFinished()) {
              // if we are not interested in the intermediate images,
              // we can just return here.
              return;
            }
            CloseableReference<T> ref = dataSource.getResult();
            if (ref != null) {
              try {
                // do something with the result
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

### 保留从数据源中获取的结果

上一个例子中，一旦回调被执行后就关闭了引用。如果该结果需要被保留，你必须在它被用到之前持有相应 `CloseableReference`。可以按照下面的步骤进行：

```java
    DataSource<CloseableReference<T>> dataSource = ...;

    DataSubscriber<CloseableReference<T>> dataSubscriber =
        new BaseDataSubscriber<CloseableReference<T>>() {
          @Override
          protected void onNewResultImpl(
              DataSource<CloseableReference<T>> dataSource) {
            if (!dataSource.isFinished()) {
              // if we are not interested in the intermediate images,
              // we can just return here.
              return;
            }
            // keep the closeable reference
            mRef = dataSource.getResult();
            // do something with the result
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

**重点**：一旦你不再需要该结果，你**必须要关闭引用**。不这样做会导致内存泄漏。
查看 [closeable references](closeable-references.html) 的更多详细信息。

```java
    CloseableReference.closeSafely(mRef);
    mRef = null;
```

然而，如果你使用 `BaseDataSubscriber`，你不必手动关闭 `dataSource` （关闭 `mRef` 就够了）。 `BaseDataSubscriber` 自动地在 `onNewResultImpl` 被调用后为你关闭了 `dataSource`。
如果你没有使用 `BaseDataSubscriber`（例如：如果你正在调用 `dataSource.getResult()`），请确保关闭了 `dataSource`。

### To get encoded image...

```java
    DataSource<CloseableReference<PooledByteBuffer>> dataSource =
        mImagePipeline.fetchEncodedImage(imageRequest, CALLER_CONTEXT);
```

Image pipeline uses `PooledByteBuffer` for encoded images. This is our `T` in the above examples. Here is an example of creating an `InputStream` out of `PooledByteBuffer` so that we can read the image bytes:

```java
      InputStream is = new PooledByteBufferInputStream(result);
      try {
        // Example: get the image format
        ImageFormat imageFormat = ImageFormatChecker.getImageFormat(is);
        // Example: write input stream to a file
        Files.copy(is, path);
      } catch (...) {
        ...
      } finally {
        Closeables.closeQuietly(is);
      }
```

### To get decoded image...

```java
DataSource<CloseableReference<CloseableImage>>
    dataSource = imagePipeline.fetchDecodedImage(imageRequest, callerContext);
```

Image pipeline uses `CloseableImage` for decoded images. This is our `T` in the above examples. Here is an example of getting a `Bitmap` out of `CloseableImage`:

```java
	CloseableImage image = ref.get();
	if (image instanceof CloseableBitmap) {
	  // do something with the bitmap
	  Bitmap bitmap = (CloseableBitmap image).getUnderlyingBitmap();
	  ...
	}
```


### I just want a bitmap...

If your request to the pipeline is for a single [Bitmap](http://developer.android.com/reference/android/graphics/Bitmap.html), you can take advantage of our easier-to-use [BaseBitmapDataSubscriber](../javadoc/reference/com/facebook/imagepipeline/datasource/BaseBitmapDataSubscriber):

```java
dataSource.subscribe(new BaseBitmapDataSubscriber() {
    @Override
    public void onNewResultImpl(@Nullable Bitmap bitmap) {
      // You can use the bitmap here, but in limited ways.
      // No need to do any cleanup.
    }

    @Override
    public void onFailureImpl(DataSource dataSource) {
      // No cleanup required here.
    }
  },
  executor);
```

A snap to use, right? There are caveats.

This subscriber doesn't work for animated images as those can not be represented as a single bitmap.

You can **not** assign the bitmap to any variable not in the scope of the `onNewResultImpl` method. The reason is, as already explained in the above examples that, after the subscriber has finished executing, the image pipeline will recycle the bitmap and free its memory. If you try to draw the bitmap after that, your app will crash with an `IllegalStateException.`

You can still safely pass the Bitmap to an Android [notification](https://developer.android.com/reference/android/support/v4/app/NotificationCompat.Builder.html#setLargeIcon\(android.graphics.Bitmap\)) or [remote view](http://developer.android.com/reference/android/widget/RemoteViews.html#setImageViewBitmap\(int, android.graphics.Bitmap\)). If Android needs your Bitmap in order to pass it to a system process, it makes a copy of the Bitmap data in ashmem - the same heap used by Fresco. So Fresco's automatic cleanup will work without issue.

If those requirements prevent you from using `BaseBitmapDataSubscriber`, you can go with a more generic approach as explained above.
