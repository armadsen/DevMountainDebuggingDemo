//
//  ORSSpotsTableViewController.m
//  Spots
//
//  Created by Andrew Madsen on 3/29/15.
//  Copyright (c) 2015 Open Reel Software. All rights reserved.
//

#import "ORSSpotsTableViewController.h"
@import AetherCore;

@interface ORSSpotsTableViewController () <ORSDXClusterDelegate>

@end

@implementation ORSSpotsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.clusterNode = [ORSDXClusterNode dxClusterWithURL:[NSURL URLWithString:@"dxc.nc7j.com"]];
	self.clusterNode.delegate = self;
	[self.clusterNode connect];
}

#pragma mark - ORSDXClusterDelegate

- (void)dxCluster:(ORSDXClusterNode *)cluster didReceiveSpots:(NSArray *)spots
{
	[self.tableView reloadData];
}

- (void)dxCluster:(ORSDXClusterNode *)cluster didEncounterError:(NSError *)error
{
	NSLog(@"%s: %@", __PRETTY_FUNCTION__, error);
}

- (NSString *)loginStringForDXCluster:(ORSDXClusterNode *)cluster
{
	return @"AC7CF";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.clusterNode.spots count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SpotTableCell" forIndexPath:indexPath];
    
	ORSDXSpot *spot = self.clusterNode.spots[indexPath.row];
	cell.textLabel.text = spot.callsign;
	
    return cell;
}

@end
