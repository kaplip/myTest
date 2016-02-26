//
//  MyCenterTableViewCell.m
//  旅游季
//
//  Created by niit on 16/1/25.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "MyCenterTableViewCell.h"

@interface  MyCenterTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *backImageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation MyCenterTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"MyCenterTableViewCell" owner:nil options:nil].lastObject;
    }
    return self;
}

- (void)setIndex:(NSInteger)index{
    
    _index = index;
    
    switch (index) {
        case 0:
            _titleLabel.text = @"我的驴记";
            break;
        case 1:
            _titleLabel.text = @"我的路标";
            break;
        case 2:
            _titleLabel.text = @"我的收藏";
            break;
        case 3:
            _titleLabel.text = @"关于我们";
            break;
        case 4:
            _titleLabel.text = @"退出登录";
            break;
        default:
            break;
    }
    
    NSString *imageName = [NSString stringWithFormat:@"MycenterCImg_%ld",(long)index%3+1];
    [_backImageV setImage:[UIImage imageNamed:imageName]];
    
}

@end
