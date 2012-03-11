//
//  PngFilesViewController.m
//  AppPngDecoder
//
//  Created by junmin liu on 12-3-11.
//  Copyright (c) 2012年 Openlab. All rights reserved.
//

#import "PngFilesViewController.h"
#import "ZKDefs.h"
#import "ZKDataArchive.h"
#import "DetailViewController.h"
#import <pwd.h>

@interface PngFilesViewController ()

@end

@implementation PngFilesViewController
@synthesize appPath;
@synthesize progressView;
@synthesize saveAllButton;
@synthesize saveCounter;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [appPath release];
    [pngFiles release];
    [super dealloc];
}

- (void)reloadTableView {
    self.saveAllButton.enabled = [pngFiles count] > 0;
    [self.tableView reloadData];
}

- (void)loadPngFiles {
    ZKDataArchive *archive = [ZKDataArchive archiveWithArchivePath:appPath];
    [archive inflateAll];
    
    int count = [archive.inflatedFiles count];
    NSLog(@"file count: %d", [archive.inflatedFiles count]);
    
    [pngFiles release];
    pngFiles = [[NSMutableArray array] retain];
    for (int i=0; i < count; i++) {
        NSDictionary *fileDict = [archive.inflatedFiles objectAtIndex:i];
        //NSData *fileData = [fileDict objectForKey:ZKFileDataKey];
        NSString *fileName = [fileDict objectForKey:ZKPathKey];
        NSString *ext = [fileName pathExtension];
        if ([ext isEqualToString:@"png"]) {
            [pngFiles addObject:fileDict];
        }
    }
    [self performSelectorOnMainThread:@selector(reloadTableView) withObject:self waitUntilDone:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.saveAllButton.enabled = [pngFiles count] > 0;

    [self performSelectorInBackground:@selector(loadPngFiles) withObject:self];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return pngFiles ? pngFiles.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (pngFiles) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        NSDictionary *fileDict = [pngFiles objectAtIndex:indexPath.row];
        NSData *fileData = [fileDict objectForKey:ZKFileDataKey];
        NSString *fileName = [fileDict objectForKey:ZKPathKey];
        
        cell.imageView.image = [UIImage imageWithData:fileData];
        cell.textLabel.text = [fileName lastPathComponent];
        cell.detailTextLabel.text = fileName;
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoadingCell"];
        return cell;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"displayPngDetail"]) {
        if (pngFiles) {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            NSDictionary *fileDict = [pngFiles objectAtIndex:indexPath.row];
            [(DetailViewController *)[segue destinationViewController] setImageInfo:fileDict];
        }
    }
}

- (NSString *) saveDirectory:(NSString *)subDirectory
{
	NSString *saveDirectory = nil;
	
#if TARGET_IPHONE_SIMULATOR
	NSString *logname = [NSString stringWithCString:getenv("LOGNAME") encoding:NSUTF8StringEncoding];
	struct passwd *pw = getpwnam([logname UTF8String]);
	NSString *home = pw ? [NSString stringWithCString:pw->pw_dir encoding:NSUTF8StringEncoding] : [@"/Users" stringByAppendingPathComponent:logname];
	NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:(id)kCFBundleNameKey];
	saveDirectory = [NSString stringWithFormat:@"%@/Desktop/%@-%@", home, appName, [UIDevice currentDevice].systemVersion];
#else
	saveDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
#endif
	if (subDirectory)
		saveDirectory = [saveDirectory stringByAppendingPathComponent:subDirectory];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:saveDirectory])
		[[NSFileManager defaultManager] createDirectoryAtPath:saveDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
	
	return saveDirectory;
}

- (void) saveImage:(NSDictionary *)imageInfo
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	UIImage *image = [UIImage imageWithData:[imageInfo objectForKey:ZKFileDataKey]];
    NSString *fileName = [imageInfo objectForKey:ZKPathKey];
    NSArray *pathComponents = [fileName pathComponents];
    if (pathComponents.count > 1) {
        if ([[pathComponents objectAtIndex:0] isEqualToString:@"Payload"]
            && [[pathComponents objectAtIndex:1] rangeOfString:@".app"].length > 0) {
            NSMutableString *newFilename = [NSMutableString string];
            for (int i=1; i<pathComponents.count; i++) {
                NSString *pc = [pathComponents objectAtIndex:i];
                if (i == 1) {
                    pc = [pc stringByDeletingPathExtension];
                }
                if (i > 1) {
                    [newFilename appendString:@"/"];
                }
                [newFilename appendString:pc];
            }
            fileName = newFilename;
        }
    }
	NSString *imageName = [fileName lastPathComponent];
	NSString *imagePath = [[self saveDirectory:[fileName stringByDeletingLastPathComponent]] stringByAppendingPathComponent: imageName];
	[UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
	[self performSelectorOnMainThread:@selector(incrementSaveCounter) withObject:nil waitUntilDone:YES];
	[pool drain];
}

- (IBAction) saveAll
{
	self.saveCounter = 0;
	self.progressView.hidden = NO;
	self.saveAllButton.enabled = NO;
	NSOperationQueue *queue = [[[NSOperationQueue alloc] init] autorelease];
	[queue setMaxConcurrentOperationCount:4];
    for (NSDictionary *imageInfo in pngFiles) {
        if (imageInfo) {
            NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(saveImage:) object:imageInfo];
			[queue addOperation:operation];
			[operation release];
        }
    }
}

- (void) incrementSaveCounter
{
	self.saveCounter++;
	NSUInteger count = [pngFiles count];
	if (self.saveCounter == count)
	{
		self.progressView.hidden = YES;
		self.saveAllButton.enabled = YES;
	}
	self.progressView.progress = ((CGFloat)self.saveCounter / (CGFloat)count);
}


@end
