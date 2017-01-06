//
//  AppDelegate.h
//  BucketTest
//
//  Created by George Kapoya on 2017/01/06.
//  Copyright © 2017 immedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

