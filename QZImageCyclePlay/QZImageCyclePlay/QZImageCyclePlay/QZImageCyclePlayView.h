//
//  QZImageCyclePlayView.h
//  QZImageCyclePlay
//
//  Created by 曲终叶落 on 2017/9/17.
//  Copyright © 2017年 曲终叶落. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol QZImageCyclePlayViewDelegate <NSObject>

@optional

- (void)imageCyclePlayViewClickIndex:(NSInteger)index;

@end


@interface QZImageCyclePlayView : UIView

@property (nonatomic, weak) id<QZImageCyclePlayViewDelegate> delegate;

/**
 初始化方法
 
 @param frame frame
 @param imagesurl 图片urls数组
 @param isAuto 是否自动播放
 @param timeInterval 切换图片间隔时间
 @param titles 标题数组
 @return return value description
 */
- (instancetype)initWithFrame:(CGRect)frame imagesurl:(NSArray *)imagesurl autoPlay:(BOOL)isAuto delay:(NSTimeInterval)timeInterval titles:(NSArray *)titles;


/**
 停止循环并释放
 */
- (void)stopCycle;


@end
