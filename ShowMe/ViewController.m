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
#import <ArrowheadMenu.h>
#import <GPUImage.h>

#define APPSIZE [[UIScreen mainScreen] bounds].size

#define ZHSTATUS_H            ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define ZHNAVBAR_H             44
#define ZHNAVALL_H             (ZHSTATUS_H + ZHNAVBAR_H)
#define WEAKSELF(classObject) __weak __typeof(classObject) weakSelfARC = classObject;

@interface ViewController () <UITextFieldDelegate,MenuViewControllerDelegate,UIScrollViewDelegate,YYTextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>


@property (nonatomic, strong) UITextField *inputField;
@property (nonatomic, strong) YYTextView *inputView;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIImageView *backgroundView;

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
     迷你简瘦金书           JSouJingSu
     */
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 20;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:20],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    
    

    _inputView = [[YYTextView alloc] init];
    _inputView.frame = CGRectMake(0, ZHNAVALL_H, APPSIZE.width, APPSIZE.height-ZHNAVALL_H-160);
    _inputView.placeholderText = @"愿这个世界  温柔以待";
    _inputView.backgroundColor = [UIColor whiteColor];
    _inputView.typingAttributes = attributes;
    _inputView.delegate = self;
    _inputView.textAlignment = NSTextAlignmentCenter;
    _inputView.font = [UIFont fontWithName:@"H-GungSeo" size:26];
    [self.view addSubview:_inputView];
    
    _backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APPSIZE.width, APPSIZE.height)];
    _backgroundView.image = [UIImage imageNamed:@"back"];
    _backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    [_inputView addSubview:_backgroundView];//设置背景图
    [_inputView insertSubview:_backgroundView atIndex:0];
    
    
    //moreBtn
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreBtn.frame = CGRectMake(20, _inputView.bottom + 20, self.view.width - 40, 40);
    [_moreBtn setTitle:@"更多设置" forState:UIControlStateNormal];
    [_moreBtn addTarget:self action:@selector(showMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    _moreBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _moreBtn.backgroundColor = [UIColor orangeColor];
    _moreBtn.titleLabel.textColor = [UIColor darkGrayColor];
    _moreBtn.layer.cornerRadius = 5;
    _moreBtn.layer.masksToBounds = YES;
    [self.view addSubview:_moreBtn];
    
    _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveBtn.frame = CGRectMake(20, _moreBtn.bottom + 20, self.view.width - 40, 40);
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
    
    size = CGSizeMake(_scrollView.contentSize.width, _scrollView.contentSize.height + 200);
//    _backgroundView.frame = CGRectMake(0, 0, APPSIZE.width, _scrollView.contentSize.height + 200);
//    _backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    
//    if (_scrollView.contentSize.height > [UIScreen mainScreen].bounds.size.height) {
//        size = _scrollView.contentSize;
//    } else {
//        size = view.size;
//    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    {
        CGPoint savedContentOffset = _scrollView.contentOffset;
        CGRect savedFrame = _scrollView.frame;
        _scrollView.contentOffset = CGPointZero;
        _scrollView.frame = CGRectMake(0, 0, size.width, size.height + 80);
        _backgroundView.frame = _scrollView.frame;
        [_scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        _scrollView.contentOffset = savedContentOffset;
        _scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    

    return image;
    
}

- (void)showMenuAction:(UIButton *)sender {
    
    ArrowheadMenu *VC = [[ArrowheadMenu alloc] initDefaultArrowheadMenuWithTitle:@[@"切换字体", @"字体大小", @"更改背景",@"对齐方式",@"背景模糊"] icon:nil menuPlacements:ShowAtTop];
    VC.delegate = self;
    [VC presentMenuView:sender];
    
}

#pragma mark - 菜单代理方法
- (void)menu:(BaseMenuViewController *)menu didClickedItemUnitWithTag:(NSInteger)tag andItemUnitTitle:(NSString *)title {

    NSLog(@"\n\n\n\n点击了第%lu项名字为%@的菜单项", tag, title);
    if (tag == 0) {
        [self changeFont];
    } else if (tag == 1) {
        [self changeSize];
    } else if (tag == 2) {
        [self changeBackImg];
    } else if (tag == 3) {
        [self changAligment];
    } else if (tag == 4) {
        [self blurBackImg];
    }

}

- (void)changeFont {

    NSArray *arrayTitle = @[@"系统字体",@"",@"",@"",@"",@""];
    NSArray *arrayImage = @[@"",@"可可童话体",@"默默谁想体",@"h-gongshu",@"pangzhonghuaxingshu",@"瘦金体"];
    WEAKSELF(self)
    
    [self.view createAlertViewTitleArray:arrayTitle arrayImage:arrayImage textColor:[UIColor blackColor] font:[UIFont systemFontOfSize:16] spacing:-15 actionBlock:^(UIButton * _Nullable button, NSInteger didRow) {
        //获取点击事件
        switch (didRow) {
            case 0:
                weakSelfARC.inputView.font = [UIFont systemFontOfSize:weakSelfARC.inputView.font.pointSize];
                break;
            case 1:
                weakSelfARC.inputView.font = [UIFont fontWithName:@"Undefined" size:weakSelfARC.inputView.font.pointSize];
                break;
            case 2:
                weakSelfARC.inputView.font = [UIFont fontWithName:@"suibixi-Regular" size:weakSelfARC.inputView.font.pointSize];
                break;
            case 3:
                weakSelfARC.inputView.font = [UIFont fontWithName:@"H-GungSeo" size:weakSelfARC.inputView.font.pointSize];
                break;
            case 4:
                weakSelfARC.inputView.font = [UIFont fontWithName:@"AMCSongGBK-Light" size:weakSelfARC.inputView.font.pointSize];
                break;
            case 5:
                weakSelfARC.inputView.font = [UIFont fontWithName:@"JSouJingSu" size:weakSelfARC.inputView.font.pointSize];
                break;
                
            default:
                break;
        }
    }];
}

- (void)changeSize {
    NSArray *arrayTitle = @[@"20",@"22",@"24",@"26",@"28",@"30",@"32",@"34",@"36",@"38",@"40"];
    UIColor *color = [UIColor blueColor];
    WEAKSELF(self)
    [self.view createAlertViewTitleArray:arrayTitle textColor:color font:[UIFont systemFontOfSize:16] actionBlock:^(UIButton * _Nullable button, NSInteger didRow) {
        //获取点击事件
        switch (didRow) {
            case 0:
                weakSelfARC.inputView.font = [UIFont fontWithName:weakSelfARC.inputView.font.fontName size:20];
                break;
            case 1:
                weakSelfARC.inputView.font = [UIFont fontWithName:weakSelfARC.inputView.font.fontName size:20];
                break;
            case 2:
                weakSelfARC.inputView.font = [UIFont fontWithName:weakSelfARC.inputView.font.fontName size:22];
                break;
            case 3:
                weakSelfARC.inputView.font = [UIFont fontWithName:weakSelfARC.inputView.font.fontName size:24];
                break;
            case 4:
                weakSelfARC.inputView.font = [UIFont fontWithName:weakSelfARC.inputView.font.fontName size:26];
                break;
            case 5:
                weakSelfARC.inputView.font = [UIFont fontWithName:weakSelfARC.inputView.font.fontName size:28];
                break;
            case 6:
                weakSelfARC.inputView.font = [UIFont fontWithName:weakSelfARC.inputView.font.fontName size:30];
                break;
            case 7:
                weakSelfARC.inputView.font = [UIFont fontWithName:weakSelfARC.inputView.font.fontName size:32];
                break;
            case 8:
                weakSelfARC.inputView.font = [UIFont fontWithName:weakSelfARC.inputView.font.fontName size:34];
                break;
            case 9:
                weakSelfARC.inputView.font = [UIFont fontWithName:weakSelfARC.inputView.font.fontName size:36];
                break;
            case 10:
                weakSelfARC.inputView.font = [UIFont fontWithName:weakSelfARC.inputView.font.fontName size:38];
                break;
            case 11:
                weakSelfARC.inputView.font = [UIFont fontWithName:weakSelfARC.inputView.font.fontName size:40];
                break;
                
            default:
                break;
        }
    }];

}

- (void)changeBackImg {
    NSArray *arrayTitle = @[@"空白背景",@"拍照",@"从手机相册选择",@"默认"];
    UIColor *color = [UIColor blackColor];
    WEAKSELF(self)
    [self.view createAlertViewTitleArray:arrayTitle textColor:color font:[UIFont systemFontOfSize:16] actionBlock:^(UIButton * _Nullable button, NSInteger didRow) {
        //获取点击事件
        switch (didRow) {
            case 0:
                [weakSelfARC remoeBackImge];
                break;
            case 1:
                [weakSelfARC takePhoto];
                break;
            case 2:
                [weakSelfARC selectPhoto];
                break;
            case 3:
                [weakSelfARC defaultImg];
                break;
        }
    }];
}

//空白背景
- (void)remoeBackImge {
    self.backgroundView.image = nil;
}

//默认
- (void)defaultImg {
    self.backgroundView.image = [UIImage imageNamed:@"back"];
}

//拍照
- (void)takePhoto {
    //UIImagePickerControllerSourceTypePhotoLibrary, 从所有相册选择
    //UIImagePickerControllerSourceTypeCamera, //拍一张照片
    //UIImagePickerControllerSourceTypeSavedPhotosAlbum//从moments选择一张照片
    //判断照相机能否使用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

//相册选择
- (void)selectPhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

//背景模糊
- (void)blurBackImg {
    UIImage *img = self.backgroundView.image;
    self.backgroundView.image = [self applyGaussianBlur:img];
}

#pragma mark - ******UIImagePickerControllerDelegate******
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    self.backgroundView.image = img;
    NSLog(@"%@",info);
}


- (void)changAligment {
    NSArray *arrayTitle = @[@"左对齐",@"居中",@"右对齐"];
    UIColor *color = [UIColor blackColor];
    WEAKSELF(self)
    [self.view createAlertViewTitleArray:arrayTitle textColor:color font:[UIFont systemFontOfSize:16] actionBlock:^(UIButton * _Nullable button, NSInteger didRow) {
        //获取点击事件
        switch (didRow) {
            case 0:
                weakSelfARC.inputView.textAlignment = NSTextAlignmentLeft;
                break;
            case 1:
                weakSelfARC.inputView.textAlignment = NSTextAlignmentCenter;
                break;
            case 2:
                weakSelfARC.inputView.textAlignment = NSTextAlignmentRight;
                break;
        }
    }];

}

- (UIImage *)applyGaussianBlur:(UIImage *)image
{
    GPUImageGaussianBlurFilter *filter = [[GPUImageGaussianBlurFilter alloc] init];
    filter.texelSpacingMultiplier = 5.0;
    filter.blurRadiusInPixels = 5.0;
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

- (void)btnAction:(UIButton *)sender {
    UIImage *img = [self convertCreateImageWithUIView:self.inputView];
    ShowImageViewController *showVC = [[ShowImageViewController alloc] initWithImage:img];
    [self.navigationController pushViewController:showVC animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"====");
    _backgroundView.frame = CGRectMake(scrollView.contentOffset.x, scrollView.contentOffset.y, APPSIZE.width, APPSIZE.height);
}


@end
