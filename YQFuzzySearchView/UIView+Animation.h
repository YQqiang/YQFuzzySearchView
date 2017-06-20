//
//  UIView+Animation.h
//  operation4ios
//
//  Created by sungrow on 2017/5/4.
//  Copyright © 2017年 阳光电源股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    FloatAnimationUpToDown,             // 上下浮动
    FloatAnimationLeftToRight,          // 左右浮动
    FloatAnimationLeftUpToRightDown,    // 左上-右下 浮动
    FloatAnimationLeftDownToRightUp,    // 左下-右上 浮动
} FloatAnimationType;

typedef enum : NSUInteger {
    RotationAnimationAxisX,             // X 轴 旋转
    RotationAnimationAxisY,             // Y 轴 旋转
    RotationAnimationAxisZ,             // Z 轴 旋转
} RotationAnimationAxisType;

typedef enum: NSUInteger {
    ScaleAnimationPlus,                 // 放大
    ScaleAnimationMinus,                // 缩小
} ScaleAnimationType;

@interface UIView (Animation)

- (void)rotationAnimationWithDuration:(CGFloat)duration rotationAnimationAxisType:(RotationAnimationAxisType)rotationAnimationAxisType clockwise:(BOOL)clockwise;

- (void)floatAnimationWithFloatAnimationType:(FloatAnimationType)floatAnimationType;

- (void)floatAnimationWithUpDownSpace:(CGFloat)upDownSpace leftRightSpace:(CGFloat)leftRightSpace duration:(CGFloat)duration floatAnimationType:(FloatAnimationType)floatAnimationType;

- (void)scaleAnimationWithDuration:(CGFloat)duration scaleAnimationType:(ScaleAnimationType)scaleAnimationType multiple:(CGFloat)multiple;

- (void)alphaAnimationWithDuration:(CGFloat)duration fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue;

@end
