//
//  ORSSpotDetailViewController.m
//  Spots
//
//  Created by Andrew Madsen on 3/29/15.
//  Copyright (c) 2015 Open Reel Software. All rights reserved.
//

#import "ORSSpotDetailViewController.h"
@import AetherCore;
@import MapKit;
#import "ORSCallbookImageController.h"

@interface ORSSpotDetailViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *callsignLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityCountryLabel;
@property (weak, nonatomic) IBOutlet UILabel *frequencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *modeLabel;

@end

@implementation ORSSpotDetailViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self updateUserInterface];
}

#pragma mark - Private

- (void)updateUserInterface
{
	if ([self.mapView.annotations count]) {
		[self.mapView removeAnnotations:self.mapView.annotations];
	}
	
	NSString *gridSquare = self.spot.gridSquare;
	if (!gridSquare) gridSquare = self.spot.callbookInfo.gridSquare;
	if (gridSquare) {
		double latitude = [ORSLatitudeFromMaidenheadLocator(gridSquare) doubleValue];
		double longitude = [ORSLongitudeFromMaidenheadLocator(gridSquare) doubleValue];
		CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
		self.mapView.region = MKCoordinateRegionMakeWithDistance(coordinate, 10e3, 10e3);
		
		MKPointAnnotation *pin = [[MKPointAnnotation alloc] init];
		pin.coordinate = coordinate;
		pin.title = self.spot.callsign;
		[self.mapView addAnnotation:pin];
	}
	
	self.imageView.image = [[ORSCallbookImageController sharedCache] imageForCallsign:self.spot.callsign];
	self.callsignLabel.text = self.spot.callsign;
	self.nameLabel.text = self.spot.callbookInfo.name;
	
	NSMutableString *cityCountry = [NSMutableString string];
	NSString *city = [self.spot.callbookInfo.city capitalizedStringWithLocale:[NSLocale currentLocale]];
	NSString *country = [self.spot.callbookInfo.country capitalizedStringWithLocale:[NSLocale currentLocale]];
	if ([city length]) {
		[cityCountry appendString:city];
		if ([country length]) [cityCountry appendString:@", "];
	}
	if ([country length]) [cityCountry appendString:country];
	self.cityCountryLabel.text = cityCountry;
	
	if (self.spot.frequency) {
		NSNumberFormatter *freqFormatter = [[NSNumberFormatter alloc] init];
		freqFormatter.maximumFractionDigits = 5;
		freqFormatter.minimumFractionDigits = 5;
		self.frequencyLabel.text = [freqFormatter stringFromNumber:self.spot.frequency];
	}
	
	self.modeLabel.text = self.spot.mode;
}

#pragma mark - Properties

- (void)setSpot:(ORSDXSpot *)spot
{
	if (spot != _spot) {
		_spot = spot;
		[self updateUserInterface];
	}
}

@end
