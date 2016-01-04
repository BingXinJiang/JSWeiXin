//
//  AppDelegate.h
//  WeChat
//
//  Created by 蒋嵩 on 16/1/3.
//  Copyright © 2016年 song.jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    XMPPResultTypeLoginSuccess,//登录成功
    XMPPResultTypeFailure,//登录失败
    XMPPRESULTTYPENetErr//网络不给力
}XMPPResultType;

typedef void (^XMPPResultBlock)(XMPPResultType type);//XMPP请求结果的block

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//用户登录
-(void)xmppUserLogin:(XMPPResultBlock)resultBlock;
//注销
-(void)logout;

@end

#ifdef DEBUG
#define WCLog(...) NSLog(@"\n%s %d \n %@ \n\n", __func__, __LINE__, [NSString stringWithFormat:__VA_ARGS__])
#else
#define WCLog(...)
#endif

