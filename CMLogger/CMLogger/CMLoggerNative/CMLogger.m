//
//  CMLogger.m
//  CMLogger
//
//  Created by xiangwenwen on 15/4/11.
//
//

#import "CMLogger.h"
#import "ConsoleLogURLProtocol.h"

static NSInteger mTop = 260;
static NSInteger pTop = 5;
static NSInteger bw = 100;
static UITextView *debugLog;
static UIWebView *Swebview;

@interface CMLogger()

@end


@implementation CMLogger

/**
 *  接管App的所有网络活动
 */
+(void)registerMFLog:(UITextView *)debugText
{
    [ConsoleLogURLProtocol consolelog:debugText];
}

/**
 *  读取设置debug的配置文件
 */
+(void)readConfig:(openDebug)openDebugBlock
{
    NSFileManager *manager = [[NSFileManager alloc] init];
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *debugConfigPath = [documentsPath stringByAppendingPathComponent:@"debugConfig.plist"];
    BOOL isDebug = [manager fileExistsAtPath:debugConfigPath];
    if (!isDebug) {
        [manager createFileAtPath:debugConfigPath contents:nil attributes:nil];
    }
    NSDictionary *debugConfig = [NSDictionary dictionaryWithContentsOfFile:debugConfigPath];
    openDebugBlock(debugConfig);
}

/**
 *  管理App
 *
 *  @param subMFLogView 传递子view
 */
+(void)managerApp:(UIView *)subMFLogView managWebView:(UIWebView *)webview
{
    CGRect mainScreen = [[UIScreen mainScreen] bounds];
    UIButton *clearLog = [[UIButton alloc] initWithFrame:CGRectMake(0, pTop, bw, 20)];
    [clearLog setTitle:@"清除日志" forState:UIControlStateNormal];
    [clearLog setTitleColor:[UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000] forState:UIControlStateNormal];
    [clearLog addTarget:self action:@selector(clearTextINputContext:) forControlEvents:UIControlEventTouchUpInside];
    [subMFLogView addSubview:clearLog];
    
    UIButton *clearStorage = [[UIButton alloc] initWithFrame:CGRectMake(bw+5, pTop, bw+40, 20)];
    [clearStorage setTitle:@"清除webStorage" forState:UIControlStateNormal];
    [clearStorage setTitleColor:[UIColor colorWithRed:0.000 green:0.502 blue:1.000 alpha:1.000] forState:UIControlStateNormal];
    [clearStorage addTarget:self action:@selector(clearWebStorage:) forControlEvents:UIControlEventTouchUpInside];
    [subMFLogView addSubview:clearStorage];
    
    UITextView *debugTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 30, mainScreen.size.width, mTop-25)];
    debugTextView.editable = NO;
    debugTextView.tag = 1988;
    debugTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    debugTextView.scrollEnabled = YES;
    debugTextView.textColor = [UIColor colorWithRed:0.502 green:0.000 blue:0.000 alpha:1.000];
    debugTextView.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
    
    debugLog = debugTextView;
    Swebview = webview;
    
    [subMFLogView addSubview:debugTextView];
    [self registerMFLog:debugTextView];
}

/**
 *  清除日志
 *
 *  @param sender
 */
+(void)clearTextINputContext:(UIButton *)sender
{
    debugLog.text = @"CMLogger ---日志清除完毕\n";
}

/**
 *  清除本地缓存
 *
 *  @param sender
 */
+(void)clearWebStorage:(UIButton *)sender
{
    [Swebview stringByEvaluatingJavaScriptFromString:@"localStorage.clear();"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"清除本地缓存成功" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
}


@end
