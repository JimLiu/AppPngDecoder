//
//  ViewController.m
//  AppPngDecoder
//
//  Created by junmin liu on 12-3-11.
//  Copyright (c) 2012年 Openlab. All rights reserved.
//

#import "ViewController.h"
#import "PngFilesViewController.h"


@interface ViewController ()

@end

@implementation ViewController
@synthesize appPathTextFiled;
@synthesize unzipButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)dealloc {
    [appPathTextFiled release];
    [unzipButton release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)appPathChanged:(id)sender {
    if (appPathTextFiled.text.length > 0) {
        unzipButton.enabled = YES;
    }
    else {
        unzipButton.enabled = NO;
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"listPngFiles"]) {
        [[segue destinationViewController] setAppPath:appPathTextFiled.text];
    }
}


@end
