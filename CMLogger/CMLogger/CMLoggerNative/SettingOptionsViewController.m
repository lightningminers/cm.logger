//
//  SettingOptionsViewController.m
//  CMLogger
//
//  Created by xiangwenwen on 15/4/11.
//
//

#import "SettingOptionsViewController.h"

@interface SettingOptionsViewController ()

@property(nonatomic,copy) NSString *debugConfigPath;

@end

@implementation SettingOptionsViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    self.debugConfigPath = [doc stringByAppendingPathComponent:@"debugConfig.plist"];
    
    CGFloat navHeight = 64;
    CGFloat margin = 10;
    CGRect mainScreen = [[UIScreen mainScreen]bounds];
    CGFloat mainWidth = mainScreen.size.width;
    CGFloat mainHeight = mainScreen.size.height;
    
    //设置控制视图
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, mainHeight)];
    view.backgroundColor = [UIColor whiteColor];
    view.tintColor = [UIColor blackColor];
    
    self.view = view;
    
    //设置导航
    UINavigationBar *navigationbar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, mainWidth, navHeight)];
    navigationbar.contentMode = UIViewContentModeBottomLeft;
    UINavigationItem *barItems = [[UINavigationItem alloc] init];
    UIButton *backForWebView = [[UIButton alloc] initWithFrame:CGRectMake(5, 20, 40, 44)];
    [backForWebView setTitle:@"返回" forState:UIControlStateNormal];
    [backForWebView setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:backForWebView];
    barItems.leftBarButtonItem = backButton;
    [navigationbar setItems:@[barItems]];
    [backForWebView addTarget:self action:@selector(backforbeforview) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navigationbar];
    
    //设置打开console log
    UILabel *settingOpenConsoleLog = [[UILabel alloc] initWithFrame:CGRectMake(margin, navHeight+10, 230, 30)];
    settingOpenConsoleLog.text = @"Open Console Log";
    [view addSubview:settingOpenConsoleLog];
    
    UISwitch *settingLogSwitch = [[UISwitch alloc] initWithFrame:CGRectMake((230+(margin*2)), navHeight+10, 0, 0)];
    NSDictionary *config = [self readDebugConfigFile];
    NSNumber *openMFLog = config[@"openCMLogger"];
    if (openMFLog) {
        if ([openMFLog intValue] != 0) {
            settingLogSwitch.on = YES;
        }else{
            settingLogSwitch.on = NO;
        }
    }else{
        settingLogSwitch.on = NO;
    }
    
    [settingLogSwitch addTarget:self action:@selector(settingOpenLog:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:settingLogSwitch];
    
    
}

-(void)backforbeforview
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)settingOpenLog:(UISwitch *)sender
{
    BOOL isOpen = sender.isOn;
    NSMutableDictionary *config = [NSMutableDictionary dictionaryWithDictionary:[self readDebugConfigFile]];
    if (isOpen) {
        config[@"openCMLogger"] = @(YES);
    }else{
        config[@"openCMLogger"] = @(NO);
    }
    [self writeDebugConfigFile:config];
    
}

-(BOOL)writeDebugConfigFile:(NSDictionary *)config
{
    BOOL isW = [config writeToFile:self.debugConfigPath atomically:YES];
    return isW;
}

-(NSDictionary *)readDebugConfigFile
{
    NSDictionary *config = [NSDictionary dictionaryWithContentsOfFile:self.debugConfigPath];
    return config != nil ? config : @{};
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
