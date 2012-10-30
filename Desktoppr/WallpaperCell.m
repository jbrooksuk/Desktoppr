//
//  WallpaperCell.m
//  Desktoppr
//
//  Created by ITR on 28/10/2012.
//  Copyright (c) 2012 jbrooksuk. All rights reserved.
//

#import "WallpaperCell.h"

@implementation WallpaperCell

-(void)setImage:(UIImage *)image
{
    [imageView setImage:image];
}

-(void)setSyncs:(NSNumber *)syncs
{
    [syncsLabel setText:[NSString stringWithFormat:@"%d", [syncs integerValue]]];
}

-(void)setViews:(NSNumber *)views
{
    [viewsLabel setText:[NSString stringWithFormat:@"%d", [views integerValue]]];
}

@end
