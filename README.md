# CustomScenecontrol

用于存放一些自己写的SC  
基于 ArcadeZero v4.x Scenecontrol API

### NOTES
- `enwidenlaneslua` 尽量不要和其他控制轨道显示类型的scenecontrol一同使用

## enwidencamera.lua
### enwidencameralua(duration: number, toggle: number, easing: string)
提升摄像头以及skyinput

- `duration`：持续时间
- `toggle`：整数，使camera提升至 *4 + t \* 2* 轨的高度
- `easing`：指定缓动类型（支持类型可查看[中文文档](https://github.com/Kuroikage1732/ArcadeScenecontrol)）

## enwidenlanes.lua
### enwidenlaneslua(duration: number, toggle: number)
扩展轨道

- `duration`：持续时间
- `toggle`：整数，将轨道设置为 *4 + t \* 2* 轨

### displaytrack(duration: number, toggle: number)
调整主轨道透明度

- `duration`：持续时间
- `toggle`：轨道透明度

### extralane(lane: number, duration: number, toggle: 0 | 1)
扩展单个轨道

- `lane`：轨道编号（任意整数，包括0-5）
- `duration`：持续时间
- `toggle`：显示与否

# Macros
辅助宏

## CreateExtraLane.lua
### DisplayExtraLane
创建/显示单个额外轨道

使用方法：点击宏后选择单个或多个hold对象，宏将会显示hold所在的轨道，动画持续时间与hold相同

### HideExtraLane
隐藏单个额外轨道

使用方法：点击宏后选择单个或多个hold对象，宏将会隐藏hold所在的轨道，动画持续时间与hold相同
