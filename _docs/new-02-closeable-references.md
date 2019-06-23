---
docid: closeable-references
title: 可关闭的引用
layout: docs
permalink: /docs/closeable-references.html
prev: caching.html
next: configure-image-pipeline.html
---

**本页内容仅为高级用法作参考。**

大多数 App 使用 [Drawees](using-simpledraweeview.html) 就好了，不用担心关闭的问题。

Java 带有垃圾回收功能，许多开发者习惯于不自觉地创建一大堆乱七八糟的对象，并且想当然地认为他们会从内存中消失。

在 5.0 系统之前，这样操作 Bitmap 是极其糟糕的。Bitmap 占用了大量的内存，大量的内存申请和释放势必引发频繁的 GC，使得界面卡顿不已。

Bitmap 是 Java 中为数不多的会让 Java 开发者想念 C++ 并羡慕 C++ 众多指针库的东西，比如 [Boost](http://www.boost.org/doc/libs/1_57_0/libs/smart_ptr/smart_ptr.htm)。 

Fresco 的解决方案是: [可关闭的引用 (CloseableReference)](../javadoc/reference/com/facebook/common/references/CloseableReference.html)。为了正确地使用它，请按以下步骤进行操作:

#### 1. 调用者持有这个引用

我们创建一个引用，但我们将它传递给一个调用者，调用者将持有这个引用：

```java
CloseableReference<Val> foo() {
  Val val;
  // 我们在这方法中返回这个引用，无论谁调用这个方法，
  // 都是这个引用的持有者，并且要负责关闭它。
  return CloseableReference.of(val);
}
```

#### 2. 持有者在离开作用域之前，必须要关闭引用

创建一个引用，但没有将它传递给其他调用者，所以在离开该作用域时，需要关闭它：

```java
void gee() {
  // 我们是 `foo` 的调用者，并且持有了它返回的引用。
  CloseableReference<Val> ref = foo();
  try {
    // `haa` 是被调用者而非调用者，因此它不是这个引用的持有者，
    // 也不必关闭该引用。
    haa(ref);
  } finally {
    // 我们没有返回这个引用给该方法的调用者，所以我们一直是
    // 该引用的持有者，并且必须在离开作用域之前关闭它。
    ref.close();
  }
}
```

`finally` 中最适合做这种事情了。

#### 3. **永远不要**自己关闭资源

`CloseableReference` 会在没有活跃引用时释放资源，它通过一个内部的计数器来追踪活跃引用数。当它降为 0 时，`CloseableReference` 会释放相关的资源。你使用 `CloseableReference` 的目的就是使用它来释放资源，而不是自己去手动释放资源。也就是说，如果你持有了 `CloseableReference`，你的责任是关闭它，而**不是**它所指向的资源。如果你关闭了它所指向的资源，则会使得所有指向同一资源的其他引用无效。

```java
  CloseableReference<Val> ref = foo();

  Val val = ref.get();
  // 处理 val
  // ...

  // 绝对不要关闭 val!
  //// val.close();

  // 而是关闭它的引用。
  ref.close();
```

#### 4. 除了引用的持有者，闲杂人等**不得**关闭引用

将引用作为一个参数传递，调用者仍然持有这个引用，因此此处不能关闭引用。

```java
void haa(CloseableReference<?> ref) {
  // 我们是被调用者，而不是调用者，所以我们不必关闭这个引用。
  // 我们保证在此调用内，引用不会无效。
  Log.println("Haa: " + ref.get());
}
```

如果此处错误地调用了 `.close()`, 之后如果调用者尝试调用 `.get()`时，会抛出`IllegalStateException`。

#### 5. 在赋值给变量前，先进行 clone。

如果我们要持有这个引用，我们需要 clone 它。

在类中使用它：

```java
class MyClass {
  CloseableReference<Val> myValRef;

  void mmm(CloseableReference<Val> ref) {
    // 某些调用者调用这个方法。调用者持有原来的引用，
    // 并且如果我们想要有备份，我们必须 clone 它。
    myValRef = ref.clone();
  };
  // 调用者可以在我们完成 clone 后安全地关闭它的备份。

  void close() {
    // 我们当然要负责关闭我们自己的备份。
    CloseableReference.closeSafely(myValRef);
  }
}
// 现在，MyClass 的调用者必须关闭它！
```

在内部类中使用它：

```java
void haa(CloseableReference<?> ref) {
  // 此处我们创建了原始引用的备份，使得我们可以保证在将来
  // 执行者执行 runnable 时，它仍然有效。
  final CloseableReference<?> refClone = ref.clone();
  executor.submit(new Runnable() {
    public void run() {
      try {
        Log.println("Haa Async: " + refClone.get());
      } finally {
        // 当我们使用完后，需要关闭我们的备份。
        refClone.close();
      }
    }
  });
  // 调用者可以安全的关闭引用，因为我们完成了 clone 。
}
```
