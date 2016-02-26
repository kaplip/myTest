//
//  RgPhoneViewController.m
//  旅游季
//
//  Created by niit on 15/12/25.
//  Copyright © 2015年 niit. All rights reserved.
//

#import "RgPhoneViewController.h"
#import "NSString+PhoneNumberCheck.h"
#import "UserModel.h"
#import <BmobSDK/Bmob.h>
#import "RgValidateViewController.h"

@interface RgPhoneViewController ()

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextView;
- (IBAction)cancelAction:(id)sender;
- (IBAction)nextAction:(id)sender;

@end

@implementation RgPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initTextLeftView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChange)  name:UITextFieldTextDidChangeNotification object:nil];
    
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    title.text = @"注册手机号";
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

-(void)initTextLeftView{
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(1, 1,100,self.phoneTextView.bounds.size.height-2)];
    lable.text               = @"中国";
    lable.textAlignment   = NSTextAlignmentCenter;
    lable.font               = [UIFont systemFontOfSize:13];
    lable.textColor         = [UIColor blueColor];
    self.phoneTextView.leftViewMode = UITextFieldViewModeAlways;
    self.phoneTextView.leftView = lable;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancelAction:(id)sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - Navigation

- (IBAction)nextAction:(id)sender {
    
    BOOL right = [NSString isMobileNumber:self.phoneTextView.text];
    if (right) {
#warning 这里需要进行验证码的请求以用于跳转至下一个界面
        [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:self.phoneTextView.text andTemplate:@"旅游季注册" resultBlock:^(int number, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
            } else {
                //获得smsID
                NSLog(@"sms ID：%d",number);
            }
        }];
        UserModel *usermodel = [[UserModel alloc]init];
        usermodel.user_account = self.phoneTextView.text;
         [self performSegueWithIdentifier:@"toCheck" sender:usermodel];
    
    }else{
        self.phoneTextView.text = nil;
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"消息" message:@"你输入的手机号有误，请重新输入" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"重新输入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alertC addAction:action1];
        
        [self presentViewController:alertC animated:YES completion:nil];
        
        NSLog(@"手机号错误");
    }
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    RgValidateViewController *rgVC = segue.destinationViewController;
    rgVC.userModel = sender;
    
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
