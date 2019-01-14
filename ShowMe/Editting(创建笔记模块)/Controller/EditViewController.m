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

@interface EditViewController () <UIScrollViewDelegate,MCEditTopCoverViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) EditBaseScrollview *baseScrollView; //基scroll

@property (nonatomic, strong) MCEditTopCoverView *topCoverImgView;
@property (nonatomic, strong) EditInputView *editInputView;
@property (nonatomic) BOOL isInsert; //是否是插入图片操作
@property (nonatomic) BOOL isTopCoverInsert;
@property (nonatomic, strong) UIFont *userSettingFont;
@property (nonatomic, strong) NSMutableAttributedString *contentText;


@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    
    _topCoverImgView = [[MCEditTopCoverView alloc] initWithFrame:CGRectMake(0, ZHNAVALL_H, ZHSCREEN_Width, ZHSCREEN_Width*0.8)];
    _topCoverImgView.delegate = self;
    [self.view addSubview:_topCoverImgView];
    [self.view addSubview:self.baseScrollView];
    [self.baseScrollView addSubview:self.editInputView];
    self.baseScrollView.underButton = self.topCoverImgView.coverAddImgBtn;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat conty = scrollView.contentOffset.y;
    NSLog(@"conty == %f",conty);
    NSLog(@"ZHSCREEN_Height-20== %f",ZHSCREEN_Height-20);
    if (conty - 40 > self.topCoverImgView.coverAddImgBtn.top) {
        self.topCoverImgView.coverAddImgBtn.enabled = NO;
    } else {
        self.topCoverImgView.coverAddImgBtn.enabled = YES;
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

#pragma mark - ******UIImagePickerControllerDelegate******
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    
    if (self.isInsert) {
        [self insertImage:img];
        self.editInputView.inputView.font = self.userSettingFont;
    } else if (self.isTopCoverInsert) {
        self.topCoverImgView.coverImgView.image = img;
    }
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
    imageView.frame = CGRectMake(0, 0, self.inputView.width - 20, self.inputView.width/image.size.width*image.size.height);
    NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:imageView contentMode:UIViewContentModeScaleAspectFit attachmentSize:imageView.size alignToFont:self.userSettingFont alignment:YYTextVerticalAlignmentCenter];
    
    [contentText appendAttributedString:attachText];
    self.editInputView.inputView.attributedText = contentText;
    self.contentText = contentText;
    
    NSMutableAttributedString *lineBreakKey = [[NSMutableAttributedString alloc] initWithString:@"\n\n\n"];
    lineBreakKey.font = self.userSettingFont;
    [contentText appendAttributedString:lineBreakKey];
    
    self.editInputView.inputView.selectedRange = NSMakeRange(contentText.length, 0);
    self.contentText = contentText;
    [self.inputView becomeFirstResponder];
}


#pragma mark - 懒加载

- (EditBaseScrollview *)baseScrollView {
    if (!_baseScrollView) {
        _baseScrollView = [[EditBaseScrollview alloc] init];
        _baseScrollView.delegate = self;
        _baseScrollView.frame = CGRectMake(0, 0, ZHSCREEN_Width, ZHSCREEN_Height-20);
        _baseScrollView.contentSize = CGSizeMake(ZHSCREEN_Width, ZHSCREEN_Height+ZHSCREEN_Width*0.8);
        _baseScrollView.backgroundColor = [UIColor clearColor];
    }
    return _baseScrollView;
}

- (EditInputView *)editInputView {
    if (!_editInputView) {
        _editInputView = [[EditInputView alloc] initWithFrame:CGRectMake(0, _topCoverImgView.bottom+20, ZHSCREEN_Width, ZHSCREEN_Height-_topCoverImgView.bottom-20)];
        _editInputView.backgroundColor = [UIColor randomColor];
    }
    return _editInputView;
}


@end
