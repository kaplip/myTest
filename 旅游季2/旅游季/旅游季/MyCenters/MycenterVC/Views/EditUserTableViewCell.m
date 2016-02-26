//
//  EditUserTableViewCell.m
//  旅游季
//
//  Created by niit on 16/1/26.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "EditUserTableViewCell.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"
#define Screen_W [UIScreen mainScreen].bounds.size.width

@interface  EditUserTableViewCell()

@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) UIImageView *headerImageV;

@end

@implementation EditUserTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

- (void)setIndex:(NSInteger)index{
    // 0.头像 1.用户名 2.所在地
    _index = index;
    
    CGFloat height = self.frame.size.height;
    
    _titleLabel  = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, height+30, height)];
    _titleLabel.text = _attributeTitle;
    _titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:_titleLabel];
    
    if (_index ==0) {
        _headerImageV = [[UIImageView alloc]init];
        [_headerImageV sd_setImageWithURL:[NSURL URLWithString:_user.headerImageUrl]];
        [_headerImageV setFrame:CGRectMake(Screen_W-height, 5, height-5, height-10)];

        [self.contentView addSubview:_headerImageV];
    }else{
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(height+30, 5, Screen_W - height-10, height-10)];
         _textField.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_textField];
    }
    switch (index) {
        case 1:
            _textField.text = _user.user_name;
            break;
        case 2:
            _textField.text =[[NSUserDefaults standardUserDefaults]objectForKey:UserLocation];
            break;
        default:
            break;
    }
}

- (void)setHeaderImage:(UIImage *)headerImage{
    _headerImage = headerImage;
    [_headerImageV setImage:headerImage];
}

@end
