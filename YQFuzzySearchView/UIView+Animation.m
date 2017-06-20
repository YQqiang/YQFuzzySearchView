//
//  UIView+Animation.m
//  operation4ios
//
//  Created by sungrow on 2017/5/4.
//  Copyright © 2017年 阳光电源股份有限公司. All rights reserved.
//

#import "UIView+Animation.h"

static CGFloat floatAnimationDuration = 5.0;
static CGFloat floatAnimationUpDownSpace = 10.0;
static CGFloat floatAnimationLeftRightSpace = 4.0;

@implementation UIView (Animation)

/**
 旋转动画
 
 @param duration 动画时间>>>>>可以控制动画速度(时间长, 速度慢; 时间短, 速度快)
 @param rotationAnimationAxisType 旋转轴类型
 @param clockwise 顺时针旋转
 */
- (void)rotationAnimationWithDuration:(CGFloat)duration rotationAnimationAxisType:(RotationAnimationAxisType)rotationAnimationAxisType clockwise:(BOOL)clockwise {
    CABasicAnimation *rotationAni = [[CABasicAnimation alloc] init];
    switch (rotationAnimationAxisType) {
        case RotationAnimationAxisX:
            rotationAni.keyPath = @"transform.rotation.x";
            break;
        case RotationAnimationAxisY:
            rotationAni.keyPath = @"transform.rotation.y";
            break;
        case RotationAnimationAxisZ:
            rotationAni.keyPath = @"transform.rotation.z";
            break;
        default:
            rotationAni.keyPath = @"transform.rotation.x";
            break;
    }
    rotationAni.fillMode = kCAFillModeForwards;
    rotationAni.removedOnCompletion = false;
    rotationAni.repeatCount = MAXFLOAT;
    rotationAni.duration = duration;
    rotationAni.fromValue = @(0);
    rotationAni.toValue = clockwise ? @(M_PI * 2) : @(M_PI * -2);
    self.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [self.layer addAnimation:rotationAni forKey:nil];
}

- (void)floatAnimationWithFloatAnimationType:(FloatAnimationType)floatAnimationType {
    [self floatAnimationWithUpDownSpace:floatAnimationUpDownSpace leftRightSpace:floatAnimationLeftRightSpace duration:floatAnimationDuration floatAnimationType:floatAnimationType];
}

/**
 平移动画
 
 @param upDownSpace 上下平移范围
 @param leftRightSpace 左右平移范围
 @param duration 动画时间>>>>>可以控制动画速度(时间长, 速度慢; 时间短, 速度快)
 @param floatAnimationType 动画类型
 */
- (void)floatAnimationWithUpDownSpace:(CGFloat)upDownSpace leftRightSpace:(CGFloat)leftRightSpace duration:(CGFloat)duration floatAnimationType:(FloatAnimationType)floatAnimationType {
    CAKeyframeAnimation *keyFrameAni = [[CAKeyframeAnimation alloc] init];
    NSValue *value2 = nil;
    NSValue *value4 = nil;
    switch (floatAnimationType) {
        case FloatAnimationUpToDown:
            value2 = [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y - upDownSpace)];
            value4 = [NSValue valueWithCGPoint:CGPointMake(self.center.x, self.center.y + upDownSpace)];
            break;
            
        case FloatAnimationLeftToRight:
            value2 = [NSValue valueWithCGPoint:CGPointMake(self.center.x - leftRightSpace, self.center.y)];
            value4 = [NSValue valueWithCGPoint:CGPointMake(self.center.x + leftRightSpace, self.center.y)];
            break;
            
        case FloatAnimationLeftUpToRightDown:
            value2 = [NSValue valueWithCGPoint:CGPointMake(self.center.x - leftRightSpace, self.center.y - upDownSpace)];
            value4 = [NSValue valueWithCGPoint:CGPointMake(self.center.x + leftRightSpace, self.center.y + upDownSpace)];
            break;
            
        case FloatAnimationLeftDownToRightUp:
            value2 = [NSValue valueWithCGPoint:CGPointMake(self.center.x + leftRightSpace, self.center.y - upDownSpace)];
            value4 = [NSValue valueWithCGPoint:CGPointMake(self.center.x - leftRightSpace, self.center.y + upDownSpace)];
            break;
            
        default:
            break;
    }
    
    keyFrameAni.values = @[value2, value4, value2];
    keyFrameAni.keyPath = @"position";
    keyFrameAni.repeatCount = MAXFLOAT;
    keyFrameAni.removedOnCompletion = false;
    keyFrameAni.fillMode = kCAFillModeForwards;
    keyFrameAni.duration = duration;
    keyFrameAni.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.layer addAnimation:keyFrameAni forKey:nil];
}

- (void)scaleAnimationWithDuration:(CGFloat)duration scaleAnimationType:(ScaleAnimationType)scaleAnimationType multiple:(CGFloat)multiple {
    CAKeyframeAnimation *rotationAni = [[CAKeyframeAnimation alloc] init];
    rotationAni.keyPath = @"transform.scale";
    rotationAni.fillMode = kCAFillModeForwards;
    rotationAni.removedOnCompletion = false;
    rotationAni.repeatCount = MAXFLOAT;
    rotationAni.duration = duration;
    rotationAni.values = @[@(1), @(multiple), @(1)];
    rotationAni.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    self.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [self.layer addAnimation:rotationAni forKey:nil];
}

- (void)alphaAnimationWithDuration:(CGFloat)duration fromValue:(CGFloat)fromValue toValue:(CGFloat)toValue {
    CAKeyframeAnimation *rotationAni = [[CAKeyframeAnimation alloc] init];
    rotationAni.keyPath = @"opacity";
    rotationAni.fillMode = kCAFillModeForwards;
    rotationAni.removedOnCompletion = false;
    rotationAni.repeatCount = MAXFLOAT;
    rotationAni.duration = duration;
    rotationAni.values = @[@(fromValue), @(toValue), @(fromValue)];
    rotationAni.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    self.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [self.layer addAnimation:rotationAni forKey:nil];
}

@end
