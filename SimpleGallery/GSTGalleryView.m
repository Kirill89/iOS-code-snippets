//
//  GSTGalleryViewController.m
//  SimpleGallery
//
//  Created by Efimov Kirill on 2014-01-15.
//  Copyright (c) 2014 GSTeam. All rights reserved.
//  https://github.com/Kirill89/iOS-code-snippets
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
- (void) showImageBy: (NSInteger)index;
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

- (void) showImageBy: (NSInteger)index
{
    [UIView animateWithDuration: self.animationDuration animations: ^(void) {
        CGRect lineFrame = _line.frame;
        lineFrame.origin.x = -(self.frame.size.width * index);
        _line.frame = lineFrame;
    } completion: ^(BOOL finished) {
        [self activateButton];
    }];
}

- (void) imageButtonTap: (id)sender
{
    NSInteger imageNumber = ((UIControl *) sender).tag;
    [self showImageBy: imageNumber];
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
    self.allowImageCycle = NO;

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
  
    _changeToLeft = [[UIButton alloc] init];
    _changeToLeft.backgroundColor = [UIColor clearColor];
    [_changeToLeft addTarget: self action: @selector(swipeDirectionRight) forControlEvents: UIControlEventTouchUpInside];
    [self addSubview: _changeToLeft];
  
    _changeToRight = [[UIButton alloc] init];
    _changeToRight.backgroundColor = [UIColor clearColor];
    [_changeToRight addTarget: self action: @selector(swipeDirectionLeft) forControlEvents: UIControlEventTouchUpInside];
    [self addSubview: _changeToRight];
}

- (void)swipeDirectionRight
{
    if (-_line.frame.origin.x < self.frame.size.width) {
        if (self.allowImageCycle && [self.images count] > 0) {
            [self showImageBy: [self.images count] - 1];
        }
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
        if (self.allowImageCycle && [self.images count] > 0) {
            [self showImageBy: 0];
        }
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

- (UIViewContentMode) imagesContentMode
{
    // http://i.stack.imgur.com/JHiqw.png
    return UIViewContentModeScaleAspectFill;
}

- (float) imageButtonsTop
{
    int quarter = self.frame.size.height / 4;
    return quarter * 3;
}

- (float) imageButtonLeft: (int)buttonNumber
{
    int partSize = self.frame.size.width / (([self.images count] - 1) + 2);
    int buttonHalfWidth = self.imageButton.frame.size.width / 2;
    return (partSize * (buttonNumber + 1)) - buttonHalfWidth;
}

- (void) redrawView
{
    if (_line) {
        [_line removeFromSuperview];
    }
    if (_buttons) {
        [_buttons removeFromSuperview];
    }
  
    int selfHalfWidth = self.frame.size.width / 2;
    _changeToLeft.frame = CGRectMake(0, 0, selfHalfWidth, self.frame.size.height);
    _changeToRight.frame = CGRectMake(selfHalfWidth, 0, selfHalfWidth, self.frame.size.height);
    
    _line = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 0, 0)];
    _buttons = [[UIView alloc] initWithFrame: CGRectMake(0, [self imageButtonsTop], self.frame.size.width, self.imageButton.frame.size.height)];
    int imageNumber = 0;
  
    for (id image in self.images) {
        UIImageView *viewToAdd = [[UIImageView alloc] init];
        viewToAdd.frame = self.bounds;
        viewToAdd.contentMode = [self imagesContentMode];
        viewToAdd.clipsToBounds = YES;
        CGRect imageViewFrame = viewToAdd.frame;
        imageViewFrame.origin.x = imageNumber * self.frame.size.width;
        viewToAdd.frame = imageViewFrame;
        
        if ([image isKindOfClass: [UIImage class]]) {
            viewToAdd.image = image;
        } else if ([image isKindOfClass: [NSString class]]) {
            viewToAdd.image = [UIImage imageNamed: image];
        } else if ([image isKindOfClass: [NSURL class]]) {
            [self setImageFromInternetFor: viewToAdd withUrl: image];
        } else {
            @throw [NSException exceptionWithName: @"TypeMismatchException" reason: [NSString stringWithFormat:@"Object at index %i in array is not kind of UIImage, NSURL or NSString", (int)[self.images indexOfObject: image]] userInfo: nil];
        }
        
        [_line addSubview: viewToAdd];
        
        UIButton *imageButton = [NSKeyedUnarchiver unarchiveObjectWithData: [NSKeyedArchiver archivedDataWithRootObject: self.imageButton]];
        CGRect imageButtonFrame = imageButton.frame;
        imageButtonFrame.origin.x = [self imageButtonLeft: imageNumber];
        imageButton.frame = imageButtonFrame;
        imageButton.tag = imageNumber;
        [imageButton addTarget:self action: @selector(imageButtonTap:) forControlEvents: UIControlEventTouchUpInside];
        [_buttons addSubview: imageButton];
        
        imageNumber++;
    }
  
    [self bringSubviewToFront: _changeToLeft];
    [self bringSubviewToFront: _changeToRight];
    [self bringSubviewToFront: _buttons];
    
    [self addSubview: _line];
    [self addSubview: _buttons];
    
    if (imageNumber > 0) {
        [self deactivateAllButtons];
        [self changeImageButtonOnActivate: _buttons.subviews[0]];
    }
}

- (int) currentPhotoIndex
{
    return abs(_line.frame.origin.x / self.frame.size.width);
}

- (void) setImageFromInternetFor: (UIImageView*) view withUrl: (NSURL*) url
{
    [view setImageWithURL: url];
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
