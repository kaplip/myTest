//
//  CreatNameViewController.m
//  旅游季
//
//  Created by niit on 15/12/25.
//  Copyright © 2015年 niit. All rights reserved.
//

#import "CreatNameViewController.h"
#import "UserModel.h"
#import "Bmob+BmobDataModelTool.h"
#import "RootViewController.h"

@interface CreatNameViewController ()
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextView;
- (IBAction)cancelAction:(id)sender;
- (IBAction)nextAction:(id)sender;
@end

@implementation CreatNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(1, 1,100,self.nameTextView.bounds.size.height-2)];
    lable.text               = @"昵称";
    lable.textAlignment   = NSTextAlignmentCenter;
    lable.font               = [UIFont systemFontOfSize:13];
    lable.textColor         = [UIColor grayColor];
    self.nameTextView.leftViewMode = UITextFieldViewModeAlways;
    self.nameTextView.leftView = lable;
    
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChange)  name:UITextFieldTextDidChangeNotification object:nil];
    
    
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    title.text = @"创建昵称";
    title.font = [UIFont systemFontOfSize:15];
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor grayColor];
    
    self.navigationItem.titleView = title;
    // Do any additional setup after loading the view.
}


-(void)textChange{
    self.nextButton.enabled = self.nameTextView.text.length;
    if (self.nextButton.enabled) {
        self.nextButton.backgroundColor = [UIColor colorWithRed:96/255.0 green:199/255.0 blue:255/255.0 alpha:1];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)cancelAction:(id)sender{
     [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)nextAction:(id)sender{
    
    if ([[self.nameTextView.text stringByReplacingOccurrencesOfString:@"" withString:@" "]isEqualToString:@""]) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"昵称不能为空" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action  = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        _userModel.user_name = self.nameTextView.text;
        [Bmob inseterUserInfo:_userModel];
        
        [self loadProfileView];
    }
}


- (void)loadProfileView{
    
    RootViewController *rootVC = [[RootViewController alloc]init];
    UIApplication *app = [UIApplication sharedApplication];
    UIWindow *mainWindow = [app keyWindow];
    mainWindow.rootViewController = rootVC;
    [self.view endEditing:YES];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
    
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
