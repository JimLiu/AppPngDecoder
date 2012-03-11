//
//  ViewController.h
//  AppPngDecoder
//
//  Created by junmin liu on 12-3-11.
//  Copyright (c) 2012年 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    UITextField *appPathTextFiled;
    UIBarButtonItem *unzipButton;
}

@property (nonatomic, retain) IBOutlet UITextField *appPathTextFiled;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *unzipButton;

- (IBAction)appPathChanged:(id)sender;

@end
