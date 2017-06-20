//
//  SearchTableView.m
//  operation4ios
//
//  Created by sungrow on 2017/4/10.
//  Copyright © 2017年 阳光电源股份有限公司. All rights reserved.
//

#import "SearchTableView.h"
#import "YQFuzzySearchView-Swift.h"

@interface SearchTableView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSString *mainTitle;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *originDataSource;
@property (nonatomic, assign) NSInteger currentSelectIndex;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *searchTF;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) EmptyDataView *emptyDataView;
@property (nonatomic, strong) PopoverAnimator *popoverAnimator;

@end

static NSString *cellID = @"cellID";

@implementation SearchTableView

#pragma mark lazy
- (EmptyDataView *)emptyDataView {
    if (!_emptyDataView) {
        _emptyDataView = [[EmptyDataView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_emptyDataView];
        _emptyDataView.translatesAutoresizingMaskIntoConstraints = false;
        NSLayoutConstraint *emptyDataViewTop = [NSLayoutConstraint constraintWithItem:_emptyDataView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:100];
        NSLayoutConstraint *emptyDataViewLeft = [NSLayoutConstraint constraintWithItem:_emptyDataView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.tableView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *emptyDataViewRight = [NSLayoutConstraint constraintWithItem:_emptyDataView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.tableView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint *emptyDataViewBottom = [NSLayoutConstraint constraintWithItem:_emptyDataView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.tableView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        [self.view addConstraints:@[emptyDataViewTop, emptyDataViewLeft, emptyDataViewRight, emptyDataViewBottom]];
    }
    return _emptyDataView;
}

- (PopoverAnimator *)popoverAnimator {
    if (!_popoverAnimator) {
        _popoverAnimator = [[PopoverAnimator alloc] initWithCallBack:^(BOOL isShow) {
            NSLog(@"-----%zd", isShow);
        }];
    }
    return _popoverAnimator;
}

- (void)setContainerViewFrame:(CGRect)containerViewFrame {
    _containerViewFrame = containerViewFrame;
    _popoverAnimator.containerViewFrame = containerViewFrame;
}

- (void)dealloc {
    NSLog(@"释放了----");
}

- (instancetype)initWithTitle:(NSString *)title dataSource:(NSArray *)dataSource currentSelectIndex:(NSInteger)currentIndex {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self.popoverAnimator;
        self.mainTitle = title;
        self.originDataSource = dataSource;
        self.dataSource = dataSource;
        self.currentSelectIndex = currentIndex;
        [self createView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)createView {
    UIView *superView = self.view;
    superView.layer.cornerRadius = 8;
    superView.layer.masksToBounds = YES;
    superView.backgroundColor = [UIColor whiteColor];
    
    UIView *topLineView = [[UIView alloc] init];
    topLineView.backgroundColor = [UIColor whiteColor];
    [superView addSubview:topLineView];
    topLineView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *topLineViewTop = [NSLayoutConstraint constraintWithItem:topLineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *topLineViewLeft = [NSLayoutConstraint constraintWithItem:topLineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *topLineViewRight = [NSLayoutConstraint constraintWithItem:topLineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [superView addConstraints:@[topLineViewTop, topLineViewLeft, topLineViewRight]];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.text = self.mainTitle ? self.mainTitle : NSLocalizedString(@"请选择", nil);
    [superView addSubview:self.titleLabel];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *titleLabelTop = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1.0 constant:16];
    NSLayoutConstraint *titleLabelLeft = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:16];
    NSLayoutConstraint *titleLabelRight = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-16];
    NSLayoutConstraint *titleLabelBottom = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:topLineView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-8];
    [superView addConstraints:@[titleLabelTop, titleLabelLeft, titleLabelRight, titleLabelBottom]];
    
    self.searchTF = [[UITextField alloc] init];
    self.searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTF.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *leftImageV = [[UIImageView alloc] init];
    leftImageV.image = [UIImage imageNamed:@"search-ico-bk"];
    leftImageV.frame = CGRectMake(0, 0, leftImageV.image.size.width, leftImageV.image.size.height);
    self.searchTF.leftView = leftImageV;
    self.searchTF.placeholder = NSLocalizedString(@"请输入搜索关键字", nil);
    [self.searchTF addTarget:self action:@selector(textFieldShouldChange:) forControlEvents:UIControlEventEditingChanged];
    [superView addSubview:self.searchTF];
    self.searchTF.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *searchTFTop = [NSLayoutConstraint constraintWithItem:self.searchTF attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:topLineView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:8];
    NSLayoutConstraint *searchTFLeft = [NSLayoutConstraint constraintWithItem:self.searchTF attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *searchTFRight = [NSLayoutConstraint constraintWithItem:self.searchTF attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [superView addConstraints:@[searchTFTop, searchTFLeft, searchTFRight]];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor blackColor];
    [superView addSubview:lineView];
    lineView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *lineViewTop = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.searchTF attribute:NSLayoutAttributeBottom multiplier:1.0 constant:8];
    NSLayoutConstraint *lineViewLeft = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.searchTF attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *lineViewRight = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.searchTF attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint *lineViewHgieht = [NSLayoutConstraint constraintWithItem:lineView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.5];
    [superView addConstraints:@[lineViewTop, lineViewLeft, lineViewRight, lineViewHgieht]];
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self.cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
//    self.cancelButton.layer.cornerRadius = 3;
//    self.cancelButton.layer.borderColor = [UIColor buttonColor].CGColor;
//    self.cancelButton.layer.borderWidth = 1;
    [superView addSubview:self.cancelButton];
    self.cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *cancelButtonLeft = [NSLayoutConstraint constraintWithItem:self.cancelButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.searchTF attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *cancelButtonRight = [NSLayoutConstraint constraintWithItem:self.cancelButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.searchTF attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint *cancelButtonBottom = [NSLayoutConstraint constraintWithItem:self.cancelButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-16];
    [superView addConstraints:@[cancelButtonBottom, cancelButtonLeft, cancelButtonRight, lineViewHgieht]];
    
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = [UIColor whiteColor];
    [superView addSubview:bottomLineView];
    bottomLineView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *bottomLineViewTop = [NSLayoutConstraint constraintWithItem:bottomLineView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.cancelButton attribute:NSLayoutAttributeBottom multiplier:1.0 constant:8];
    NSLayoutConstraint *bottomLineViewLeft = [NSLayoutConstraint constraintWithItem:bottomLineView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *bottomLineViewRight = [NSLayoutConstraint constraintWithItem:bottomLineView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint *bottomLineViewBottom = [NSLayoutConstraint constraintWithItem:bottomLineView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [superView addConstraints:@[bottomLineViewTop, bottomLineViewLeft, bottomLineViewRight, bottomLineViewBottom]];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 44;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [superView addSubview:self.tableView];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *tableViewTop = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:lineView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:8];
    NSLayoutConstraint *tableViewLeft = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.searchTF attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *tableViewRight = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.searchTF attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    NSLayoutConstraint *tableViewBottom = [NSLayoutConstraint constraintWithItem:self.tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.cancelButton attribute:NSLayoutAttributeTop multiplier:1.0 constant:-8];
    [superView addConstraints:@[tableViewTop, tableViewLeft, tableViewRight, tableViewBottom]];
    
    if (self.currentSelectIndex >= 0 && self.currentSelectIndex < self.dataSource.count) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.currentSelectIndex inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
}

#pragma mark action
- (void)cancelAction:(UIButton *)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textFieldShouldChange:(UITextField *)textField {
    if (textField.text.length <= 0) {
        self.dataSource = self.originDataSource;
    } else {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",textField.text];
        self.dataSource = [self.originDataSource filteredArrayUsingPredicate:pred];
    }
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.emptyDataView.hidden = self.dataSource.count > 0;
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.highlightedTextColor = [UIColor blueColor];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.dataSource[indexPath.row]];
    return  cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id obj = self.dataSource[indexPath.row];
    NSInteger index = [self.originDataSource indexOfObject:obj];
    if (index >= self.originDataSource.count) {
        index = self.originDataSource.count - 1;
    }
    if (index < 0) {
        index = 0;
    }
    !self.selectResultBlock ? : self.selectResultBlock(index);
    [self cancelAction:self.cancelButton];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

@end
