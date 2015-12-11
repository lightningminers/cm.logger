//
//  CMLogger.h
//  CMLogger
//
//  Created by xiangwenwen on 15/4/11.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^openDebug)(NSDictionary * debugConfig);

@interface CMLogger : UIViewController

+(void)readConfig:(openDebug) openDebugBlock;

+(void)managerApp:(UIView *)subMFLogView managWebView:(UIWebView *)webview;

@end
