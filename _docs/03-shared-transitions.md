---
docid: shared-transitions
title: 共享元素动画
layout: docs
permalink: /docs/shared-transitions.html
prev: wrap-content.html
next: using-other-network-layers.html
---

## 使用 ChangeBounds，而不是ChangeImageTransform

Android 5.0 (Lollipop) 引入了 [共享元素动画](http://developer.android.com/training/material/animations.html#Transitions)，允许在多个Activity切换时共享相同的View！

你可以在XML中定义这个变换。有个`ChangeImageTransform`变换可以在共享元素切换时对`ImageView`进行变换，可惜Fresco暂时不支持它，因为Drawee维护着自己的转换Matrix。

幸运的是你可以有另一种做法：使用[ChangeBounds](http://developer.android.com/reference/android/transition/ChangeBounds.html)。你可以改变layout的边界，这样Fresco会根据它进行自适应，也能够达到你想要的功能。