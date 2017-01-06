//
//  ViewController.m
//  BucketTest
//
//  Created by George Kapoya on 2017/01/06.
//  Copyright © 2017 immedia. All rights reserved.
//

#import "ViewController.h"
#import "Bucket.h"



static NSString *kAnimationNameKey = @"animation_name";
static NSString *kScrapDriveUpAnimationName = @"scrap_drive_up_animation";
static NSString *kScrapDriveDownAnimationName = @"scrap_drive_down_animation";
static NSString *kBucketDriveUpAnimationName = @"bucket_drive_up_animation";
static NSString *kBucketDriveDownAnimationName = @"bucket_drive_down_animation";

static const CGFloat kScrapDriveUpAnimationHeight = 200;
static const CGFloat kScrapYOffsetFromBase = 7;
@interface ViewController () <CAAnimationDelegate>
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) CALayer *scrapLayer;
@property (nonatomic, strong) CALayer *bucketContainerLayer;
@property (nonatomic, strong) Bucket *bucket;
@property (nonatomic, assign) CFTimeInterval duration;
@property (nonatomic, assign) CGFloat baseviewYOrigin;
@property (nonatomic, assign) CGFloat bucketContainerLayerActualYPos;

@end


@implementation ViewController
- (CGRect)CGRectIntegralCenteredInRect:(CGRect)innerRect withRect:(CGRect)outerRect
{
	CGFloat originX = floorf((outerRect.size.width - innerRect.size.width) * 0.5f);
	CGFloat originY = floorf((outerRect.size.height - innerRect.size.height) * 0.5f);
	CGRect bounds = CGRectMake(originX, originY, innerRect.size.width, innerRect.size.height);
	return bounds;
}

- (void)viewDidLoad {
	[super viewDidLoad];



}

- (IBAction)btnAnimate:(id)sender {

	
}


- (void)loadView
{
	[super loadView];


	// set base view y origin
	CGRect rect = [self CGRectIntegralCenteredInRect:CGRectMake(0, 0, 200, 40) withRect:self.view.frame];
	self.baseviewYOrigin = self.animateBtn.frame.origin.y;

    [self.animateBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];


	// scrap layer
	UIImage *img = [UIImage imageNamed:@"Resource.bundle/input_mic.png"];
	rect = [self CGRectIntegralCenteredInRect:CGRectMake(0, 0, img.size.width - 5, img.size.height - 5) withRect:self.view.frame];
	rect.origin.y = self.baseviewYOrigin - CGRectGetHeight(rect) - kScrapYOffsetFromBase;

	self.scrapLayer = [CALayer layer];
	self.scrapLayer.frame = self.animateBtn.layer.frame;
	self.scrapLayer.bounds = rect;
	[self.scrapLayer setContents:(id)img.CGImage];
	self.scrapLayer.hidden = YES;
	[self.view.layer addSublayer:self.scrapLayer];


	// trash layer
	rect = [self CGRectIntegralCenteredInRect:CGRectMake(0, 0, 50, CGRectGetHeight(self.button.bounds)) withRect:self.view.frame];
	rect.origin.y = self.baseviewYOrigin;

	self.bucketContainerLayer = [CALayer layer];
	self.bucketContainerLayer.frame = self.animateBtn.frame;
	self.bucketContainerLayer.bounds = rect;
	self.bucketContainerLayer.hidden = YES;
	[self.view.layer addSublayer:self.bucketContainerLayer];


	// bucket layer
	CGRect centeredRect = [self CGRectIntegralCenteredInRect:CGRectMake(0, 0, 22, 20 + 12) withRect:rect]; //image size(20x32)
	centeredRect.origin.x = CGRectGetMinX(rect) + CGRectGetMinX(centeredRect);
	centeredRect.origin.y = CGRectGetMinY(rect);

	self.bucket = [[Bucket alloc] initWithFrame:centeredRect inLayer:self.bucketContainerLayer];
	self.bucket.bucketStyle = BucketStyle2OpenFromRight;


	// set bucket-container-layer actual y origin
	self.bucketContainerLayerActualYPos = self.baseviewYOrigin - (self.bucket.actualHeight / 2) - kScrapYOffsetFromBase; //divide by 2 considering center from y-axis
}
- (void)buttonAction:(id)sender
{
	[self.button setTitle:@"" forState:UIControlStateNormal];
	[self.button setEnabled:NO];
	self.scrapLayer.hidden = NO;
	[self scrapDriveUpAnimation];
}
- (void)scrapDriveDownAnimation
{
	CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
	moveAnimation.delegate = self;
	[moveAnimation setValue:kScrapDriveDownAnimationName forKey:kAnimationNameKey];
	moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.scrapLayer.position.x, self.scrapLayer.position.y - 5)];
	moveAnimation.duration = self.duration;
	moveAnimation.removedOnCompletion = NO;
	moveAnimation.fillMode = kCAFillModeForwards;
	moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	[self.scrapLayer addAnimation:moveAnimation forKey:nil];

}



- (void)scrapDriveUpAnimation
{
	CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
	moveAnimation.fromValue = [NSValue valueWithCGPoint:self.scrapLayer.position];
	moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(self.scrapLayer.frame), CGRectGetMidY(self.scrapLayer.frame) - kScrapDriveUpAnimationHeight)];
	moveAnimation.removedOnCompletion = NO;
	moveAnimation.fillMode = kCAFillModeForwards;
	moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

	NSArray* keyFrameValues = @[
								@(0.0),
								@(M_PI),
								@(M_PI*1.5),
								@(M_PI*2.0)
								];
	CAKeyframeAnimation* rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
	[rotateAnimation setValues:keyFrameValues];
	[rotateAnimation setValueFunction:[CAValueFunction functionWithName: kCAValueFunctionRotateZ]];
	rotateAnimation.removedOnCompletion = NO;
	rotateAnimation.fillMode = kCAFillModeForwards;
	rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

	CAAnimationGroup *animGroup = [CAAnimationGroup animation];
	animGroup.delegate = self;
	[animGroup setValue:kScrapDriveUpAnimationName forKey:kAnimationNameKey];
	animGroup.animations = @[moveAnimation, rotateAnimation];
	animGroup.duration = self.duration;
	animGroup.removedOnCompletion = NO;
	animGroup.fillMode = kCAFillModeForwards;
	[self.scrapLayer addAnimation:animGroup forKey:nil];
}

- (void)bucketDriveUpAnimation
{
	CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
	moveAnimation.delegate = self;
	[moveAnimation setValue:kBucketDriveUpAnimationName forKey:kAnimationNameKey];
	moveAnimation.fromValue = [NSValue valueWithCGPoint:self.bucketContainerLayer.position];
	moveAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMidX(self.scrapLayer.frame), self.bucketContainerLayerActualYPos)];
	moveAnimation.duration = self.duration;
	moveAnimation.removedOnCompletion = NO;
	moveAnimation.fillMode = kCAFillModeForwards;
	moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	[self.bucketContainerLayer addAnimation:moveAnimation forKey:nil];

}

- (void)bucketDriveDownAnimation
{
	CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
	moveAnimation.delegate = self;
	[moveAnimation setValue:kBucketDriveDownAnimationName forKey:kAnimationNameKey];
	moveAnimation.toValue = [NSValue valueWithCGPoint:self.bucketContainerLayer.position];
	moveAnimation.duration = self.duration;
	moveAnimation.removedOnCompletion = NO;
	moveAnimation.fillMode = kCAFillModeForwards;
	moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
	[self.bucketContainerLayer addAnimation:moveAnimation forKey:nil];

}

#pragma mark - Animation Delegate methods

- (void)animationDidStart:(CAAnimation *)anim
{
	NSString *animationName = [anim valueForKey:kAnimationNameKey];
	if ([animationName isEqualToString:kScrapDriveDownAnimationName]) {
		[self bucketDriveUpAnimation];

	} else if ([animationName isEqualToString:kBucketDriveUpAnimationName]) {
		self.bucketContainerLayer.hidden = NO;
		[self.bucket performSelector:@selector(openBucket) withObject:nil afterDelay:self.duration * 0.3];
	}
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
	if (flag) {
		NSString *animationName = [anim valueForKey:kAnimationNameKey];
		if ([animationName isEqualToString:kScrapDriveUpAnimationName]) {
			[self performSelector:@selector(scrapDriveDownAnimation) withObject:nil afterDelay:self.duration * 0.1];

		} else if ([animationName isEqualToString:kScrapDriveDownAnimationName]) {
			self.scrapLayer.hidden = YES;
			[self.bucket performSelector:@selector(closeBucket) withObject:nil afterDelay:self.duration * 0.1];
			[self performSelector:@selector(bucketDriveDownAnimation) withObject:nil afterDelay:self.duration * 1.0];

		} else if ([animationName isEqualToString:kBucketDriveDownAnimationName]) {
			self.bucketContainerLayer.hidden = YES;
			self.scrapLayer.hidden = YES;
			[self.button setTitle:@"Press me to kick off again!!" forState:UIControlStateNormal];
			[self.button setEnabled:YES];
		}
	}
}


@end
