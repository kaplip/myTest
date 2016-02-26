//
//  RegistPasswordViewController.m
//  旅游季
//
//  Created by niit on 16/1/7.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "RegistPasswordViewController.h"
#import "UserModel.h"
#import "CreatNameViewController.h"

@interface RegistPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordTextF;
@property (weak, nonatomic) IBOutlet UITextField *enterPassTextF;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation RegistPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChange) name:UITextFieldTextDidChangeNotification object:nil];
    
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(1, 1,100,self.passwordTextF.bounds.size.height-2)];
    lable.text               = @"请输入密码";
    lable.textAlignment   = NSTextAlignmentCenter;
    lable.font               = [UIFont systemFontOfSize:13];
    lable.textColor         = [UIColor lightGrayColor];
    self.passwordTextF.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextF.leftView = lable;
    
    
    UILabel *lable2 = [[UILabel alloc]initWithFrame:CGRectMake(1, 1,100,self.enterPassTextF.bounds.size.height-2)];
    lable2.text               = @"请确认密码";
    lable2.textAlignment   = NSTextAlignmentCenter;
    lable2.font               = [UIFont systemFontOfSize:13];
    lable2.textColor         = [UIColor lightGrayColor];
    self.enterPassTextF.leftViewMode = UITextFieldViewModeAlways;
    self.enterPassTextF.leftView = lable2;
    
    // Do any additional setup after loading the view.
}

- (void)textChange{
    
    self.nextButton.enabled = self.passwordTextF.text.length&&self.enterPassTextF.text.length;
    
    if (self.nextButton.enabled) {
        self.nextButton.backgroundColor = [UIColor colorWithRed:96/255.0 green:199/255.0 blue:255/255.0 alpha:1];
    }else {
        
         self.nextButton.backgroundColor = [UIColor lightGrayColor];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)nextAction:(id)sender {
    
    if ([self.passwordTextF.text isEqualToString:self.enterPassTextF.text]) {
        
        _usermodel.user_password = _enterPassTextF.text;
        
        [self performSegueWithIdentifier:@"toCreatName" sender:_usermodel];
        
    }else {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码不一致" preferredStyle:UIAlertControllerStyleAlert];
 
      UIAlertAction *action  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
  
        }];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    CreatNameViewController *creatNameVC = (CreatNameViewController *)segue.destinationViewController;
    
    creatNameVC.userModel = (UserModel *)sender;
}


- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}
- (void)dealloc{
     
     [[NSNotificationCenter defaultCenter]removeObserver:self];
 }
@end
