//
//  ViewController.m
//  SegueText
//
//  Created by niit on 16/1/7.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *testButton;
- (IBAction)testAction:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)testAction:(id)sender {
    [self performSegueWithIdentifier:@"test" sender:@"123"];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
  
    TestViewController *testVC = (TestViewController *)segue.destinationViewController;
    testVC.testString = sender;
}
@end
