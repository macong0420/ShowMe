//
//  EditViewController.m
//  ShowMe
//
//  Created by 马聪聪 on 2019/1/14.
//  Copyright © 2019 马聪聪. All rights reserved.
//

#import "EditViewController.h"
#import "MCEditTopCoverView.h"
#import "EditTableViewCell.h"
#import "EditInputView.h"
#import "UIView+LLXAlertPop.h"
#import "EditBaseScrollview.h"
#import "EditKeyBoardTopView.h"
#import "EditModle.h"
#import "MCHomeViewController.h"

@interface EditViewController () <UIScrollViewDelegate,MCEditTopCoverViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,EditKeyBoardTopViewDelegate,YYTextViewDelegate,
                                  UITextFieldDelegate>

@property (nonatomic, strong) EditBaseScrollview *baseScrollView; //基scroll
@property (nonatomic, strong) MCEditTopCoverView *topCoverImgView;
@property (nonatomic, strong) EditInputView *editInputView;
@property (nonatomic, strong) EditKeyBoardTopView *keyBoardTopView;
@property (nonatomic, strong) EditModle *model;

@property (nonatomic, strong) UIFont *userSettingFont;
@property (nonatomic, strong) NSMutableAttributedString *contentText;

@property (nonatomic, copy) NSString *inputStr;

///保存模型
@property (nonatomic,copy) NSString *modleTitle;
@property (nonatomic, strong) UIImage *coverImg;

@property (nonatomic) BOOL isInsert; //是否是插入图片操作
@property (nonatomic) BOOL isTopCoverInsert;


@end

@implementation EditViewController

- (instancetype)initWithEditModel:(EditModle *)modle {
    if (self = [super init]) {
        if (modle) {
            [self setupUI];
            _model = modle;
            [self buildDiary];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)setupUI {
    
    _topCoverImgView = [[MCEditTopCoverView alloc] initWithFrame:CGRectMake(0, ZHNAVALL_H, ZHSCREEN_Width, ZHSCREEN_Width*0.8)];
    _topCoverImgView.delegate = self;
    [self.view addSubview:_topCoverImgView];
    [self.view addSubview:self.baseScrollView];
    [self.baseScrollView addSubview:self.editInputView];
    self.baseScrollView.underButton = self.topCoverImgView.coverAddImgBtn;
    
}

- (void)buildDiary {
    self.topCoverImgView.coverImgView.image = self.model.coverImg;
    self.editInputView.titleField.text = self.model.title;
    self.editInputView.inputView.attributedText = self.model.contentText;
    self.editInputView.inputView.selectedRange = NSMakeRange(self.model.contentText.length, 0);
}

#pragma mark - 键盘操作代理
- (void)editdidClick:(EditKeyBoardTopView *)keyboardView button:(UIButton *)button {
     NSInteger tag = button.tag;
    [self.editInputView.inputView resignFirstResponder];
    switch (tag) {
        case 1000:
            [self changeFont];
            break;
        case 1001:
            [self changAligment];
            break;
        case 1002:
            [self insetImgIsInset:YES isTopCoverInsert:NO];
            break;
        case 2000:
            [self.editInputView.inputView resignFirstResponder];
        case 2001:
            [self saveEdit];
            break;
    }
}

#pragma mark - 头部插入封面
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

//拍照
- (void)takePhoto {
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

- (void)saveEdit {
    EditModle *model = [[EditModle alloc] initWithTitle:self.modleTitle Image:self.coverImg context:self.contentText];
    self.model = model;
    self.homeVC.model = model;
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - ******UIImagePickerControllerDelegate******
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    
    if (self.isInsert) {
        [self insertImage:img];
        self.editInputView.inputView.font = self.userSettingFont;
    } else if (self.isTopCoverInsert) {
        self.topCoverImgView.coverImgView.image = img;
        self.coverImg = img;
    }
}

#pragma mark - YYTextViewDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self.baseScrollView setContentOffset:CGPointMake(0,ZHSCREEN_Height-_topCoverImgView.bottom-ZHNAVALL_H) animated:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.modleTitle = textField.text;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat conty = scrollView.contentOffset.y;
    
    if (conty - 40 > self.topCoverImgView.coverAddImgBtn.top) {
        self.topCoverImgView.coverAddImgBtn.enabled = NO;
    } else {
        self.topCoverImgView.coverAddImgBtn.enabled = YES;
    }

}

- (BOOL)textViewShouldBeginEditing:(YYTextView *)textView {
    
    [self.baseScrollView setContentOffset:CGPointMake(0,ZHSCREEN_Height-_topCoverImgView.bottom-ZHNAVALL_H) animated:YES];
    if (self.isInsert && self.editInputView.inputView.text.length) {
        NSString *str0 = @"";
        NSDictionary *dictAttr0 = @{NSFontAttributeName:self.userSettingFont};
        NSAttributedString *attr0 = [[NSAttributedString alloc]initWithString:str0 attributes:dictAttr0];
        [self.contentText appendAttributedString:attr0];
        
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.alignment = self.editInputView.inputView.textAlignment;
        [self.contentText addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, self.contentText.length)];
        
        self.editInputView.inputView.attributedText = self.contentText;
        self.editInputView.inputView.selectedRange = NSMakeRange(self.contentText.length, 0);
    }
    return YES;
}

- (void)textViewDidChange:(YYTextView *)textView {
    self.inputStr = textView.text;
}

- (void)textViewDidBeginEditing:(YYTextView *)textView {
    self.isInsert = NO;
}


#pragma mark - 图文混排 插入图片
- (void)insertImage:(UIImage *)img {
    //创建最主要的attribute文本
    NSMutableAttributedString *contentText = self.editInputView.inputView.attributedText.mutableCopy;
    //图片资源
    YYImage *image = (YYImage *)img;
    //添加文本+图片
    YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
    imageView.layer.cornerRadius = 8;
    imageView.layer.masksToBounds = YES;
    imageView.frame = CGRectMake(0, 0, self.editInputView.inputView.width - 20, self.editInputView.inputView.width/image.size.width*image.size.height);
    NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.size alignToFont:self.userSettingFont alignment:YYTextVerticalAlignmentCenter];
    
    [contentText appendAttributedString:attachText];
    self.editInputView.inputView.attributedText = contentText;
    self.contentText = contentText;
    
    NSMutableAttributedString *lineBreakKey = [[NSMutableAttributedString alloc] initWithString:@"\n\n\n"];
    lineBreakKey.font = self.userSettingFont;
    [contentText appendAttributedString:lineBreakKey];
    
    self.editInputView.inputView.selectedRange = NSMakeRange(contentText.length, 0);
    self.contentText = contentText;
    [self.editInputView.inputView becomeFirstResponder];
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
                weakSelfARC.editInputView.inputView.font = [UIFont systemFontOfSize:weakSelfARC.editInputView.inputView.font.pointSize];
                break;
            case 1:
                weakSelfARC.editInputView.inputView.font = [UIFont fontWithName:@"Undefined" size:weakSelfARC.editInputView.inputView.font.pointSize];
                break;
            case 2:
                weakSelfARC.editInputView.inputView.font = [UIFont fontWithName:@"suibixi-Regular" size:weakSelfARC.editInputView.inputView.font.pointSize];
                break;
            case 3:
                weakSelfARC.editInputView.inputView.font = [UIFont fontWithName:@"H-GungSeo" size:weakSelfARC.editInputView.inputView.font.pointSize];
                break;
            case 4:
                weakSelfARC.editInputView.inputView.font = [UIFont fontWithName:@"AMCSongGBK-Light" size:weakSelfARC.editInputView.inputView.font.pointSize];
                break;
            case 5:
                weakSelfARC.editInputView.inputView.font = [UIFont fontWithName:@"JSouJingSu" size:weakSelfARC.editInputView.inputView.font.pointSize];
                break;
                
            default:
                break;
        }
    }];
    
    self.userSettingFont = self.editInputView.inputView.font;
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
                weakSelfARC.editInputView.inputView.font = [UIFont fontWithName:weakSelfARC.editInputView.inputView.font.fontName size:20];
                break;
            case 1:
                weakSelfARC.editInputView.inputView.font = [UIFont fontWithName:weakSelfARC.editInputView.inputView.font.fontName size:20];
                break;
            case 2:
                weakSelfARC.editInputView.inputView.font = [UIFont fontWithName:weakSelfARC.editInputView.inputView.font.fontName size:22];
                break;
            case 3:
                weakSelfARC.editInputView.inputView.font = [UIFont fontWithName:weakSelfARC.editInputView.inputView.font.fontName size:24];
                break;
            case 4:
                weakSelfARC.editInputView.inputView.font = [UIFont fontWithName:weakSelfARC.editInputView.inputView.font.fontName size:26];
                break;
            case 5:
                weakSelfARC.editInputView.inputView.font = [UIFont fontWithName:weakSelfARC.editInputView.inputView.font.fontName size:28];
                break;
            case 6:
                weakSelfARC.editInputView.inputView.font = [UIFont fontWithName:weakSelfARC.editInputView.inputView.font.fontName size:30];
                break;
            case 7:
                weakSelfARC.editInputView.inputView.font = [UIFont fontWithName:weakSelfARC.editInputView.inputView.font.fontName size:32];
                break;
            case 8:
                weakSelfARC.editInputView.inputView.font = [UIFont fontWithName:weakSelfARC.editInputView.inputView.font.fontName size:34];
                break;
            case 9:
                weakSelfARC.editInputView.inputView.font = [UIFont fontWithName:weakSelfARC.editInputView.inputView.font.fontName size:36];
                break;
            case 10:
                weakSelfARC.editInputView.inputView.font = [UIFont fontWithName:weakSelfARC.editInputView.inputView.font.fontName size:38];
                break;
            case 11:
                weakSelfARC.editInputView.inputView.font = [UIFont fontWithName:weakSelfARC.editInputView.inputView.font.fontName size:40];
                break;
                
            default:
                break;
        }
    }];
    
    self.userSettingFont = self.editInputView.inputView.font;
    
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
                weakSelfARC.editInputView.inputView.textAlignment = NSTextAlignmentLeft;
                break;
            case 1:
                weakSelfARC.editInputView.inputView.textAlignment = NSTextAlignmentCenter;
                break;
            case 2:
                weakSelfARC.editInputView.inputView.textAlignment = NSTextAlignmentRight;
                break;
        }
    }];
}

#pragma mark - 懒加载

- (EditBaseScrollview *)baseScrollView {
    if (!_baseScrollView) {
        _baseScrollView = [[EditBaseScrollview alloc] init];
        _baseScrollView.delegate = self;
        _baseScrollView.frame = CGRectMake(0, 0, ZHSCREEN_Width, ZHSCREEN_Height-20);
        _baseScrollView.contentSize = CGSizeMake(ZHSCREEN_Width, ZHSCREEN_Height+ZHSCREEN_Width*0.8-ZHNAVALL_H);
        _baseScrollView.backgroundColor = [UIColor clearColor];
    }
    return _baseScrollView;
}

- (EditInputView *)editInputView {
    if (!_editInputView) {
        _editInputView = [[EditInputView alloc] initWithFrame:CGRectMake(0, _topCoverImgView.bottom-ZHNAVALL_H, ZHSCREEN_Width, ZHSCREEN_Height-_topCoverImgView.bottom-20)];
        _editInputView.backgroundColor = [UIColor randomColor];
        _editInputView.inputView.inputAccessoryView = self.keyBoardTopView;
        _editInputView.inputView.delegate = self;
        _editInputView.titleField.delegate = self;
        self.userSettingFont = _editInputView.inputView.font;
    }
    return _editInputView;
}

- (EditKeyBoardTopView *)keyBoardTopView {
    if (!_keyBoardTopView) {
        _keyBoardTopView = [[EditKeyBoardTopView alloc] init];
        _keyBoardTopView.delegate = self;
    }
    return _keyBoardTopView;
}


@end
