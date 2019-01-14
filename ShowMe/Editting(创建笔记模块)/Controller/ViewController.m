//
//  ViewController.m
//  ShowMe
//
//  Created by 马聪聪 on 2018/12/28.
//  Copyright © 2018 马聪聪. All rights reserved.
//

#import "ViewController.h"
#import <YYKit.h>
#import <NSAttributedString+YYText.h>
#import "ShowImageViewController.h"
#import <UIViewController+YCPopover.h>
#import "UIView+LLXAlertPop.h"
#import <ArrowheadMenu.h>
#import <GPUImage.h>

#import <POP.h>
#import "ChangeFontView.h"
#import "MCEditTopCoverView.h"

#define APPSIZE [[UIScreen mainScreen] bounds].size

#define ZHSTATUS_H            ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define ZHNAVBAR_H             44
#define ZHNAVALL_H             (ZHSTATUS_H + ZHNAVBAR_H)
#define WEAKSELF(classObject) __weak __typeof(classObject) weakSelfARC = classObject;

static CGFloat kImgBtnW = 44;
static CGFloat kMoreSettingBtnH = 50;
static CGFloat kTitleLabelW = 100;

@interface ViewController () < UITextFieldDelegate,MenuViewControllerDelegate,
                               UIScrollViewDelegate,YYTextViewDelegate,UIImagePickerControllerDelegate,
                               UINavigationControllerDelegate,MCEditTopCoverViewDelegate
                             >


@property (nonatomic, strong) YYTextView *inputView;
@property (nonatomic, strong) UIButton *saveBtn;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIImageView *backgroundView;
@property (nonatomic, strong) UIImage *backImg;

@property (nonatomic, strong) UIButton *insertImgBtn; //插入图片
@property (nonatomic, strong) UILabel *insertTitleLabel;

@property (nonatomic, strong) UIButton *moreSettingBtn; //更是设置
@property (nonatomic, strong) UILabel *moreTitleLabel;

@property (nonatomic, strong) UIButton *createImgBtn; //生成更多图片
@property (nonatomic, strong) UILabel *createTitleLabel;

@property (nonatomic, strong) UIView *moreSettingView;

@property (nonatomic, strong) NSMutableAttributedString *contentText;

@property (nonatomic, strong) UIFont *userSettingFont;

@property (nonatomic,copy) NSString *inputStr;

@property (nonatomic) BOOL hiddenMoreBtn;
@property (nonatomic) BOOL isInsert; //是否是插入图片操作
@property (nonatomic) BOOL isTopCoverInsert;

@property (nonatomic, strong) UITextField *titleField;//标题
@property (nonatomic, strong) MCEditTopCoverView *topCoverImgView;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - 控件初始化
- (void)setupUI {
    
    //基础设置
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    //去掉导航栏底部的黑线
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,30,30)];
    [rightButton setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(saveDiaryAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _topCoverImgView = [[MCEditTopCoverView alloc] initWithFrame:CGRectMake(0, ZHNAVALL_H, ZHSCREEN_Width, ZHSCREEN_Width*0.8)];
    _topCoverImgView.delegate = self;
    [self.view addSubview:_topCoverImgView];
    
    //标题
    _titleField = [[UITextField alloc] init];
    _titleField.placeholder = @"Title";
    _titleField.font = [UIFont boldSystemFontOfSize:24];
    _titleField.textAlignment = NSTextAlignmentCenter;
    _titleField.frame = CGRectMake(20, _topCoverImgView.bottom+10, ZHSCREEN_Width-40, 30);
    [self.view addSubview:_titleField];
    
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
    _inputView.frame = CGRectMake(0, _titleField.bottom + 50, APPSIZE.width, APPSIZE.height-ZHNAVALL_H);
    _inputView.placeholderText = @"愿这个世界  温柔以待";
    _inputView.backgroundColor = [UIColor whiteColor];
    _inputView.typingAttributes = attributes;
    _inputView.delegate = self;
    _inputView.textAlignment = NSTextAlignmentLeft;
//    _inputView.font = [UIFont fontWithName:@"H-GungSeo" size:26];
    _inputView.font = [UIFont systemFontOfSize:16];
    _inputView.textContainerInset = UIEdgeInsetsMake(30, 10, 64, 10);
    [self.view addSubview:_inputView];
    self.userSettingFont = _inputView.font;
    
    _backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, APPSIZE.width, APPSIZE.height)];
    _backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    
    
    [_inputView addSubview:_backgroundView];//设置背景图
    [_inputView insertSubview:_backgroundView atIndex:0];

    //moreBtn
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreBtn.frame = CGRectMake(0, _inputView.bottom - 50, 44, 44);
    _moreBtn.centerX = self.view.centerX;
    [_moreBtn setImage:[UIImage imageNamed:@"jiahao"] forState:UIControlStateNormal];
    [_moreBtn addTarget:self action:@selector(showMenuAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_moreBtn];

    UIImage *insetImg = [UIImage imageNamed:@"sina_图片"];
    UIImage *insetImg2 = [UIImage imageNamed:@"sina_更多设置"];
    UIImage *insetImg3 = [UIImage imageNamed:@"sina_生成文字图片"];
    
    _insertImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _insertImgBtn.frame = CGRectMake(20, APPSIZE.height, kImgBtnW, kImgBtnW);
    [_insertImgBtn setImage:insetImg forState:UIControlStateNormal];
    _insertImgBtn.tag = 10001;
    [self.view addSubview:_insertImgBtn];
    
    _insertTitleLabel = [self createTitleWithTitle:@"插入图片"];
    
    _moreSettingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreSettingBtn.frame = CGRectMake(20, APPSIZE.height, kImgBtnW, kImgBtnW);
    _moreSettingBtn.centerX = self.view.centerX;
    _moreSettingBtn.tag = 10002;
    [_moreSettingBtn setImage:insetImg2 forState:UIControlStateNormal];
    [self.view addSubview:_moreSettingBtn];
    
    _moreTitleLabel = [self createTitleWithTitle:@"更多设置"];
    
    _createImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _createImgBtn.frame = CGRectMake(20, APPSIZE.height, kImgBtnW, kImgBtnW);
    [_createImgBtn setImage:insetImg3 forState:UIControlStateNormal];
    _createImgBtn.tag = 10003;
    [self.view addSubview:_createImgBtn];
    
    _createTitleLabel = [self createTitleWithTitle:@"生成图片"];
    
    _insertImgBtn.right = _moreSettingBtn.left - 40;
    _createImgBtn.left = _moreSettingBtn.right + 40;
    
    _insertTitleLabel.right = _insertImgBtn.right;
    _insertTitleLabel.textAlignment = NSTextAlignmentRight;
    
    _moreTitleLabel.centerX = _moreSettingBtn.centerX;
    
    _createTitleLabel.left = _createImgBtn.left;
    _createTitleLabel.textAlignment = NSTextAlignmentLeft;
    
    [_insertImgBtn addTarget:self action:@selector(imgButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_moreSettingBtn addTarget:self action:@selector(imgButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_createImgBtn addTarget:self action:@selector(imgButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self logFont];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
}

- (void)saveDiaryAction:(UIButton *)sender {
    
}

#pragma mark - 显示更多
- (void)showMenuAction:(UIButton *)sender {
    if (self.hiddenMoreBtn) {
        [self hiddenMoreBtnAction];
    } else {
        [self showMoreBtn];
    }
}

///三个按钮出现
- (void)showMoreBtn {
    POPSpringAnimation *basicAnimation = [POPSpringAnimation animation];
    basicAnimation.property = [POPAnimatableProperty propertyWithName: kPOPLayerRotation];
    basicAnimation.toValue= @(M_PI/4); //2 M_PI is an entire rotation
    [_moreBtn.layer pop_addAnimation:basicAnimation forKey:@"kPOPLayerRotation"];
    
    POPSpringAnimation *basicAnimationY = [POPSpringAnimation animation];
    basicAnimationY.property = [POPAnimatableProperty propertyWithName: kPOPLayerPositionY];
    basicAnimationY.toValue= @(APPSIZE.height - 64 - 40);
    [_insertImgBtn.layer pop_addAnimation:basicAnimationY forKey:@"kPOPLayerPositionY"];
    [_moreSettingBtn.layer pop_addAnimation:basicAnimationY forKey:@"kPOPLayerPositionY"];
    [_createImgBtn.layer pop_addAnimation:basicAnimationY forKey:@"kPOPLayerPositionY"];
    
    [_insertTitleLabel.layer pop_addAnimation:basicAnimationY forKey:@"kPOPLayerPositionY"];
    [_moreTitleLabel.layer pop_addAnimation:basicAnimationY forKey:@"kPOPLayerPositionY"];
    [_createTitleLabel.layer pop_addAnimation:basicAnimationY forKey:@"kPOPLayerPositionY"];
    
    self.hiddenMoreBtn = YES;
}

///三个按钮消失
- (void)hiddenMoreBtnAction {
    self.hiddenMoreBtn = NO;
    
    POPSpringAnimation *basicAnimation = [POPSpringAnimation animation];
    basicAnimation.property = [POPAnimatableProperty propertyWithName: kPOPLayerRotation];
    basicAnimation.toValue= @(-(M_PI*1/400));
    [_moreBtn.layer pop_addAnimation:basicAnimation forKey:@"kPOPLayerRotation"];
    
    ///三个按钮出现
    POPSpringAnimation *basicAnimationY = [POPSpringAnimation animation];
    basicAnimationY.property = [POPAnimatableProperty propertyWithName: kPOPLayerPositionY];
    basicAnimationY.toValue= @(APPSIZE.height+ 64);
    [_insertImgBtn.layer pop_addAnimation:basicAnimationY forKey:@"kPOPLayerPositionY"];
    [_moreSettingBtn.layer pop_addAnimation:basicAnimationY forKey:@"kPOPLayerPositionY"];
    [_createImgBtn.layer pop_addAnimation:basicAnimationY forKey:@"kPOPLayerPositionY"];
    
    [_insertTitleLabel.layer pop_addAnimation:basicAnimationY forKey:@"kPOPLayerPositionY"];
    [_moreTitleLabel.layer pop_addAnimation:basicAnimationY forKey:@"kPOPLayerPositionY"];
    [_createTitleLabel.layer pop_addAnimation:basicAnimationY forKey:@"kPOPLayerPositionY"];
    
    _insertTitleLabel.top = _insertImgBtn.bottom + 10;
    _moreTitleLabel.top = _insertImgBtn.bottom + 10;
    _moreTitleLabel.top = _insertImgBtn.bottom + 10;
}

- (void)imgButtonAction:(UIButton *)sender {
    [self hiddenMoreBtnAction];
    switch (sender.tag) {
        case 10001:
            [self insetImgIsInset:YES isTopCoverInsert:NO];
            break;
        case 10002:
            [self moreSetting];
            break;
        case 10003:
            [self createImage];
            break;
    }
}

- (void)topCoverViewInsertImg {
    [self insetImgIsInset:NO isTopCoverInsert:YES];
}

#pragma mark - 插入图片
- (void)insetImgIsInset:(BOOL)isInset isTopCoverInsert:(BOOL)isTopCoverInsert {
    self.isInsert = isInset;
    self.isTopCoverInsert = isTopCoverInsert;
    NSArray *arrayTitle = @[@"拍照",@"从手机相册选择"];
    UIColor *color = [UIColor blackColor];
    WEAKSELF(self)
    [self.view createAlertViewTitleArray:arrayTitle textColor:color font:[UIFont systemFontOfSize:16] actionBlock:^(UIButton * _Nullable button, NSInteger didRow) {
        //获取点击事件
        switch (didRow) {
            case 0:
                [weakSelfARC takePhoto];
                break;
            case 1:
                [weakSelfARC selectPhoto];
                break;
        }
    }];
}


#pragma mark - 更多设置
- (void)moreSetting {
    
    NSArray *arrayTitle = @[@"切换字体", @"字体大小", @"更改背景",@"对齐方式",@"背景模糊",@"取消"];
    
    for (int i = 0; i < arrayTitle.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:arrayTitle[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:20];
        btn.backgroundColor = [UIColor whiteColor];
        btn.frame = CGRectMake(0, i*kMoreSettingBtnH, APPSIZE.width, kMoreSettingBtnH);
        btn.tag = 333 + i;
        [btn addTarget:self action:@selector(moresettingBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.moreSettingView addSubview:btn];
        
        if (i > 0) {
            UIView *lineView = [[UIView alloc] init];
            lineView.frame = CGRectMake(0, i*kMoreSettingBtnH, APPSIZE.width, 0.5);
            lineView.backgroundColor = [UIColor lightGrayColor];
            [self.moreSettingView addSubview:lineView];
        }
    }
    self.moreSettingView.height = arrayTitle.count * kMoreSettingBtnH;
    
    POPSpringAnimation *basicAnimationY = [POPSpringAnimation animation];
    basicAnimationY.property = [POPAnimatableProperty propertyWithName: kPOPLayerPositionY];
    basicAnimationY.toValue= @(APPSIZE.height - kMoreSettingBtnH*3);
    
    [self.moreSettingView.layer pop_addAnimation:basicAnimationY forKey:@"kPOPLayerPositionY"];
    
}

- (void)moresettingBtnAction:(UIButton *)sender {
    [self closeMoresettingView];
    switch (sender.tag) {
        case 333:
            [self changeFont];
            break;
        case 334:
            [self changeSize];
            break;
        case 335:
            [self changeBackImg];
            break;
        case 336:
            [self changAligment];
            break;
        case 337:
            [self blurBackImg];
            break;
        case 338:
            [self closeMoresettingView];
            break;
            
        default:
            break;
    }
}

//更改字体
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
    
    self.userSettingFont = _inputView.font;
}

//字体大小
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
    
    self.userSettingFont = _inputView.font;

}

//更改背景
- (void)changeBackImg {
    self.isInsert = NO;
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

//对齐方式
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

//背景模糊
- (void)blurBackImg {
    UIImage *blurImg = [self applyGaussianBlur:self.backImg];
    self.backgroundView.image = blurImg;
}

//空白背景
- (void)remoeBackImge {
    self.backgroundView.image = nil;
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

//默认
- (void)defaultImg {
    self.backgroundView.image = [UIImage imageNamed:@"back"];
}

#pragma mark - ******UIImagePickerControllerDelegate******
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    
    if (self.isInsert) {
        [self insertImage:img];
        self.inputView.font = self.userSettingFont;
    } else if (self.isTopCoverInsert) {
        self.topCoverImgView.coverImgView.image = img;
    } else {
        self.backImg = img;
        self.backgroundView.image = img;
    }
}

#pragma mark - 图文混排 插入图片
- (void)insertImage:(UIImage *)img {
    //创建最主要的attribute文本
    NSMutableAttributedString *contentText = self.inputView.attributedText.mutableCopy;
    //图片资源
    YYImage *image = (YYImage *)img;
    //添加文本+图片
    YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
    imageView.layer.cornerRadius = 8;
    imageView.layer.masksToBounds = YES;
    imageView.frame = CGRectMake(0, 0, self.inputView.width - 20, self.inputView.width/image.size.width*image.size.height);
    NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.size alignToFont:self.userSettingFont alignment:YYTextVerticalAlignmentCenter];
    
    [contentText appendAttributedString:attachText];
    self.inputView.attributedText = contentText;
    self.contentText = contentText;
    
    NSMutableAttributedString *lineBreakKey = [[NSMutableAttributedString alloc] initWithString:@"\n\n\n"];
    lineBreakKey.font = self.userSettingFont;
    [contentText appendAttributedString:lineBreakKey];
    
    self.inputView.selectedRange = NSMakeRange(contentText.length, 0);
    self.contentText = contentText;
    [self.inputView becomeFirstResponder];
}

- (BOOL)textViewShouldBeginEditing:(YYTextView *)textView {

    if (self.isInsert && self.inputView.text.length) {
        NSString *str0 = @"";
        NSDictionary *dictAttr0 = @{NSFontAttributeName:self.userSettingFont};
        NSAttributedString *attr0 = [[NSAttributedString alloc]initWithString:str0 attributes:dictAttr0];
        [self.contentText appendAttributedString:attr0];
        
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.alignment = self.inputView.textAlignment;
        [self.contentText addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, self.contentText.length)];
        
        self.inputView.attributedText = self.contentText;
        self.inputView.selectedRange = NSMakeRange(self.contentText.length, 0);
    }
    return YES;
}

- (void)textViewDidChange:(YYTextView *)textView {
    self.inputStr = textView.text;
    NSLog(@"%@",textView.text);
}

- (void)textViewDidBeginEditing:(YYTextView *)textView {
    self.isInsert = NO;
}

#pragma mark - 辅助方法

- (UILabel *)createTitleWithTitle:(NSString *)title {
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
    label.width = kTitleLabelW;
    label.top = _insertImgBtn.bottom + 10;
    label.height = 14;
    [self.view addSubview:label];
    return label;
}
//虚化
- (UIImage *)applyGaussianBlur:(UIImage *)image {
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

- (void)createImage {
    UIImage *img = [self convertCreateImageWithUIView:self.inputView];
    ShowImageViewController *showVC = [[ShowImageViewController alloc] initWithImage:img];
    [self.navigationController pushViewController:showVC animated:YES];
}

- (UIImage *)convertCreateImageWithUIView:(UIView *)view {
    UIImage* image = nil;
    
    UIScrollView *_scrollView = (UIScrollView *)view;
    CGSize size = CGSizeZero;
    size = CGSizeMake(_scrollView.contentSize.width, _scrollView.contentSize.height + 200);
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

- (void)closeMoresettingView {
    POPSpringAnimation *basicAnimationY = [POPSpringAnimation animation];
    basicAnimationY.property = [POPAnimatableProperty propertyWithName: kPOPLayerPositionY];
    basicAnimationY.toValue= @(APPSIZE.height + kMoreSettingBtnH*3);
    
    [self.moreSettingView.layer pop_addAnimation:basicAnimationY forKey:@"kPOPLayerPositionY"];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _backgroundView.frame = CGRectMake(scrollView.contentOffset.x, scrollView.contentOffset.y, APPSIZE.width, APPSIZE.height);
}

- (UIView *)moreSettingView {
    if (!_moreSettingView) {
        _moreSettingView = [[UIView alloc] init];
        _moreSettingView.frame = CGRectMake(0, APPSIZE.height + 20, APPSIZE.width, 0);
        _moreSettingView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_moreSettingView];
    }
    return _moreSettingView;
}

- (void)logFont {
    // 打印字体
     NSMutableArray * fontArray = [[NSMutableArray alloc] init];
     for (NSString * familyName in [UIFont familyNames]) {
         NSLog(@"Font FamilyName = %@",familyName);
         //输出字体族科名字
         for (NSString * fontName in [UIFont fontNamesForFamilyName:familyName]) {
             NSLog(@"Font  %@",fontName);
             [fontArray addObject:fontName];
         }
     }
}

@end
