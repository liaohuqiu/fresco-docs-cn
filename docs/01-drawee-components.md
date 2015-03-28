---
id: drawee-components
title: 使用Drawee呈现不同的效果
layout: docs
permalink: /docs/drawee-components.html
prev: using-drawees-code.html
next: scaling.html
---

## 内容导航

* [定义](#Definitions)
* [设置要加载的图片](#Actual)
* [占位图](#Placeholder)
* [加载失败时的占位图](#Failure)
* [点击重新加载](#点击重新加载(Retry))
* [进度条(ProgressBar)](#进度条(ProgressBar))
* [Backgrounds](#Backgrounds)
* [Overlays](#Overlays)
* [Pressed State Overlay](#PressedStateOverlay)

## <a name='Definitions'></a>定义

本页说明如何设置实现不同的图片呈现效果。

除了要加载的图片，其他各个设置都可以在xml中指定。在xml中指定的时候，可以是drawable/下的资源，也可以颜色。

在Java 代码中也可以指定。如果需要 [通过程序设定](using-drawees-code.html) 的话会接触到这个类: [GenericDraweeHierarchyBuilder](../javadoc/reference/com/facebook/drawee/generic/GenericDraweeHierarchyBuilder.html) 
 
通过代码设置是，设置的值可以是资源id，也可以是Drawable的子类。

创建完[GenericDraweeHierarchy](../javadoc/reference/com/facebook/drawee/generic/GenericDraweeHierarchy.html)之后，也可以通过该类的相关方法，重新设置一些效果。

大多数的用户呈现不同效果的drawables都是可以[缩放的](scaling.html).

## <a name='Actual'></a>设置要加载的图

除了需要下载的图片是真正必须的，其他的都是可选的。如前所述，图片可以来自多个地方。

所需下载的图片实际是DraweeController的一个属性，而不是DraweeHierarchy的属性。

可使用`setImageURI`方法或者[通过设置DraweeController](using-controllerbuilder.html) 来进行设置。

This is a property of the controller, not the hierarchy. It therefore is not set by any of the methods used by the other Drawee components.

对于可缩放的类型，DraweeHierarchy 仅对所需下载的图片属性

In addition to the scale type, the hierarchy exposes other methods only for the actual image. These are:

* focus point (used for the [focusCrop](scaling.html#FocusCrop) scale type only)
* color filter

默认的缩放类型是: `centerCrop`

## <a name="Placeholder"></a>占位图(Placeholder)

The _placeholder_ is shown in the Drawee when it first appears on screen. After you have called `setController` or `setImageURI` to load an image, the placeholder continues to be shown until the image has loaded. 

In the case of a progressive JPEG, the placeholder only stays until your image has reached the quality threshold, whether the default, or one set by your app.

XML attribute: `placeholderImage`  
Hierarchy builder method: `setPlaceholderImage`  
Hierarchy method: `setPlaceholderImage`  
Default value: a transparent [ColorDrawable](http://developer.android.com/reference/android/graphics/drawable/ColorDrawable.html)  
Default scale type: `centerInside`  

## 设置加载失败占位图

The _failure_ image appears if there is an error loading your image. The most common cause of this is an invalid URI, or lack of connection to the network.

XML attribute: `failureImage`  
Hierarchy builder method: `setFailureImage`  
Default value: The placeholder image  
Default scale type: `centerInside`

## 设置：点击重新加载图

The _retry_ image appears instead of the failure image if you have set your controller to enable the tap-to-retry feature. 

You must [build your own Controller](using-controllerbuilder.html) to do this. Then add the following line

```java
.setTapToRetryEnabled(true)
```

The image pipeline will then attempt to retry an image if the user taps on it. Up to four attempts are allowed before the failure image is shown instead.

XML attribute: `retryImage`  
Hierarchy builder method: `setRetryImage`  
Default value: The placeholder image   
Default scale type: `centerInside`

## <a name="ProgressBar"></a>Progress Bar

If specified, the _progress bar_ image is shown as an overlay over the Drawee until the final image is set.

Currently the progress bar remains the same throughout the image load; actually changing in response to progress is not yet supported.

XML attribute: `progressBarImage`  
Hierarchy builder method: `setProgressBarImage`  
Default value: None   
Default scale type: `centerInside`

## Backgrounds

_Background_ drawables are drawn first, "under" the rest of the hierarchy. 

Only one can be specified in XML, but in code more than one can be set. In that case, the first one in the list is drawn first, at the bottom.

Background images don't support scale-types and are scaled to the Drawee size. 

XML attribute: `backgroundImage`  
Hierarchy builder method: `setBackground,` `setBackgrounds`    
Default value: None   
Default scale type: N/A

## Overlays

_Overlay_ drawables are drawn last, "over" the rest of the hierarchy. 

Only one can be specified in XML, but in code more than one can be set. In that case, the first one in the list is drawn first, at the bottom.

Overlay images don't support scale-types and are scaled to the Drawee size. 

XML attribute: `overlayImage`  
Hierarchy builder method: `setOverlay,` `setOverlays`    
Default value: None   
Default scale type: N/A

## <a name="PressedStateOverlay"></a>Pressed State Overlay

The _pressed state overlay_ is a special overlay shown only when the user presses the screen area of the Drawee. For example, if the Drawee is showing a button, this overlay could have the button change color when pressed.

The pressed state overlay doesn't support scale-types.

XML attribute: `pressedStateOverlayImage`  
Hierarchy builder method: `setPressedStateOverlay`    
Default value: None   
Default scale type: N/A



