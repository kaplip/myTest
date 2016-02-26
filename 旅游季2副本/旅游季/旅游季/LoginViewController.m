//
//  LoginViewController.m
//  旅游季
//
//  Created by niit on 15/12/25.
//  Copyright © 2015年 niit. All rights reserved.
//

#import "LoginViewController.h"
#import "RgPhoneViewController.h"
#import "RootViewController.h"
#import "UserModel.h"
@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headerImagev;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

- (IBAction)forgetPasAction:(id)sender;
- (IBAction)registAction:(id)sender;
- (IBAction)loginAction:(id)sender;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *tempName = [[NSUserDefaults standardUserDefaults] objectForKey:UserAccount];
    NSString *tempPassword = [[NSUserDefaults standardUserDefaults] objectForKey:UserPassword];
    if (tempName!=nil&&tempPassword!=nil) {
        _nameText.text = tempName;
        _passwordText.text = tempPassword;
        [self autoLoad];
    }
    
    self.nameText.tag = 101;
    self.passwordText.tag = 102;
    
    self.nameText.delegate = self;
    self.passwordText.delegate = self;
    
    
    UIImageView *leftImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40,30)];
    [leftImage1 setImage:[UIImage imageNamed:@"account_leftView"]];
    self.nameText.leftView = leftImage1;
    self.nameText.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *leftImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 40,30)];
        [leftImage2 setImage:[UIImage imageNamed:@"password_leftView"]];
    self.passwordText.leftView = leftImage2;
    self.passwordText.leftViewMode = UITextFieldViewModeAlways;
    
    
    _headerImagev.layer.cornerRadius = _headerImagev.frame.size.width/2;
    _headerImagev.clipsToBounds = YES;
    
    self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)autoLoad{
    
    [UserModel isNameAndPassword:_nameText.text andPassword:_passwordText.text andResult:^(BOOL enterEnable) {
        if (enterEnable) {
            [self didEnterAction];
        }
    }];
  
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    UITextField *tempFristResponder = [self findFristResponed];
    
    if (tempFristResponder == self.nameText) {
        [tempFristResponder resignFirstResponder];
        [self.passwordText becomeFirstResponder];
    }else{
        [self loginAction:nil];
    }
    return YES;
}

- (IBAction)forgetPasAction:(id)sender {
}

- (IBAction)registAction:(id)sender {
    
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *tempVC = [sb instantiateViewControllerWithIdentifier:@"rgPhoneVC"];
    
    RgPhoneViewController *rgVC =(RgPhoneViewController *)tempVC;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:rgVC];
    [self presentViewController:nav animated:YES completion:nil];
    
}


#pragma mark 登录
- (IBAction)loginAction:(id)sender {
    
    NSString *tempName = self.nameText.text;
    NSString *tempPassword = self.passwordText.text;
    
    [UserModel isNameAndPassword:tempName andPassword:tempPassword andResult:^(BOOL enterEnable) {
        if (enterEnable) {
            [self didEnterAction];
            [[NSUserDefaults standardUserDefaults]setObject:tempName forKey:UserAccount];
            [[NSUserDefaults standardUserDefaults]setObject:tempPassword forKey:UserPassword];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }];    
}

- (void)didEnterAction{
    RootViewController *rootVC = [[RootViewController alloc]init];
    UIApplication *app = [UIApplication sharedApplication];
    UIWindow *mainWindow = [app keyWindow];
    mainWindow.rootViewController = rootVC;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

#pragma mark 设置状态栏
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


#pragma mark 寻找第一响应者
-(UITextField *)findFristResponed{
    
    UITextField *tempFiled = [[UITextField alloc]init];
    for (int i = 0; i<2; i++) {
    UITextField *firstResponder = [self.view viewWithTag:101+i];
        if ([firstResponder isFirstResponder]) {
            tempFiled =firstResponder;
        }
    
    }
    return tempFiled;
}


@end
