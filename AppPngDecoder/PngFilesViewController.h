//
//  PngFilesViewController.h
//  AppPngDecoder
//
//  Created by junmin liu on 12-3-11.
//  Copyright (c) 2012年 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PngFilesViewController : UITableViewController {
    NSString *appPath;
    NSMutableArray *pngFiles;
	IBOutlet UIProgressView *progressView;
	IBOutlet UIBarButtonItem *saveAllButton;
	NSUInteger saveCounter;
}

@property (nonatomic,retain) NSString *appPath;
@property (nonatomic, retain) IBOutlet UIProgressView *progressView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *saveAllButton;
@property (nonatomic, assign) NSUInteger saveCounter;

- (IBAction) saveAll;

@end
