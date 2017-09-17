# QZImageCyclePlay
一个UIScrollView和3个UIImageView实现轮播图效果

使用方法：
导入QZImageCyclePlay.h和QZImageCyclePlay.m到你的项目中

调用初始化方法
```
/**
 初始化方法

 @param frame frame
 @param imagesurl 图片urls数组
 @param isAuto 是否自动播放
 @param timeInterval 切换图片间隔时间
 @param titles 标题数组 (为空时不显示标题栏)
 @return return value description
 */
- (instancetype)initWithFrame:(CGRect)frame imagesurl:(NSArray *)imagesurl autoPlay:(BOOL)isAuto delay:(NSTimeInterval)timeInterval titles:(NSArray *)titles;
```

你可以在样式中直接修改标题titleLb的样式和指示器pageControl的样式

离开当前控制器的时候记得在delloc方法中调用 stopCycle停止当前的循环
```
- (void)dealloc {
    [self.cycleView stopCycle];
}
```
