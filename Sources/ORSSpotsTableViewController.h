//
//  ORSSpotsTableViewController.h
//  Spots
//
//  Created by Andrew Madsen on 3/29/15.
//  Copyright (c) 2015 Open Reel Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ORSDXClusterNode;

@interface ORSSpotsTableViewController : UITableViewController

@property (strong, nonatomic) ORSDXClusterNode *clusterNode;

@end
