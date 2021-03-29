Language: [English](README.md) | [中文简体](README-ZH.md)
# tween_image_widget

一个补间动画的Flutter的widget包

## Getting Started

### 添加依赖

```yaml
dependencies:
  tween_image_widget: ^0.0.2 #please use the latest version on pub
```
 
### 使用 Widget
1. 使用循环动画
 只需要传入图片名称和index，和具体durationMilliseconds的即可
```dart
         TweenImageWidget(
              ImagesEntry(1, 8, "assets/img/addpage_icon_load%s.png"),
              durationMilliseconds: 500,
            ),
```

2. 使用控制动画
需要把repeat 赋值 false，定义TweenImageWidget，然后根据场景使用reverse()、forward()、stop()等函数
```dart
  @override
  void initState() {
    _curtainAnimationImage = TweenImageWidget(
      ImagesEntry(1, 20, "equipmentcontrol_pic_curtain%s".toAssetImg()),
      durationMilliseconds: 5000,
      repeat: false,
    );
    super.initState();
  }
```

3. 需要把repeat 赋值 false，定义TweenImageWidget，然后根据场景使用reverse()、forward()、stop()等函数
```dart
///初始值:根据百分比计算
startsValue: curtainPosition / 100,
////高度和宽度是可选的，一旦赋值，将根据你指定的值缩放图像
height: 50,
width: 50,
```

**函数:**
```dart
  ///[repeat] 默认值为true, 如果你希望手动控制动画，则需要传入false
  ///
  ///[startsValue] 是一个起始状态值，如果要从动画的百分之几开始，请传入此值
  ///
  ///[durationMilliseconds] 是动画要运行的毫秒数，默认值为3000毫秒
  TweenImageWidget(
    this.entry, {
    this.width,
    this.height,
    this.durationMilliseconds = 3000,
    this.repeat = true,
    this.startsValue,
    key,
  }

  ///[lowIndex] 第一张图片索引
  /// [highIndex] 最后一张图片索引
  /// [basePath] 图片路径,例如:"images/pic_animation%s.png"
  /// [makePath] 一个可选的图片路径构造器，在使用默认构造器的时候，basePath必需传入%s
  ImagesEntry(this.lowIndex, this.highIndex, this.basePath, [this.makePath]);

  
 ///暂停动画.
  stop({bool canceled = true});

  ///执行正向动画显示.
  forward({double? from});

  ///执行逆向动画显示.
  reverse({double? from});

  ///动画运动到指定目标值.
  animateToTarget(double target, {Duration? duration});
```

### 例子:

```dart
 bool isDoorOpen = true;
  TweenImageWidget _doorAnimationImage;

  @override
  void initState() {
    _doorAnimationImage = TweenImageWidget(ImagesEntry(1, 4, "images/equipmentcontrol_pic_door%s"),
        durationMilliseconds: 600, repeat: false, startsValue: isDoorOpen ? 1 : 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: _doorAnimationImage),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  child: Text("Lock"),
                  onTap: () {
                    _doorAnimationImage.stop();
                    _doorAnimationImage.reverse();
                  },
                ),
                InkWell(
                  child: Text("Unlock"),
                  onTap: () {
                    _doorAnimationImage.stop();
                    _doorAnimationImage.forward();
                  },
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
```

#### Demo 截图
![demo](./demo.gif)




