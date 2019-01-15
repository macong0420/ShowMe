//
//  MCDiraryCell.m
//  ShowMe
//
//  Created by 马聪聪 on 2019/1/11.
//  Copyright © 2019 马聪聪. All rights reserved.
//

#import "MCDiraryCell.h"
#import "EditModle.h"


static CGFloat kBackViewHeight = 200;
static CGFloat kBcakViewWidth = 750/2.0;
static CGFloat kBackViewSmallW = 210 / 2.0;
static CGFloat kMargin = 0.15;

@interface MCDiraryCell ()

@property (nonatomic, strong) UIView *backContenView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UILabel *titleLable;

@end

@implementation MCDiraryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    _backContenView = [[UIView alloc] init];
    _backContenView.frame = CGRectMake(kMargin*ZHSCREEN_Width, 10, (ZHSCREEN_Width-(kMargin*ZHSCREEN_Width*2)), kBackViewHeight);
    _backContenView.backgroundColor = [UIColor whiteColor];
    _backContenView.layer.cornerRadius = 6;
    _backContenView.layer.masksToBounds = YES;
//    _backContenView.layer.shadowRadius = 2.0;
//    _backContenView.layer.shadowOpacity = 0.6;
//    _backContenView.layer.shadowOffset = CGSizeMake(2, 2);
//    _backContenView.layer.shadowColor = [UIColor blackColor].CGColor;
    
    [self.contentView addSubview:_backContenView];
    
    _coverImageView = [[UIImageView alloc] init];
    _coverImageView.frame = CGRectMake(kBackViewSmallW, 0, kBcakViewWidth-kBackViewSmallW, kBackViewHeight);
    _coverImageView.backgroundColor = [UIColor randomColor];
    [_backContenView addSubview:_coverImageView];
    
}


- (void)setModel:(EditModle *)model {
    _model = model;
    _coverImageView.image = model.coverImg;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
