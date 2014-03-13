//
//  GSTGalleryViewController.h
//  SimpleGallery
//
//  Created by Efimov Kirill on 2014-01-15.
//  Copyright (c) 2014 GSTeam. All rights reserved.
//  https://github.com/Kirill89/iOS-code-snippets
//

#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface GSTGalleryView : UIView
{
@private
    UIView *_line;
    UIView *_buttons;
    UIButton *_changeToLeft;
    UIButton *_changeToRight;
}

@property NSMutableArray *images;
@property float animationDuration;
@property UIButton *imageButton;

- (id) init;
- (id) initWithFrame:(CGRect)frame;
- (void) redrawView;

// methods for customization
- (void) changeImageButtonOnActivate: (UIButton*) button;
- (void) changeImageButtonOnDeactivate: (UIButton*) button;
- (UIViewContentMode) imagesContentMode;
- (void) setImageFromInternetFor: (UIImageView*) view withUrl: (NSURL*) url;
- (float) imageButtonsTop;
- (float) imageButtonLeft: (int)buttonNumber;

@end
