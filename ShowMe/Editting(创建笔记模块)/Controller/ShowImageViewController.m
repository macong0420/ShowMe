//
//  ShowImageViewController.m
//  ShowMe
//
//  Created by 马聪聪 on 2018/12/28.
//  Copyright © 2018 马聪聪. All rights reserved.
//

#import "ShowImageViewController.h"
#import <YYKit.h>
#import <Toast.h>

@interface ShowImageViewController ()
@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *saveBtn;
@end

@implementation ShowImageViewController

- (instancetype)initWithImage:(UIImage *)img {
    if (self = [super init]) {
        _img = img;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    
}

- (void)setupUI {
    CGFloat w = [UIScreen mainScreen].bounds.size.width-40;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    imageView.frame = CGRectMake(0, 0, self.inputView.width - 20, self.inputView.width/image.size.width*image.size.height);
    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 80, [UIScreen mainScreen].bounds.size.width - 40, [UIScreen mainScreen].bounds.size.height-80 - 80)];
    _scrollview.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-40, _img.size.height);
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, w, w/_img.size.width*_img.size.height)];
    _imgView.image = _img;
    [self.view addSubview:_scrollview];
    
    [_scrollview addSubview:_imgView];
    
    _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveBtn.frame = CGRectMake(20, _scrollview.bottom + 20, self.view.width - 40, 40);
    [_saveBtn setTitle:@"保存到相册" forState:UIControlStateNormal];
    [_saveBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    _saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _saveBtn.backgroundColor = [UIColor orangeColor];
    _saveBtn.titleLabel.textColor = [UIColor darkGrayColor];
    _saveBtn.layer.cornerRadius = 5;
    _saveBtn.layer.masksToBounds = YES;
    [self.view addSubview:_saveBtn];
    
}

- (void)btnAction:(UIButton *)sender {
    
    UIImageWriteToSavedPhotosAlbum(self.img, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
}


// 指定回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *) error contextInfo:(void*)contextInfo {
    
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
        [self.view makeToast:@"保存图片成功"
                    duration:1.0
                    position:CSToastPositionCenter
                       style:style];
    }
    
}

@end
