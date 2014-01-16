//
//  GSTGalleryViewController.m
//  SimpleGallery
//
//  Created by Efimov Kirill on 2014-01-15.
//  Copyright (c) 2014 GSTeam. All rights reserved.
//

#import "GSTGalleryView.h"

@interface GSTGalleryView ()
- (void) internalInit;
- (void) swipeDirectionRight;
- (void) swipeDirectionLeft;
- (UIImage *) imageWithColor:(UIColor *)color andSize: (CGSize) size;
- (void) imageButtonTap: (id)sender;
- (void) deactivateAllButtons;
- (void) activateButton;
@end

@implementation GSTGalleryView

@synthesize images;
@synthesize animationDuration;

- (void) activateButton
{
    [self deactivateAllButtons];
    int imageNumber = (-_line.frame.origin.x) / self.frame.size.width;
    [self changeImageButtonOnActivate: _buttons.subviews[imageNumber]];
}

- (void) deactivateAllButtons
{
    for (UIButton *button in _buttons.subviews) {
        [self changeImageButtonOnDeactivate: button];
    }
}

- (void) imageButtonTap: (id)sender
{
    NSInteger imageNumber = ((UIControl *) sender).tag;
    [UIView animateWithDuration: self.animationDuration animations: ^(void) {
        CGRect lineFrame = _line.frame;
        lineFrame.origin.x = -(self.frame.size.width * imageNumber);
        _line.frame = lineFrame;
    } completion: ^(BOOL finished) {
        [self activateButton];
    }];
}

- (UIImage *)imageWithColor:(UIColor *)color andSize: (CGSize) size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void) internalInit
{
    self.imageButton = [[UIButton alloc] init];
    CGSize buttonSize = CGSizeMake(10.0f, 10.0f);
    UIImage *normalStateImage = [self imageWithColor: [UIColor redColor] andSize: buttonSize];
    UIImage *highlightedStateImage = [self imageWithColor: [UIColor greenColor] andSize: buttonSize];
    self.imageButton.frame = CGRectMake(0, 0, buttonSize.width, buttonSize.height);
    [self.imageButton setBackgroundImage: normalStateImage forState: UIControlStateNormal];
    [self.imageButton setBackgroundImage: highlightedStateImage forState: UIControlStateHighlighted];
    
    self.animationDuration = 0.2f;
    
    self.images = [[NSMutableArray alloc] init];
    
    UISwipeGestureRecognizer *gestureRecognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget: self action:@selector(swipeDirectionRight)];
    [gestureRecognizerRight setDirection: UISwipeGestureRecognizerDirectionRight];
    [self addGestureRecognizer: gestureRecognizerRight];
    
    UISwipeGestureRecognizer *gestureRecognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget: self action:@selector(swipeDirectionLeft)];
    [gestureRecognizerLeft setDirection: UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer: gestureRecognizerLeft];
    
    [self setClipsToBounds: YES];
}

- (void)swipeDirectionRight
{
    if (-_line.frame.origin.x < self.frame.size.width) {
        return;
    }
    
    [UIView animateWithDuration: self.animationDuration animations: ^(void) {
        CGRect lineFrame = _line.frame;
        lineFrame.origin.x += self.frame.size.width;
        _line.frame = lineFrame;
    } completion: ^(BOOL finished) {
        [self activateButton];
    }];
}

- (void)swipeDirectionLeft
{
    if (-_line.frame.origin.x >= self.frame.size.width * ([self.images count] - 1)) {
        return;
    }
    
    [UIView animateWithDuration: self.animationDuration animations: ^(void) {
        CGRect lineFrame = _line.frame;
        lineFrame.origin.x -= self.frame.size.width;
        _line.frame = lineFrame;
    } completion: ^(BOOL finished) {
        [self activateButton];
    }];
}

- (id)initWithFrame: (CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self) {
        [self internalInit];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self internalInit];
    }
    return self;
}

- (UIImage *) getResizedImage: (UIImage *) image
{
    CGSize newSize = self.frame.size;
    
    double ratio;
    double delta;
    CGPoint offset;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height) {
        ratio = newSize.width / image.size.width;
        delta = (ratio*image.size.width - ratio*image.size.height);
        offset = CGPointMake(delta/2, 0);
    } else {
        ratio = newSize.width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPointMake(0, delta/2);
    }
    
    //make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width) + delta,
                                 (ratio * image.size.height) + delta);
    
    
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
    } else {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void) redrawView
{
    if (_line) {
        [_line removeFromSuperview];
    }
    if (_buttons) {
        [_buttons removeFromSuperview];
    }
    
    _line = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 0, 0)];
    int quarter = self.frame.size.height / 4;
    _buttons = [[UIView alloc] initWithFrame: CGRectMake(0, quarter * 3, self.frame.size.width, self.imageButton.frame.size.height)];
    int imageNumber = 0;
    int partSize = self.frame.size.width / (([self.images count] - 1) + 2);
    int buttonHalfWidth = self.imageButton.frame.size.width / 2;
    
    for (id image in self.images) {
        if ([image isKindOfClass: [UIImage class]]) {
            UIImageView *viewToAdd = [[UIImageView alloc] initWithImage: [self getResizedImage: image]];
            CGRect imageViewFrame = CGRectMake(
                                               (imageNumber * self.frame.size.width) + (int)((self.frame.size.width - viewToAdd.frame.size.width) / 2),
                                               (int)((self.frame.size.height - viewToAdd.frame.size.height) / 2),
                                               viewToAdd.frame.size.width,
                                               viewToAdd.frame.size.height
                                               );
            
            viewToAdd.frame = imageViewFrame;
            [_line addSubview: viewToAdd];
            
            UIButton *imageButton = [NSKeyedUnarchiver unarchiveObjectWithData: [NSKeyedArchiver archivedDataWithRootObject: self.imageButton]];
            CGRect imageButtonFrame = imageButton.frame;
            imageButtonFrame.origin.x = (partSize * (imageNumber + 1)) - buttonHalfWidth;
            imageButton.frame = imageButtonFrame;
            imageButton.tag = imageNumber;
            [imageButton addTarget:self action: @selector(imageButtonTap:) forControlEvents: UIControlEventTouchUpInside];
            [_buttons addSubview: imageButton];
            
            imageNumber++;
        } else {
            @throw [NSException exceptionWithName: @"TypeMismatchException" reason: [NSString stringWithFormat:@"Object at index %i in array is not kind of UIImage", [self.images indexOfObject: image]] userInfo:nil];
        }
    }
    
    [self addSubview: _line];
    [self addSubview: _buttons];
    
    if (imageNumber > 0) {
        [self changeImageButtonOnActivate: _buttons.subviews[0]];
    }
}

- (void) changeImageButtonOnActivate: (UIButton *) button
{
    button.layer.borderWidth = 1.0f;
    [button.layer setBorderColor: [UIColor blackColor].CGColor];
}

- (void) changeImageButtonOnDeactivate: (UIButton *) button
{
    button.layer.borderWidth = 0.0f;
}

@end
