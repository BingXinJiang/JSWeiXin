//
//  AppDelegate.m
//  WeChat
//
//  Created by 蒋嵩 on 16/1/3.
//  Copyright © 2016年 song.jiang. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPPFramework.h"

/*
 1、初始化XMPPStream
 2、连接到服务器［传一个JID］
 3、连接到服务器成功后，再发送密码授权
 4、授权成功后，发送"在线"消息
 */

@interface AppDelegate ()<XMPPStreamDelegate>{
    XMPPStream *_xmppStream;
}
//1、初始化XMPPStream
-(void)setupXMPPStream;
//2、连接到服务器［传一个JID］
-(void)connectToHost;
//3、连接到服务器成功后，再发送密码授权
-(void)sendPwdToHost;
//4、授权成功后，发送"在线"消息
-(void)sendOnLineToHost;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

//1、初始化XMPPStream
-(void)setupXMPPStream
{
    _xmppStream = [[XMPPStream alloc] init];
    //设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
}
//2、连接到服务器［传一个JID］
-(void)connectToHost
{
    NSLog(@"开始连接到服务器");
    if (!_xmppStream) {
        [self setupXMPPStream];
    }
    
    //设置登录用户JID
    //resource 标示用户的客户端
    //从沙盒获取用户名
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    XMPPJID *myJID = [XMPPJID jidWithUser:user domain:@"jiangsong.local" resource:@"iphone"];
    _xmppStream.myJID = myJID;
    
    //设置服务器的域名,不仅可以是域名，还可以是IP地址
    _xmppStream.hostName = @"jiangsong.local";
    
    //设置端口 如果服务器的端口是5222，可以省略；
    _xmppStream.hostPort = 5222;
    
    //连接
    NSError *err = nil;
    [_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&err];
    if (err) {
        NSLog(@"连接错误：%@",err);
    }
}
//3、连接到服务器成功后，再发送密码授权
-(void)sendPwdToHost
{
    NSLog(@"发送密码进行授权");
    NSError *err = nil;
    //从沙盒中获取密码
    NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"];
    [_xmppStream authenticateWithPassword:pwd error:&err];
    if (err) {
        NSLog(@"发送密码失败：%@", err);
    }else{
        NSLog(@"授权成功");
    }
}
//4、授权成功后，发送"在线"消息
-(void)sendOnLineToHost
{
    NSLog(@"发送在线消息");
    XMPPPresence *presence = [XMPPPresence presence];
    NSLog(@"%@", presence);
    [_xmppStream sendElement:presence];
}

#pragma mark -XMPPStream的代理
#pragma mark 与主机连接成功
-(void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"与主机连接成功");
    //主机连接成功后，发送密码进行授权
    [self sendPwdToHost];
}
-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    //如果有错误，就代表连接失败
    NSLog(@"与主机断开连接：%@", error);
}
#pragma mark 授权成功
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    [self sendOnLineToHost];
}
#pragma mark 授权失败
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    NSLog(@"授权失败：%@", error);
}

#pragma mark 公共的方法
-(void)logout
{
    //1.发送“离线”消息
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:offline];
    //2.与服务器断开连接
    [_xmppStream disconnect];
}
-(void)xmppUserLogin
{
    //连接到服务器
    [self connectToHost];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
