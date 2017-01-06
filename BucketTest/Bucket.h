//
//  Bucket.h
//  BucketTest
//
//  Created by George Kapoya on 2017/01/06.
//  Copyright © 2017 immedia. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, BucketStyle) {
	BucketStyle1OpenFromRight,
	BucketStyle1OpenFromLeft,
	BucketStyle2OpenFromRight,
	BucketStyle2OpenFromLeft
};

@protocol BucketDelegate <NSObject, CAAnimationDelegate>
@optional
- (void)lidOpenAnimationDidStart;
- (void)lidOpenAnimationDidFinish;
- (void)lidCloseAnimationDidStart;
- (void)lidCloseAnimationDidFinish;
@end

@interface Bucket : NSObject

@property (nonatomic, assign, readonly) CGRect rect;
@property (nonatomic, strong, readonly) CALayer *parentLayer;
@property (nonatomic, assign, readonly) CGFloat actualHeight;
@property (nonatomic, strong) CALayer *bucketLidLayer;
@property (nonatomic, strong) CALayer *bucketBodyLayer;
@property (nonatomic, weak) id<BucketDelegate> bucketDelegate;

@property (nonatomic, assign) BucketStyle bucketStyle;
@property (nonatomic, copy) UIImage *bucketLidImage;
@property (nonatomic, copy) UIImage *bucketBodyImage;
@property (nonatomic, assign) CFTimeInterval animationDuration;
@property (nonatomic, strong) CAMediaTimingFunction* animationTimingFunction;
@property (nonatomic, assign) CGFloat degreesVariance;
@property (nonatomic, assign) CGFloat interspace;
@property (nonatomic, assign) CGPoint bucketLidAnchorPoint;


- (id)initWithFrame:(CGRect)rect inLayer:(CALayer *)parentLayer;
- (void)openBucket;
- (void)closeBucket;

@end
