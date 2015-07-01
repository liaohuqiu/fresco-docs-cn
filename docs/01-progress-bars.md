---
id: progress-bars
title: 进度条
layout: docs
permalink: /docs/progress-bars.html
prev: drawee-components.html
next: scaling.html
---

要显示进度，最简单的办法就是在 [构建 hierarchy](using-drawees-code.html) 时使用 [ProgressBarDrawable](../javadoc/reference/com/facebook/drawee/drawable/ProgressBarDrawable.html)，如下：

```java
.setProgressBarImage(new ProgressBarDrawable())
```

这样，在 Drawee 的底部就会有一个深蓝色的矩形进度条。

### 自定义进度条

If you wish to customize your own progress indicator, be aware that in order for it to accurately reflect progress while loading, it needs to override the [Drawable.onLevelChange](http://developer.android.com/reference/android/graphics/drawable/Drawable.html#onLevelChange\(int\)) method:

如果你想自定义进度条，请注意，如果想精确显示加载进度，需要重写  [Drawable.onLevelChange](http://developer.android.com/reference/android/graphics/drawable/Drawable.html#onLevelChange\(int\))：

```java
class CustomProgressBar extends Drawable {
   @Override
   protected void onLevelChange(int level) {
     // level is on a scale of 0-10,000
     // where 10,000 means fully downloaded
     
     // your app's logic to change the drawable's
     // appearance here based on progress
   }
}
```
