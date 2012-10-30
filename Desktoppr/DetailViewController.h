//
//  DetailViewController.h
//  Desktoppr
//
//  Created by James Brooks on 28/10/2012
//  Copyright (c) 2012 James Brooks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface DetailViewController : UIViewController <MBProgressHUDDelegate, UICollectionViewDelegate> {
    // For the progress HUD
    MBProgressHUD *HUD;
    long long expectedLength;
    long long currentLength;
}

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) IBOutlet UIScrollView *detailScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *openImage;
@property (strong, nonatomic) IBOutlet UICollectionViewCell *paletteCollection;

- (void)loadDesktopprItems;
- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer;
- (void)deleteAllObjects: (NSString *) entityDescription;

@end
