//
//  MMCloudKitManager.h
//  LooseLeaf
//
//  Created by Adam Wulf on 8/22/14.
//  Copyright (c) 2014 Milestone Made, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMCloudKitManagerDelegate.h"
#import "MMCloudKitBaseState.h"
#import <SimpleCloudKitManager/SPRSimpleCloudKitManager.h>

@interface MMCloudKitManager : NSObject

@property (nonatomic, weak) NSObject<MMCloudKitManagerDelegate>* delegate;
@property (nonatomic, readonly) MMCloudKitBaseState* currentState;

+ (MMCloudKitManager *) sharedManager;

+(BOOL) isCloudKitAvailable;

-(void) userRequestedToLogin;

-(void) changeToState:(MMCloudKitBaseState*)state;

-(void) retryStateAfterDelay;

-(BOOL) isLoggedInAndReadyForAnything;

@end
