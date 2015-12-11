//
//  ViewController.m
//
//  CMLogger
//
//  Created by xiangwenwen on 15/4/11.
//  Copyright (c) 2015年 xiangwenwen. All rights reserved.
//

#import "ViewController.h"
#import "CMLogger.h"
#import "SettingOptionsViewController.h"

@interface ViewController ()<NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [CMLogger readConfig:^(NSDictionary *debugConfig) {
//        NSLog(@"%@",debugConfig);
//    }];
    NSURL *url = [NSURL URLWithString:@"http://192.168.198.66:5000/v1/upload"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
    
//    NSString *str = @"http://lcepy.github.io";
//    BOOL isF = [str hasPrefix:@"http"];
//    BOOL isL = [str hasSuffix:@"io"];
//    
//    NSString *formatter = [NSString stringWithFormat:@"http://%@",@"lcepy.github.io"];
//    NSString *formatter1 = [[NSString alloc] initWithFormat:@"http://%@",@"lcepy.github.io"];
//    
//    NSURL *urlS = [NSURL URLWithString:@"http://lcepy.github.io"];
//    NSString *urlStr = [NSString stringWithContentsOfURL:urlS encoding:NSUTF8StringEncoding error:nil];
//    NSString *urlStr1 = [[NSString alloc] initWithContentsOfURL:urlS encoding:NSUTF8StringEncoding error:nil];
//    [urlStr writeToURL:urlS atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"lcepy" ofType:@"html"];
//    NSString *fileStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    NSString *fileStr1 = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
//    [fileStr writeToFile:str atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    //
    
    
//    NSString *astring01 = @"This is a String!";
//    NSString *astring02 = @"This is a String!";
//    BOOL result = [astring01 compare:astring02] == NSOrderedSame;    //NSOrderedSame判断两者内容是否相同
//    NSLog(@"result:%d",result);
//    BOOL result1 = [astring01 compare:astring02] == NSOrderedAscending;    //NSOrderedAscending判断两对象值的大小(按字母顺序进行比较，astring02大于astring01为真)
//    NSLog(@"result:%d",result1);
//    BOOL result2 = [astring01 compare:astring02] == NSOrderedDescending;    //NSOrderedDescending判断两对象值的大小(按字母顺序进行比较，astring02小于astring01为真)
//    NSLog(@"result:%d",result2);
    
//    NSString *io = @"hello";
//    NSString *IO = @"HELLO";
//    NSLog(@"%@",[io uppercaseString]);
//    NSLog(@"%@",[IO lowercaseString]);
//    NSLog(@"%@",[io capitalizedString]);
    
    
    NSString *str = @"http://lcepy.github.io";
    NSRange httpRange =  [str rangeOfString:@"http"]; //返回一个range结构体
    NSLog(@"%@",NSStringFromRange(httpRange));
    
    
    NSRange ioRange = [str rangeOfString:@"io"];
    NSString *subs = [str substringWithRange:NSMakeRange(ioRange.location, ioRange.length-1)]; //从指定位置开始截取字符串
    NSLog(@"%@",subs);
    
    //从字符串开头一直截取到指定位置
    NSString *indexStr = [str substringToIndex:4];
    NSLog(@"%@",indexStr);
    
    //从指定位置开始截取到最后的字符串（包括）
    NSString *lastStr = [str substringFromIndex:4];
    NSLog(@"%@",lastStr);
    
    
    //在字符串的最后插入或者格式化插入
    

    NSMutableString *str1 = [NSMutableString stringWithString:@"http://lcepy.github.io"];
    [str1 appendString:@"#login"];
//    [str1 appendFormat:@"%@",@"#login"];
    NSLog(@"%@",str1);
    
    [str1 insertString:@"?id=fjdkfjkgfgi384jkg" atIndex:str1.length];
    NSLog(@"%@",str1);
    
    NSRange login = [str1 rangeOfString:@"#login"];
    [str1 replaceCharactersInRange:login withString:@"#logou"];
    NSLog(@"%@",str1);
    
    
    NSString *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [doc stringByAppendingPathComponent:@"PhotoCache"];
    NSString *file = @"~/lcepy.io";
    NSLog(@"%@",[file pathExtension]);
    
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error --- %@",error);
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"response ---- %@",response);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)gotoSettingOptions:(UIButton *)sender {
    SettingOptionsViewController *viewc = [[SettingOptionsViewController alloc] init];
    [self presentViewController:viewc animated:YES completion:nil];
}

@end
