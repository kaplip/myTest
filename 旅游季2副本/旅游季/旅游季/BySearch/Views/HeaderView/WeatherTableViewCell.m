//
//  WeatherTableViewCell.m
//  旅游季
//
//  Created by niit on 16/1/16.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "WeatherTableViewCell.h"
#import "WeatherIndexModel.h"

@interface WeatherTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *indexInfoLabel;

@property (weak, nonatomic) IBOutlet UILabel *indexDetailsLabel;


@end


@implementation WeatherTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"WeatherTableViewCell" owner:nil options:nil].lastObject;
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setIndexModel:(WeatherIndexModel *)indexModel{
    
    _indexModel = indexModel;
    _indexInfoLabel.text = [NSString stringWithFormat:@"%@：%@",indexModel.name,indexModel.index];
    _indexDetailsLabel.text = indexModel.details;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
