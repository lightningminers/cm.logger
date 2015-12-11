//
//  ConsoleLogURLProtocol.m
//  ConsoleLogDemo
//
//  Created by xiangwenwen on 15/4/10.
//  Copyright (c) 2015年 xiangwenwen. All rights reserved.
//

#import "ConsoleLogURLProtocol.h"

static UITextView *debug;

@implementation ConsoleLogURLProtocol

+(void)consolelog:(UITextView *)debugText
{
    debug = debugText;
    [NSURLProtocol registerClass:self];
}

/**
 *  NSURLProtocol
 *
 *  @param request 请求对象
 *
 *  @return 返回NO不控制，返回YES Protocol接管控制请求
 */
+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    /**
     *  提供给console log 使用
     */
    if ([[request HTTPMethod] isEqualToString:@"POST"]) {
        NSArray *components = [[request URL] pathComponents];
        if ([components count] == 2) {
            if ([[components objectAtIndex:0] isEqualToString:@"/"] && [[components objectAtIndex:1] isEqualToString:@"_ConsoleLogger"]) {
                return YES;
            }
        }
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

/**
 *  处理传递过来的数据
 */
- (void)startLoading
{
    NSData *body = [[self request] HTTPBody];
    NSError *error = nil;
    if (body) {
        NSDictionary *requestObj = [NSJSONSerialization JSONObjectWithData:body options:kNilOptions error:&error];
        NSMutableDictionary *responseObj = [[NSMutableDictionary alloc] initWithCapacity:10];
        [self handleRequest:requestObj response:responseObj];
        NSData *responseData = [NSJSONSerialization dataWithJSONObject:responseObj options:kNilOptions error:&error];
        NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[[self request] URL]
                                                                MIMEType:@"application/json"
                                                   expectedContentLength:[responseData length]
                                                        textEncodingName:nil];
    
        [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [[self client] URLProtocol:self didLoadData:responseData];
        [[self client] URLProtocolDidFinishLoading:self];
    }
}

-(void)stopLoading
{
    
}

/**
 *  处理console发送来的请求
 *
 *  @param request  请求对象
 *  @param response 响应字典
 */
-(void)handleRequest:(NSDictionary *)request response:(NSMutableDictionary *)response
{
    NSString *findK = [request objectForKey:@"k"];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *appendString;
        if (findK) {
            if ([findK isEqualToString:@"c"]) {
                NSString *consoleLog = [NSString stringWithFormat:@"MFLog --- %@ \n",[request objectForKey:@"m"]];
                if (debug.text) {
                    appendString = [debug.text stringByAppendingString:consoleLog];
                }else{
                    appendString = consoleLog;
                }
            }else{
                if ([findK isEqualToString:@"e"]) {
                    NSString *errorLog = [NSString stringWithFormat:@"MFLog-----%@ \n url=%@ \n line=%@ \n",[request objectForKey:@"m"], [request objectForKey:@"u"], [request objectForKey:@"l"]];
                    if (debug.text) {
                        appendString = [debug.text stringByAppendingString:errorLog];
                    }else{
                        appendString = errorLog;
                    }
                }
            }
        }
        [debug setText:appendString];
        if(debug.text.length > 0 ) {
            NSRange bottom = NSMakeRange(debug.text.length -1, 1);
            [debug scrollRangeToVisible:bottom];
        }
    });
}
@end