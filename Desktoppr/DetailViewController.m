//
//  DetailViewController.m
//  Desktoppr
//
//  Created by James Brooks on 28/10/2012
//  Copyright (c) 2012 James Brooks. All rights reserved.
//

#import "DetailViewController.h"
#import "WallpaperCell.h"
#import "SBJson.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

static NSString *CellIdentifier = @"PaletteCell";

#pragma mark - Managing the detail item

//- (void)setDetailItem:(id)newDetailItem
//{
//    if (_detailItem != newDetailItem) {
//        _detailItem = newDetailItem;
//        
//        // Update the view.
//        [self configureView];
//    }
//}

- (void)configureView
{    
//    self.detailImageView.contentMode = UIViewContentModeScaleAspectFit;
    if (self.detailItem) {
        self.detailImageView.image = [UIImage imageWithData:[self.detailItem valueForKey:@"wallpaperThumbData"]];
//        self.detailImageView.image = [UIImage imageWithData:[self.detailItem valueForKey:@"wallpaperImageData"]];
    }
}

- (IBAction)openInBrowser:(id)sender {
    UIImageWriteToSavedPhotosAlbum(self.detailImageView.image, self, @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), NULL);
}

- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    if (error) {
        // Do anything needed to handle the error or display it to the user
    } else {
        UIAlertView *alertBox = [[UIAlertView alloc] init];
        [alertBox setTitle:@"Saved!"];
        [alertBox setMessage:@"Image saved to your camera roll!"];
        [alertBox addButtonWithTitle:@"Okay"];
        [alertBox setDelegate:self];
        [alertBox show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0) {
		[alertView dismissWithClickedButtonIndex:0 animated:YES];
	}else{
        NSLog(@"Some random error with alertViews");
	}
}

- (void)viewDidLoad
{
    // Now we can zoom in and stuff.
//    [self.detailScrollView setMaximumZoomScale:6.0f];
//    [self.detailScrollView setMinimumZoomScale:0.5f];
//    self.detailScrollView.contentSize = CGSizeMake([[self.detailItem valueForKey:@"wallpaperImageWidth"] floatValue], [[self.detailItem valueForKey:@"wallpaperImageHeight"] floatValue]);
//    [self.detailScrollView setDelegate:self];
    
    // Double tap zoom
//    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
//    [doubleTap setNumberOfTapsRequired:2];
//    [self.detailScrollView addGestureRecognizer:doubleTap];

    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:HUD];
    
    HUD.labelText = @"Loading image";
    
    [HUD showWhileExecuting:@selector(loadImage) onTarget:self withObject:NULL animated:YES];
    
    // Usual stuff
    [super viewDidLoad];
    [self configureView];
    
    [HUD show:NO];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.detailImageView;
}

- (void)loadImage {
    [self performSelectorInBackground:@selector(loadImageInBackground:) withObject:[UIImage imageWithData:[self.detailItem valueForKey:@"wallpaperImageData"]]];
}

- (void)loadImageInBackground:(UIImage *)imageData {
    [self performSelectorOnMainThread:@selector(didLoadImageInBackground:) withObject:imageData waitUntilDone:YES];
}

- (void)didLoadImageInBackground:(UIImage *)image {
    self.detailImageView.image = image;
}

@end
