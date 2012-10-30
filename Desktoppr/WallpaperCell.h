//
//  WallpaperCell.h
//  Desktoppr
//
//  Created by ITR on 28/10/2012.
//  Copyright (c) 2012 jbrooksuk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WallpaperCell : UICollectionViewCell {
    IBOutlet UIImageView *imageView;
    IBOutlet UILabel *viewsLabel;
    IBOutlet UILabel *syncsLabel;
}
-(void)setImage:(UIImage *)image;
-(void)setViews:(NSNumber *)views;
-(void)setSyncs:(NSNumber *)syncs;
@end
