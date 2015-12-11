//
//  ConsoleLogURLProtocol.h
//  ConsoleLogDemo
//
//  Created by xiangwenwen on 15/4/10.
//  Copyright (c) 2015年 xiangwenwen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ConsoleLogURLProtocol : NSURLProtocol

+(void)consolelog:(UITextView *)debugText;

@end
