//
//  ViewController.m
//  YQFuzzySearchView
//
//  Created by sungrow on 2017/6/5.
//  Copyright © 2017年 sungrow. All rights reserved.
//

#import "ViewController.h"
#import "SearchTableView.h"
#import "UIView+Animation.h"

@interface ViewController ()

@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, strong) UIView *blueView;
@property (nonatomic, strong) UIView *lightBlueView;

@end

@implementation ViewController

- (UIView *)lightBlueView {
    if (!_lightBlueView) {
        _lightBlueView = [[UIView alloc] init];
        _lightBlueView.backgroundColor = [UIColor colorWithRed:0 green:179/255.0 blue:199/255.0 alpha:1];
    }
    return _lightBlueView;
}

- (UIView *)blueView {
    if (!_blueView) {
        _blueView = [[UIView alloc] init];
        _blueView.backgroundColor = [UIColor blueColor];
    }
    return _blueView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lightBlueView.frame = CGRectMake(100, 40, 40, 40);
    self.lightBlueView.layer.cornerRadius = 20;
    self.blueView.frame = CGRectMake(100, 40, 4, 4);
    self.blueView.layer.cornerRadius = 2;
    self.blueView.center = self.lightBlueView.center;
    [self.view addSubview:self.lightBlueView];
    [self.view addSubview:self.blueView];
    [self.lightBlueView scaleAnimationWithDuration:1.5 scaleAnimationType:ScaleAnimationMinus multiple:0.1];
    [self.blueView scaleAnimationWithDuration:1.5 scaleAnimationType:ScaleAnimationPlus multiple:8];
    [self.blueView alphaAnimationWithDuration:1.5 fromValue:0.1 toValue:1.0];
    
    UIView *superView = [[UIView alloc] init];
    superView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:superView];
    superView.frame = CGRectMake(100, 200, 80, 70);
    
    UIView *firstV = [[UIView alloc] init];
    firstV.backgroundColor = [UIColor greenColor];
    firstV.frame = CGRectMake(10, 10, 20, 20);
    firstV.layer.cornerRadius = CGRectGetWidth(firstV.frame) * 0.5;
    [superView addSubview:firstV];
    
    UIView *secondV = [[UIView alloc] init];
    secondV.backgroundColor = [UIColor blueColor];
    secondV.frame = CGRectMake(0, 40, 20, 20);
    secondV.layer.cornerRadius = CGRectGetWidth(secondV.frame) * 0.5;
    [superView addSubview:secondV];
    CGPoint center = secondV.center;
    center.x = CGRectGetWidth(superView.frame) * 0.5;
    secondV.center = center;
    
    UIView *thirdV = [[UIView alloc] init];
    thirdV.backgroundColor = [UIColor redColor];
    thirdV.frame = CGRectMake(50, 10, 20, 20);
    thirdV.layer.cornerRadius = CGRectGetWidth(thirdV.frame) * 0.5;
    [superView addSubview:thirdV];
    
    [self performSelector:@selector(starAnimation:) withObject:firstV afterDelay:0.25];
    [self performSelector:@selector(starAnimation:) withObject:secondV afterDelay:0.5];
    [self performSelector:@selector(starAnimation:) withObject:thirdV afterDelay:0.75];
    
    [superView rotationAnimationWithDuration:2.0 rotationAnimationAxisType:RotationAnimationAxisZ clockwise:YES];
}

- (void)starAnimation:(UIView *)aniView {
    [aniView scaleAnimationWithDuration:0.75 scaleAnimationType:ScaleAnimationMinus multiple:0.4];
}

- (IBAction)searchButtonAction:(UIButton *)sender {
    SearchTableView *searchTableView = [[SearchTableView alloc] initWithTitle:@"测试搜索标题" dataSource:@[@"哈哈", @"呵呵", @"你的样子", @"环境", @"工具", @"还有什么", @"电脑", @"手机", @"书籍", @"窗户", @"按键", @"呵呵", @"你的样子", @"环境", @"工具", @"还有什么", @"电脑", @"手机", @"书籍", @"窗户", @"按键", @"qfasdf", @"1123dsad", @"ljofjsd", @"8080ifd", @"1yugjfs"] currentSelectIndex:self.selectIndex];
    [searchTableView setSelectResultBlock:^(NSInteger index){
        NSLog(@">>>>>>>>>>>>>> index = %zd", index);
        self.selectIndex = index;
    }];
    [self presentViewController:searchTableView animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
