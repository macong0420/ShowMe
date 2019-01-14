//
//  MCHomeViewController.m
//  ShowMe
//
//  Created by 马聪聪 on 2019/1/11.
//  Copyright © 2019 马聪聪. All rights reserved.
//

#import "MCHomeViewController.h"
#import "MCDiraryCell.h"
#import <LYEmptyView/LYEmptyViewHeader.h>
#import "ViewController.h"
#import "EditViewController.h"

static NSString *const kMCDiraryCell = @"kMCDiraryCell";

@interface MCHomeViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *diaryArray;
@property (nonatomic, strong) UIButton *addBtn;


@end

@implementation MCHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //基础设置
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //去掉导航栏底部的黑线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    self.title = @"心情笔记";
    
    [self setupUI];
    
}

- (void)setupUI {
    _diaryArray = [NSMutableArray array];
    
    _tableview = [[UITableView alloc] init];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [_tableview registerClass:MCDiraryCell.class forCellReuseIdentifier:kMCDiraryCell];
    _tableview.frame = CGRectMake(0, ZHNAVALL_H, ZHSCREEN_Width, ZHSCREEN_Height-ZHNAVALL_H);
    UIView * footer = [[UIView alloc] initWithFrame:CGRectZero];
    _tableview.tableFooterView = footer;
    [self.view addSubview:_tableview];
    
    self.tableview.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"emptyImg"
                                                            titleStr:@"opps 啥都没有 快去添加吧"
                                                           detailStr:@"开启你的心情笔记之旅"];
    self.tableview.backgroundColor = [UIColor color16WithHexString:@"#ECECEC"];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat kbtnMargin = 0.15*ZHSCREEN_Width;
    addBtn.frame = CGRectMake(kbtnMargin, 0, ZHSCREEN_Width-kbtnMargin*2, 40);
    [addBtn setTitle:@"开启心情笔记" forState:UIControlStateNormal];
    addBtn.backgroundColor = [UIColor orangeColor];
    addBtn.bottom = ZHSCREEN_Height - 120;
    [addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.addBtn = addBtn;
    [self.tableview addSubview:addBtn];
    
}

- (void)addBtnAction:(UIButton *)sender {
    EditViewController *vc = [[EditViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
//    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

#pragma mark - tableView代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _diaryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MCDiraryCell *cell = [tableView dequeueReusableCellWithIdentifier:kMCDiraryCell];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 240;
}


@end
