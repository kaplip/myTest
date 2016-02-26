//
//  HeaderV.m
//  旅游季
//
//  Created by niit on 16/1/25.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "HeaderV.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"

@interface HeaderV()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageV;

@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (weak, nonatomic) IBOutlet UILabel *ageL;
@property (weak, nonatomic) IBOutlet UILabel *dcontentL;
@property (weak, nonatomic) IBOutlet UILabel *critiqueL;
@property (weak, nonatomic) IBOutlet UILabel *attentionL;

@end

@implementation HeaderV
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HeaderV" owner:nil options:nil].lastObject;
    }
    return self;
}
- (void)setUser:(UserModel *)user{
    
    if (_user==nil) {
        _user = user;
        _nameL.text =user.user_name;
        _dcontentL.text = [NSString stringWithFormat:@"%@",user.dcontent_number];
        _critiqueL.text =[NSString stringWithFormat:@"%@",user.critique_number];
        _attentionL.text = [NSString stringWithFormat:@"%@",user.attention_number];
        
        [_headerImageV sd_setImageWithURL:[NSURL URLWithString:_user.headerImageUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            _headerImageData= UIImageJPEGRepresentation(image, 0.1);
        }];
        _headerImageV.layer.cornerRadius = _headerImageV.frame.size.width/2;
        _headerImageV.clipsToBounds = YES;
    }
    
}
- (IBAction)selectedHeaderV:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedHeader)]) {
        [self.delegate didSelectedHeader];
    }
}

@end
