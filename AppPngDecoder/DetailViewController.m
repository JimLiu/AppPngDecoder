//
//  DetailViewController.m
//  AppPngDecoder
//
//  Created by junmin liu on 12-3-11.
//  Copyright (c) 2012年 Openlab. All rights reserved.
//

#import "DetailViewController.h"
#import "ZKDefs.h"
#import "ZKDataArchive.h"
#import "ViewController.h"

@interface DetailViewController ()
@property (nonatomic, readonly) UIImage *image;
@property (nonatomic, readonly) NSString *name;

@end

@implementation DetailViewController
@synthesize imageView;
@synthesize imageInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) dealloc
{
	self.imageView = nil;
	self.imageInfo = nil;
	[super dealloc];
}

- (UIImage *) image
{
	return [UIImage imageWithData:[self.imageInfo objectForKey:ZKFileDataKey]];
}

- (NSString *) name
{
    NSString *fileName = [self.imageInfo objectForKey:ZKPathKey];
	return [fileName lastPathComponent];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated
{
	self.title = [self.name stringByDeletingPathExtension];
    
	self.imageView.image = self.image;
	[self.imageView sizeToFit];
	self.imageView.center = CGPointMake(roundf(self.view.center.x), roundf(self.view.center.y));
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction) save
{
	id viewController = [self.navigationController.viewControllers objectAtIndex:0];
	[viewController performSelector:@selector(saveImage:) withObject:imageInfo];
}

@end
