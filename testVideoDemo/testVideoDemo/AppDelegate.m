//
//  AppDelegate.m
//  testVideoDemo
//
//  Created by wang animeng on 2016/11/3.
//  Copyright © 2016年 tiki. All rights reserved.
//

#import "AppDelegate.h"
#import <TKVideoPlanet/TKVideo.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIUserNotificationType notificationType = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationType categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [TKVideoPlanet setApnsBadge:@"0" completBlock:^(NSDictionary *info, NSError *error) {
        if (!error) {
            NSLog(@"%@",info);
        }
        else{
            NSLog(@"%@",error);
        }
    }];
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"failed to register remote notification, error:%@", error);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [deviceToken.description substringWithRange:NSMakeRange(1, deviceToken.description.length - 2)];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"%@",token);
    
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"TKApnsToken"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [TKVideoPlanet setApnsToken:token completBlock:^(NSDictionary *info, NSError *error) {
            if (!error) {
                NSLog(@"%@",info);
            }
            else{
                NSLog(@"%@",error);
            }
        }];
    });
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"%@",userInfo);
}


@end
