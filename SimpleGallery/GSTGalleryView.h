//
//  GSTGalleryViewController.h
//  SimpleGallery
//
//  Created by Efimov Kirill on 2014-01-15.
//  Copyright (c) 2014 GSTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSTGalleryView : UIView
{
@private
    UIView *_line;
    UIView *_buttons;
}

@property NSMutableArray *images;
@property float animationDuration;
@property UIButton *imageButton;

- (id) init;
- (id) initWithFrame:(CGRect)frame;
- (void) redrawView;
- (void) changeImageButtonOnActivate: (UIButton *) button;
- (void) changeImageButtonOnDeactivate: (UIButton *) button;
- (UIImage *) getResizedImage: (UIImage *) image;

@end
