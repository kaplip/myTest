//
//  MessageDetailFootView.m
//  旅游季
//
//  Created by niit on 16/2/16.
//  Copyright © 2016年 niit. All rights reserved.
//

#define Screen_W [UIScreen mainScreen].bounds.size.width
#define Screen_H [UIScreen mainScreen].bounds.size.height

#import "MessageDetailFootView.h"


@interface MessageDetailFootView ()
@property (weak, nonatomic) IBOutlet UITextField *criTextfield;
@property (weak, nonatomic) IBOutlet UIImageView *sendImageV;

@property (strong, nonatomic) UITextField *accessoryTextFeild;

@end

@implementation MessageDetailFootView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"MessageDetailFootView" owner:nil options:nil].lastObject;
        
        [self initTextfiled];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow) name:UIKeyboardWillShowNotification object:nil];
    }
    return self;
}

- (void)initTextfiled{
    
    if (self.criTextfield.inputAccessoryView) {
        return;
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 45)];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    _accessoryTextFeild = [[UITextField alloc]initWithFrame:CGRectMake(5, 5, Screen_W-80, 35)];
    _accessoryTextFeild.borderStyle = UITextBorderStyleRoundedRect;
    
    CGFloat _accessoryTextFeild_X = CGRectGetMaxX(_accessoryTextFeild.frame);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor blueColor]];
    [button setTitle:@"发送" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(sendCriAction) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(_accessoryTextFeild_X+5, 5, 65, 35)];

    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    
    [view addSubview:_accessoryTextFeild];
    [view addSubview:button];
    
    self.criTextfield.inputAccessoryView = view;
}

- (void)keyboardShow{
    
    [_accessoryTextFeild becomeFirstResponder];
}

- (void)sendCriAction{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendCritiqueAction:)]) {
        [self.delegate sendCritiqueAction:_accessoryTextFeild.text];
    }
    [self endEditing:YES];
    _accessoryTextFeild.text = nil;
}


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
