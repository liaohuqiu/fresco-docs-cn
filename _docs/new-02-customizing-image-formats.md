---
docid: customizing-image-formats
title: 自定义图片格式
layout: docs
permalink: /docs/customizing-image-formats.html
prev: configure-image-pipeline.html
next: datasources-datasubscribers.html
---

通常，图片显示到屏幕上包含以下两个步骤：
1. 解码图片
2. 渲染已解码的图片

Fresco 允许你自定义这两个步骤。例如，可以给已存在的或新的图片格式添加自定义的图片解码器，它会被用到 Fresco 内置的渲染架构中来渲染位图。或者，它可以让内置的解码器处理解码过程，然后创建一个自定义的可绘制对象（drawable）用于渲染图片到屏幕上。当然，你可以同时使用它们。这些自定义可以在 Fresco 初始化时全局注册，或是局部地对一些图像注册。


（简化版的）解码、渲染过程如下：
1. 通过网络下载或从磁盘缓存中加载得到编码图片。
2. `EncodeImage` 的 `ImageFormat` 是通过 `ImageFormatChecker` 决定的。它有一个 `ImageFormat.FormatChecker` 对象的列表，每一个对象可识别一种图片格式。
3. 对于给定的格式，使用合适的 `ImageDecoder` 对 `EncodedImage` 进行解码，并返回扩展自 `CloseableImage` 的对象，该对象代表了解码后的图像。
4. 从 `DrawableFactory` 对象的列表中，找到第一个能处理 `CloseableImage` 的对象，用以创建 `Drawable`。
5. 渲染到屏幕上。

可以在第 2 步中添加一个 `ImageFormat.FormatChecker` 来添加一个自定义的图像格式。你可以提供自定义的 `ImageDecoder` 来支持新图像格式的解码，或复写内置的解码方法。最后，你可以提供自定义的 `DrawableFactory` 创建一个自定义的 `Drawable` 对象来渲染图像。

所有默认的图像格式都能在 `DefaultImageFormats` 和 `DefaultImageFormatChecker` 中找到，默认的可绘制对象工厂（drawable factory）在 `PipelineDraweeController` 中，并且有几个与之有关的自定义示例可以在示例应用中找到。

## 自定义解码器

让我们从一个例子开始。为了创建一个自定义的解码器，可以简单的通过实现 `ImageDecoder` 来实现：

```java
public class CustomDecoder implements ImageDecoder {

  @Override
  public CloseableImage decode(
      EncodedImage encodedImage,
      int length,
      QualityInfo qualityInfo,
      ImageDecodeOptions options) {
    // Decode the given encodedImage and return a
    // corresponding (decoded) CloseableImage.
    CloseableImage closeableImage = ...;
    return closeableImage;
  }
}
```

给定的编码图像可以返回扩展自 `CloseableImage` 的类，即：已解码的图像，并且它将被自动缓存下来。你也可以返回一个已经存在的 `CloseableImage` 类型，比如：与位图对应的 `CloseableStaticBitmap`，或是自定义的 `CloseableImage` 类。

自定义的解码器可全局或局部的设置到每个图像上。对于局部替换，你可以使用如下方式设置自定义的解码器：

```java
ImageDecoder customDecoder = ...;
Uri uri = ...;
draweeView.setController(
  Fresco.newDraweeControllerBuilder()
        .setImageRequest(
          ImageRequestBuilder.newBuilderWithSource(uri)
              .setImageDecodeOptions(
                  ImageDecodeOptions.newBuilder()
                      .setCustomImageDecoder(customDecoder)
                      .build())
              .build())
        .build());
```

**注意：** 如果你提供了一个自定义的解码器，并将它用于所有图像，则默认的解码器将被完全替代。

## 自定义图像格式

创建并持有一个新的 `ImageFormat` 对象的的方式如下：

```java
private static final ImageFormat CUSTOM_FORMAT = new ImageFormat("format name", "format file extension");
```

所有已支持的默认图像格式可以在 `DefaultImageFormats` 中找到。

然后，我们需要创建一个自定义的 `ImageFormat.FormatChecker` 它将被用于新图像格式的检测。格式检查器有两个方法：一个用于决定所需的头部字节数（由于这个操作对所有图像都会执行，因此应使这个数字尽可能的小），一个 `determineFormat` 方法，返回 **相同的 `ImageFormat` 实例**。在本例中，为 `CUSTOM_FORMAT` 实例，如果图像格式不同，则会返回 null。一个简单的格式检查器就像下面这样：

```java
public static class ColorFormatChecker implements ImageFormat.FormatChecker {

  private static final byte[] HEADER = ImageFormatCheckerUtils.asciiBytes("my_header");

  @Override
  public int getHeaderSize() {
    return HEADER.length;
  }

  @Nullable
  @Override
  public ImageFormat determineFormat(byte[] headerBytes, int headerSize) {
    if (headerSize < getHeaderSize()) {
      return null;
    }
    if (ImageFormatCheckerUtils.startsWithPattern(headerBytes, HEADER)) {
      return CUSTOM_FORMAT;
    }
    return null;
  }
}
```

自定义图像格式所需的第三个组件是上面提到的自定义解码器，用于创建已解码的图像。

你必须在 Fresco 初始化时，使用 Fresco 提供的 `ImageDecoderConfig` 来注册自定义的图像格式。同样，你可以使用内置图像格式来复写默认的解码行为。

```java
ImageFormat myFormat = ...;
ImageFormat.FormatChecker myFormatChecker = ...;
ImageDecoder myDecoder = ...;
ImageDecoderConfig imageDecoderConfig = new ImageDecoderConfig.Builder()
  .addDecodingCapability(
    myFormat,
    myFormatChecker,
    myDecoder)
  .build();

ImagePipelineConfig config = ImagePipelineConfig.newBuilder()
  .setImageDecoderConfig(imageDecoderConfig)
  .build();

Fresco.initialize(context, config);
```

## 自定义可绘制对象

如果一个 `DraweeController` 被用于加载图像（假设你正在使用 `DraweeView`），要使用相应的 `DrawableFactory` 创建一个基于 `CloseableImage` 的可绘制对象用于渲染解码后的图像。如果你手动使用了图像管道（the image pipeline），则必须处理 `CloseableImage` 自身。

如果你是用一个内置类型，比如 `CloseableStaticBitmap`，则 `PipelineDraweeController` 已经知道如何处理该格式，并将为你创建一个 `BitmapDrawable`。如果你想复写其表现，或添加对自定义 `CloseableImage` 的支持，你必须实现相应的可绘制对象工厂：

```java
public static class CustomDrawableFactory implements DrawableFactory {

  @Override
  public boolean supportsImageType(CloseableImage image) {
    // You can either override a built-in format, like `CloseableStaticBitmap`
    // or your own implementations.
    return image instanceof CustomCloseableImage;
  }

  @Nullable
  @Override
  public Drawable createDrawable(CloseableImage image) {
    // Create and return your custom drawable for the given CloseableImage.
    // It is guaranteed that the `CloseableImage` is an instance of the
    // declared classes in `supportsImageType` above.
    CustomCloseableImage myCloseableImage = (CustomCloseableImage) image;
    Drawable myDrawable = ...; //e.g. new CustomDrawable(myCloseableImage)
    return myDrawable;
  }
}
```

为了使用你的可绘制对象工厂，你也可以采用全局或局部替代。

### 自定义 drawable 全局替代

你必须在 Fresco 初始化时注册所有全局的可绘制对象工厂：

```java
DrawableFactory myDrawableFactory = ...;

DraweeConfig draweeConfig = DraweeConfig.newBuilder()
  .addCustomDrawableFactory(myDrawableFactory)
  .build();

Fresco.initialize(this, imagePipelineConfig, draweeConfig);
```

### 自定义 drawable 局部替代

为了实现局部替代，`PipelineDraweeControllerBuilder` 提供了设置自定义可绘制对象工厂的方法：

```java
DrawableFactory myDrawableFactory = ...;
Uri uri = ...;

simpleDraweeView.setController(Fresco.newDraweeControllerBuilder()
  .setUri(uri)
  .setCustomDrawableFactory(factory)
  .build());
```
