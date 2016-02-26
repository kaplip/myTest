//
//  RgValidateViewController.m
//  旅游季
//
//  Created by niit on 15/12/25.
//  Copyright © 2015年 niit. All rights reserved.
//

#import "RgValidateViewController.h"
#import "RegistPasswordViewController.h"
#import <BmobSDK/Bmob.h>
#import "UserModel.h"

#define rightLabel_W 130

@interface RgValidateViewController ()
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextView;
- (IBAction)cancelAction:(id)sender;
- (IBAction)nextAction:(id)sender;
@end

@implementation RgValidateViewController{
    
    int requestTime;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChange)  name:UITextFieldTextDidChangeNotification object:nil];
    [self initTextRightView];
    
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    title.text = @"输入验证码";
    title.font = [UIFont systemFontOfSize:15];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor grayColor];
    
    self.navigationItem.titleView = title;
    // Do any additional setup after loading the view.
}

-(void)textChange{
    
    self.nextButton.enabled = self.phoneTextView.text.length;
    if (self.nextButton.enabled) {
        self.nextButton.backgroundColor = [UIColor colorWithRed:96/255.0 green:199/255.0 blue:255/255.0 alpha:1];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation

- (IBAction)nextAction:(id)sender{
    
    [BmobSMS verifySMSCodeInBackgroundWithPhoneNumber:_userModel.user_account andSMSCode:_phoneTextView.text resultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            
            [self performSegueWithIdentifier:@"toPassword" sender:_userModel];
        } else {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"验证码错误" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
            
            NSLog(@"%@",error);
        }
    }];
    
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[RegistPasswordViewController class]]) {
        RegistPasswordViewController *passwordVC = (RegistPasswordViewController *)segue.destinationViewController;
        passwordVC.usermodel = (UserModel *)sender;
    }
}

-(void)initTextRightView{
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(self.phoneTextView.bounds.size.width-rightLabel_W-3, 1, rightLabel_W, self.phoneTextView.bounds.size.height-2)];
    
    requestTime = 60;
    lable.font = [UIFont systemFontOfSize:13];
    lable.textColor =[UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1];
    lable.textAlignment = NSTextAlignmentCenter;
    
    self.phoneTextView.rightViewMode = UITextFieldViewModeAlways;
    self.phoneTextView.rightView = lable;
    
    NSTimer *t = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(requestValidate:) userInfo:nil repeats:YES];
    [t fire];
}

-(void)requestValidate:(NSTimer *)t{
    requestTime-=1;
    NSString *str = [NSString stringWithFormat:@"剩余时间：%d秒",requestTime];
    [self refreshTimeLebel:str];
    if (requestTime<=0) {
        [t invalidate];
        self.nextButton.enabled = NO;
        [self.nextButton setBackgroundColor:[UIColor lightGrayColor]];
        
        UIButton *reGetValidate = [UIButton buttonWithType:UIButtonTypeCustom];
        [reGetValidate setFrame:self.phoneTextView.rightView.frame];
        [reGetValidate setBackgroundColor:[UIColor blueColor]];
        reGetValidate.titleLabel.text = @"重新获取";
        reGetValidate.titleLabel.textAlignment = NSTextAlignmentCenter;
        [reGetValidate addTarget:self action:@selector(reGetValidateAction:) forControlEvents:UIControlEventTouchUpInside];
        self.phoneTextView.rightView = reGetValidate;
        
    }
}

- (void)reGetValidateAction:(UIButton *)sender{
    
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:self.phoneTextView.text andTemplate:@"旅游季注册" resultBlock:^(int number, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            //获得smsID
            NSLog(@"sms ID：%d",number);
        }
    }];
    
    [self initTextRightView];
}


-(void)refreshTimeLebel:(NSString *)str{
    UILabel *rightLable = (UILabel *)self.phoneTextView.rightView;
    rightLable.text = str;
    [self.phoneTextView.rightView setNeedsDisplay];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
