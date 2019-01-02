//
//  ViewController.m
//  ShowMe
//
//  Created by 马聪聪 on 2018/12/28.
//  Copyright © 2018 马聪聪. All rights reserved.
//

#import "ViewController.h"
#import <YYKit.h>
#import "ShowImageViewController.h"
#import <UIViewController+YCPopover.h>
#import "UIView+LLXAlertPop.h"

#define APPSIZE [[UIScreen mainScreen] bounds].size

#define ZHSTATUS_H            ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define ZHNAVBAR_H             44
#define ZHNAVALL_H             (ZHSTATUS_H + ZHNAVBAR_H)

@interface ViewController () <UITextFieldDelegate>

{
    UILabel *lab;
}

@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) YYTextView *inputView;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UIButton *changeFontBtn;
@property (nonatomic, strong) UIButton *changSizeBtn;
@property (nonatomic, strong) UILabel *dateLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI {
    
    /*
     H-宫书                H-GungSeo
     可可童话体             Undefined
     默默随想               suibixi-Regular
     庞中华行书             AMCSongGBK-Light
     */
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 20;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:20],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    
    

    _inputView = [[YYTextView alloc] init];
    _inputView.frame = CGRectMake(20, ZHNAVALL_H + 20, APPSIZE.width-40, APPSIZE.height-ZHNAVALL_H-160);
    _inputView.placeholderText = @"愿这个世界  温柔以待";
    _inputView.font = [UIFont systemFontOfSize:20];
    _inputView.backgroundColor = [UIColor whiteColor];
    _inputView.typingAttributes = attributes;
    _inputView.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_inputView];
    
    _changeFontBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _changeFontBtn.frame = CGRectMake(20,_inputView.bottom + 20, (self.view.width - 40)/2 - 10, 40);
    [_changeFontBtn setTitle:@"切换字体" forState:UIControlStateNormal];
    [_changeFontBtn addTarget:self action:@selector(changeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _changeFontBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _changeFontBtn.backgroundColor = [UIColor orangeColor];
    _changeFontBtn.titleLabel.textColor = [UIColor darkGrayColor];
    _changeFontBtn.layer.cornerRadius = 5;
    _changeFontBtn.layer.masksToBounds = YES;
    [self.view addSubview:_changeFontBtn];
    
    //changSizeBtn
    _changSizeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _changSizeBtn.frame = CGRectMake(_changeFontBtn.right+20,_inputView.bottom + 20, (self.view.width - 40)/2 - 10, 40);
    [_changSizeBtn setTitle:@"字体大小" forState:UIControlStateNormal];
    [_changSizeBtn addTarget:self action:@selector(changeSizeAction) forControlEvents:UIControlEventTouchUpInside];
    _changSizeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _changSizeBtn.backgroundColor = [UIColor orangeColor];
    _changSizeBtn.titleLabel.textColor = [UIColor darkGrayColor];
    _changSizeBtn.layer.cornerRadius = 5;
    _changSizeBtn.layer.masksToBounds = YES;
    [self.view addSubview:_changSizeBtn];
    
    _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveBtn.frame = CGRectMake(20, _changeFontBtn.bottom + 20, self.view.width - 40, 40);
    [_saveBtn setTitle:@"生成文字图片" forState:UIControlStateNormal];
    [_saveBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    _saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _saveBtn.backgroundColor = [UIColor orangeColor];
    _saveBtn.titleLabel.textColor = [UIColor darkGrayColor];
    _saveBtn.layer.cornerRadius = 5;
    _saveBtn.layer.masksToBounds = YES;
    [self.view addSubview:_saveBtn];
    
    NSMutableArray * fontArray = [[NSMutableArray alloc] init];
    for (NSString * familyName in [UIFont familyNames]) {
    NSLog(@"Font FamilyName = %@",familyName);
    //*输出字体族科名字
    for (NSString * fontName in [UIFont fontNamesForFamilyName:familyName]) {
    NSLog(@"Font  %@",fontName);
    [fontArray addObject:fontName];
    }
    }
    

    
}

- (UIImage *)convertCreateImageWithUIView:(UIView *)view {
    UIImage* image = nil;
    
    UIScrollView *_scrollView = (UIScrollView *)view;
    CGSize size = CGSizeZero;
    if (_scrollView.contentSize.height > [UIScreen mainScreen].bounds.size.height) {
        size = _scrollView.contentSize;
    } else {
        size = view.size;
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    {
        CGPoint savedContentOffset = _scrollView.contentOffset;
        CGRect savedFrame = _scrollView.frame;
        _scrollView.contentOffset = CGPointZero;
        _scrollView.frame = CGRectMake(0, 0, size.width, size.height + 80);
        [_scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        _scrollView.contentOffset = savedContentOffset;
        _scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    

    return image;
    
}

- (void)changeBtnAction:(UIButton *)sender {

    
    NSArray *arrayTitle = @[@"系统字体",@"",@"",@"",@""];
    
    NSArray *arrayImage = @[@"",@"可可童话体",@"默默谁想体",@"h-gongshu",@"pangzhonghuaxingshu"];
    /*
     H-宫书                H-GungSeo
     可可童话体             Undefined
     默默随想               suibixi-Regular
     */
    
    [self.view createAlertViewTitleArray:arrayTitle arrayImage:arrayImage textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:16] spacing:-15 actionBlock:^(UIButton * _Nullable button, NSInteger didRow) {
        //获取点击事件
        NSLog(@"%@,%ld",button.currentTitle,(long)didRow);
        lab.text = [NSString stringWithFormat:@"%@,下标%ld",button.currentTitle,(long)didRow];
        switch (didRow) {
            case 1:
                _inputView.font = [UIFont fontWithName:@"Undefined" size:20];
                break;
            case 2:
                _inputView.font = [UIFont fontWithName:@"suibixi-Regular" size:20];
                break;
            case 3:
                _inputView.font = [UIFont fontWithName:@"H-GungSeo" size:20];
                break;
            case 4:
                _inputView.font = [UIFont fontWithName:@"AMCSongGBK-Light" size:20];
                break;
                
            default:
                break;
        }
    }];
}

- (void)changeSizeAction {
    
    
    NSArray *arrayTitle = @[@"20",@"22",@"24",@"26",@"28",@"30",@"32",@"34",@"36",@"38",@"40"];
    
    UIColor *color = [UIColor blueColor];
    
    [self.view createAlertViewTitleArray:arrayTitle textColor:color font:[UIFont systemFontOfSize:16] actionBlock:^(UIButton * _Nullable button, NSInteger didRow) {
        //获取点击事件
        switch (didRow) {
            case 1:
                _inputView.font = [UIFont fontWithName:_inputView.font.fontName size:20];
                break;
            case 2:
                _inputView.font = [UIFont fontWithName:_inputView.font.fontName size:22];
                break;
            case 3:
                _inputView.font = [UIFont fontWithName:_inputView.font.fontName size:24];
                break;
            case 4:
                _inputView.font = [UIFont fontWithName:_inputView.font.fontName size:26];
                break;
            case 5:
                _inputView.font = [UIFont fontWithName:_inputView.font.fontName size:28];
                break;
            case 6:
                _inputView.font = [UIFont fontWithName:_inputView.font.fontName size:30];
                break;
            case 7:
                _inputView.font = [UIFont fontWithName:_inputView.font.fontName size:32];
                break;
            case 8:
                _inputView.font = [UIFont fontWithName:_inputView.font.fontName size:34];
                break;
            case 9:
                _inputView.font = [UIFont fontWithName:_inputView.font.fontName size:36];
                break;
            case 10:
                _inputView.font = [UIFont fontWithName:_inputView.font.fontName size:38];
                break;
            case 11:
                _inputView.font = [UIFont fontWithName:_inputView.font.fontName size:40];
                break;
                
            default:
                break;
        }
    }];

}

- (void)btnAction:(UIButton *)sender {
    
    UIImage *img = [self convertCreateImageWithUIView:self.inputView];
    NSLog(@"-====");
    
    
    ShowImageViewController *showVC = [[ShowImageViewController alloc] initWithImage:img];
    
    [self.navigationController pushViewController:showVC animated:YES];
    
}




@end
