---
docid: gotchas
title: 一些陷阱
layout: docs
permalink: /docs/gotchas.html
prev: troubleshooting.html
next: wrap-content.html
---

### 不要使用 ScrollViews

如果你想要在一个长的图片列表中滑动，你应该使用 `RecyclerView`，`ListView`，或 `GridView`。这三者都会在你滑动时不断重用子视图。Fresco 的 view 会接收系统事件，使它们能正确管理内存。

`ScrollView` 不会这样做。因此，Fresco view 不会被告知它们是否在屏幕上显示，并保持图片内存占用直到你的 Fragment 或 Activity 停止。你的 App 将会面临更大的 OOM 风险。

### 不要向下转换

不要试图把Fresco返回的一些对象进行向下转化，这也许会带来一些对象操作上的便利，但是也许在后续的版本中，你会遇到一些因为向下转换特性丢失导致的难以处理的问题。

### 不要使用getTopLevelDrawable

`DraweeHierarchy.getTopLevelDrawable()` **仅仅** 应该在DraweeViews中用，除了定义View中，其他应用代码建议连碰都不要碰这个。

在[自定义view](writing-custom-views.html)中，也千万不要将返回值向下转换，也许下个版本，我们会更改这个返回值类型。

### 不要复用 DraweeHierarchies

永远不要把 `DraweeHierarchy` 通过 `DraweeView.setHierarchy` 设置给不同的View。DraweeHierarchy 是由一系列 Drawable 组成的。在 Android 中, Drawable 不能被多个 View 共享。

### 不要在多个DraweeHierarchy中使用同一个Drawable

原因同上。不过你可以在占位图、重试图、错误图中使用相同的资源ID，Android 实际会创建不同的 Drawable。 如果你使用`GenericDraweeHierarchyBuilder`，那么需要调用[Resources.getDrawable](http://developer.android.com/reference/android/content/res/Resources.html#getDrawable(int))来通过资源获取图片。不过请不要只调用一次然后将结果传给不同的`Hierarchy`！

### 不要直接控制 hierarchy

不要直接使用 `SettableDraweeHierarchy` 方法(`reset`，`setImage`，...)。它们应该仅由 controller 使用。不要使用`setControllerOverlay`来设置一个覆盖图，这个方法只能给 controller 调用。如果你需要显示覆盖图，可以参考[Drawee的各种效果配置](drawee-branches.html#Overlays)

### 不要直接给 `DraweeView` 设置图片。

目前 `DraweeView` 直接继承于 ImageView，因此它有 `setImageBitmap`,
`setImageDrawable`  等方法。

如果利用这些方法直接设置一张图片，内部的 `DraweeHierarchy` 就会丢失，也就无法取到image
pipeline 的任何图像了。

### 使用 DraweeView 时，请不要使用任何 ImageView 的属性

在后续的版本中，DraweeView 会直接从 View 派生。任何属于 ImageView 但是不属于 View 的方法都会被移除。

