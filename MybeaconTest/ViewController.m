//
//  ViewController.m
//  MybeaconTest
//
//  Created by focusmedia on 14-8-22.
//  Copyright (c) 2014年 focusmedia. All rights reserved.
//

#import "ViewController.h"
#import "DBManager.h"

NSString * const KeyUUID = @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0";

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
{
    BOOL isout;
    NSString *inTime;
    NSString *outTime;
}

@property (strong, nonatomic) CLLocationManager *locationManger;
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *BeconArray;



@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.locationManger = [[CLLocationManager alloc] init];
    
    self.locationManger.delegate = self;
    
    [self startMonitoring];
    
   
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 20 - 100)];
    
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    
    self.BeconArray = [[NSArray alloc] init];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, [UIScreen mainScreen].bounds.size.height - 20 - 100, 100, 40);
    [button setTitle:@"退出" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)buttonClick
{
    exit(0);
}

- (void)startMonitoring
{
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:KeyUUID] major:0 minor:0 identifier:@"test"];
    [self.locationManger startMonitoringForRegion:self.beaconRegion];
    [self.locationManger startRangingBeaconsInRegion:self.beaconRegion];
}

- (void)stopMonitoring
{
    
    [self.locationManger stopMonitoringForRegion:self.beaconRegion];
    [self.locationManger stopRangingBeaconsInRegion:self.beaconRegion];

}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"Failed monitoring region: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Location manager failed: %@", error);
}
//manager监测当前进入范围的beacon
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    for (CLBeacon *beacon in beacons) {

        if (beacon.proximity != CLProximityUnknown) {
           
            if (!isout) {
                NSLog(@"有设备进入到我们的视线");
//                isout = YES;
                
               inTime = [self laoctionDate];
                
            
            }
        }else {
            if (isout) {
                NSLog(@"有设备出了我们的视线");
//                isout = NO;
                
                outTime = [self laoctionDate];
                if (inTime) {
                    Time *time = [[Time alloc] init];
                    time.inTime = inTime;
                    time.outTime = outTime;
                    time.iBeacon = [beacon.proximityUUID UUIDString];
                    NSLog(@"***c****%@",time.iBeacon);
                    [[DBManager shardSingleton] creatTable];
                    [[DBManager shardSingleton] insertIfon:time];
                    NSArray *aray = [[DBManager shardSingleton] searchInfo];
                    Time *test = [[Time alloc] init];
                    test = [aray objectAtIndex:2];
                    NSLog(@"%@",test.iBeacon);
                    for (Time *ti in aray) {
                        NSLog(@"this is intime %@",ti.inTime);
                        NSLog(@"this is outtime %@",ti.outTime);
                        NSLog(@"this is ibeacom %@",ti.iBeacon);
                    }
                }

            }

        }
    }
   
    self.BeconArray = beacons;
    [self.tableView reloadData];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
     NSLog(@"设备出了你的范围了");
    isout = YES;
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
     NSLog(@"设备进入你的范围了");
    isout = NO;
}

- (NSString *)laoctionDate
{
    NSDate *date = [NSDate date];
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: date];
    
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    
    NSLog(@"%@", localeDate);
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter  setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    
    return  [formatter stringFromDate:localeDate];

}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.BeconArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CLBeacon *beacon = [self.BeconArray objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.textLabel.text = [beacon.proximityUUID UUIDString];
    
    NSString *str;
    switch (beacon.proximity) {
        case CLProximityNear:
            str = @"近";
            break;
            
        case CLProximityImmediate:
            str = @"超近";
            break;

        case CLProximityFar:
            str = @"远";
            break;

        case CLProximityUnknown:
            str = @"不见了";
            break;

            
        default:
            break;
    }
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"距离显示：%f %@",beacon.accuracy,str];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
