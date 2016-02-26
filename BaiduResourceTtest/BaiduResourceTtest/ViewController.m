//
//  ViewController.m
//  BaiduResourceTtest
//
//  Created by niit on 16/1/13.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLRequest *request = [ NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.map.baidu.com/place/detail?uid=0fa512156fe6dd7f7069d309&output=html&source=placeapi_v2"] cachePolicy:0 timeoutInterval:60];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"erro = %@",error);
        }else{
            
            NSLog(@"------data = %@",[NSString stringWithFormat:@"%lu", data.length ]);
//            NSLog(@"-------response = %@",response);
            
            NSMutableArray *resultArr = [[NSMutableArray alloc]init];
            NSString *str =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//            NSLog(@"---------%@",str);
            
            NSArray *arr = [str componentsSeparatedByString:@"imgUrl"];
            NSMutableArray *arrM = [arr mutableCopy];
            [arrM removeLastObject];
            if (arrM.count!=0) {
                [arrM removeObjectAtIndex:0];
            }
            
            
            for (NSString *s in arrM) {
                
                NSArray *secArr = [s componentsSeparatedByString:@"cn_name"];
                [resultArr addObject:secArr[0]];
               
            }
            int outPutNumber = (int)resultArr.count>4?4:(int)resultArr.count;
            for (int i =0 ;i<outPutNumber;i++) {
                NSString *s = resultArr[i];
                s = [s stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                s = [s stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                s = [s stringByReplacingOccurrencesOfString:@"," withString:@""];
                
              
                s = [s substringFromIndex:1];
                
                  NSLog(@"-----------------这是分割线-----------------\n%@",s);
            }
        }
        
    } ];
    [task resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
