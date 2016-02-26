//
//  PathDetailTableViewCell.m
//  旅游季
//
//  Created by niit on 16/1/21.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "PathDetailTableViewCell.h"
#import "PathDetailModel.h"
#import "Bmob+BmobDataModelTool.h"

@interface PathDetailTableViewCell()
@property (strong, nonatomic) UIButton *savePathButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *absLabel;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageV;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@end

@implementation PathDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"PathDetailTableViewCell" owner:nil options:nil].lastObject;
        self.userInteractionEnabled  =YES;
        [self setSaveButton];
    }
    return  self;
}
- (void)setSaveButton{
    
    CGFloat _nameLabelX = CGRectGetMaxX(_nameLabel.frame);
    CGFloat _nameLabelY = CGRectGetMinY(_nameLabel.frame);
    
    _savePathButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_savePathButton setFrame:CGRectMake(_nameLabelX+5, _nameLabelY, 30, 30)];
    [_savePathButton setBackgroundImage:[UIImage imageNamed:@"xihuan"] forState:UIControlStateNormal];
    
    [_savePathButton addTarget:self action:@selector(xihuanAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_savePathButton];
    
    
}

- (void)setPathDetail:(PathDetailModel *)pathDetail{
    
    _pathDetail = pathDetail;
    _nameLabel.text = _pathDetail.name;
    _absLabel.text = _pathDetail.abstract;
    _desLabel.text = _pathDetail.Description;
    [_detailImageV setImage:[UIImage imageWithData:_pathDetail.imageData]];
    [Bmob addjustPathAleadySave:_pathDetail andResult:^(BOOL result) {
        if (result) {
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                [_savePathButton setBackgroundImage:[UIImage imageNamed:@"xihuan_select"] forState:UIControlStateNormal];
            }];
        }else{
            [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                [_savePathButton setBackgroundImage:[UIImage imageNamed:@"xihuan"] forState:UIControlStateNormal];
            }];
        }
    }];

}

- (void)xihuanAction:(id)sender {
    
    if (!_savePathButton.selected) {
        _savePathButton.selected = YES;
         [_savePathButton setBackgroundImage:[UIImage imageNamed:@"xihuan_select"] forState:UIControlStateNormal];
    }
    
    [Bmob savePathDetail:_pathDetail];
}
@end
