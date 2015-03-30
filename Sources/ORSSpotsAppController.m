//
//  AppDelegate.m
//  Spots
//
//  Created by Andrew Madsen on 3/29/15.
//  Copyright (c) 2015 Open Reel Software. All rights reserved.
//

#import "ORSSpotsAppController.h"
@import AetherCore;

@interface ORSSpotsAppController ()

@end

@implementation ORSSpotsAppController


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	[ORSHamQTHCallbookLookupRequest setSubscriberUsername:@"ac7cf"];
	[ORSHamQTHCallbookLookupRequest setSubscriberPassword:@"csw-89H-Eb9-9XW"];
	[ORSHamQTHCallbookLookupRequest setEnabled:YES];
	
	[ORSQRZXMLCallbookLookupRequest setSubscriberUsername:@"ac7cf"];
	[ORSQRZXMLCallbookLookupRequest setSubscriberPassword:@"csw-89H-Eb9-9XW"];
	[ORSQRZXMLCallbookLookupRequest setEnabled:YES];
	
	return YES;
}

@end
