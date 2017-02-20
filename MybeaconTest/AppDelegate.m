//
//  AppDelegate.m
//  MybeaconTest
//
//  Created by focusmedia on 14-8-22.
//  Copyright (c) 2014年 focusmedia. All rights reserved.
//

#import "AppDelegate.h"

@import  CoreLocation;

@interface AppDelegate ()<CLLocationManagerDelegate>

@property (strong, nonatomic)CLLocationManager *locationManager;

@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    if ([CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        NSLog(@"这台设备可以检测到周围的beacon");
    }
    else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"这台设备不能支持蓝牙检测，或者没有开启用户权限。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        
        if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized) {
            NSLog(@"用户权限已经开启");
        }else {
            NSLog(@"用户没有开启权限，请开启权限以后再试。");
        }
        
    }
    
    if ([application backgroundRefreshStatus] == UIBackgroundRefreshStatusAvailable) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您没有开启后台刷新，请在 设置通用->应用程序后台刷新 中开启" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        
    }

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = @"beaco离开你的范围";
        notification.soundName = @"alarmsound.caf";
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
        
        NSLog(@"beaco离开你的范围");
        
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    if ([region isKindOfClass:[CLBeaconRegion class]]) {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = @"有新的设备进入你的范围";
        notification.soundName = @"alarmsound.caf";
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
         NSLog(@"beaco进入你的范围");
        
    }
    
    
}



@end
