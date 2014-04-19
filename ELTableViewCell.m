/**
 * ELTableViewCell.m
 *
 * Created by Erik Lindebratt on 19/04/14.
 * Copyright (c) 2014 Erik Lindebratt. All rights reserved.
 */

#import "ELTableViewCell.h"

@interface ELTableViewCell ()

@property (strong, nonatomic) UILongPressGestureRecognizer *longPressGestureRegognizer;
@property (strong, nonatomic) UIColor *originalBackgroundColor;
@property (readwrite, nonatomic) int animationLoopCount;
@property (strong, nonatomic) NSTimer *animationTimer;

@end

@implementation ELTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.longPressGestureRegognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
        self.longPressGestureRegognizer.minimumPressDuration = 0.8;
        self.longPressGestureRegognizer.allowableMovement = 0.0;
        [self addGestureRecognizer:self.longPressGestureRegognizer];
    }
    return self;
}

- (void)didLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self enableAnimations];

        // send a notification with info about the cell's `indexPath`
        NSArray *keys = [NSArray arrayWithObjects:@"indexPath", nil];
        NSArray *objects = [NSArray arrayWithObjects:self.indexPath, nil];
        NSDictionary *notificationData = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        [[NSNotificationCenter defaultCenter] postNotificationName:ELTableViewCell__LONGPRESS_BEGAN object:notificationData];

    } else {
        [self disableAnimations];

        [[NSNotificationCenter defaultCenter] postNotificationName:ELTableViewCell__LONGPRESS_ENDED object:nil];
    }
}

- (void)enableAnimations {
    [self disableAnimations];

    if (self.backgroundView) {
        self.originalBackgroundColor = self.backgroundView.backgroundColor;
    } else {
        self.backgroundView = [[UIView alloc] init];
        self.originalBackgroundColor = [UIColor clearColor];
    }

    self.animationTimer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:0.3 target:self selector:@selector(animateBackground) userInfo:nil repeats:YES];
    [self.animationTimer fire];
    [[NSRunLoop currentRunLoop] addTimer:self.animationTimer forMode:NSRunLoopCommonModes];
}

- (void)disableAnimations {
    if (self.animationTimer) {
        [self.animationTimer invalidate];
    }

    self.animationLoopCount = 0;

    if (self.backgroundView) {
        self.backgroundView.backgroundColor = self.originalBackgroundColor;
    }
}


- (void)animateBackground {
    self.animationLoopCount++;

    UIColor *targetColor;
    if (self.animationLoopCount%2 == 0) {
        targetColor = [UIColor greenColor];
    } else {
        targetColor = [UIColor yellowColor];
    }

    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundView.backgroundColor = targetColor;
    }];
}

@end
