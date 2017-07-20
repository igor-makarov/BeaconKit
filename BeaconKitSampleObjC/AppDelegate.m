//
//  AppDelegate.m
//
//  Created by Igor Makarov on 20/07/2017.
//  
//

#import "AppDelegate.h"
@import BeaconKit;

@interface AppDelegate () <BeaconScannerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BeaconScanner.shared.delegate = self;
    [BeaconScanner.shared start];
    return YES;
}

- (void)beaconScanner:(BeaconScanner * _Nonnull)beaconScanner didDiscover:(Beacon * _Nonnull)beacon {
    NSLog(@"Discovered beacon: %@", beacon);
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}



@end
