//
//  SearchTableView.h
//  operation4ios
//
//  Created by sungrow on 2017/4/10.
//  Copyright © 2017年 阳光电源股份有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableView : UIViewController

@property (nonatomic, copy) void(^selectResultBlock)(NSInteger);
@property (nonatomic, assign) CGRect containerViewFrame;

- (instancetype)initWithTitle:(NSString *)title dataSource:(NSArray *)dataSource currentSelectIndex:(NSInteger)currentIndex;

@end
