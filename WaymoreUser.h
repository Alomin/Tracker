//
//  WaymoreUser.h
//  Waymore
//
//  Created by Yuxuan Wang on 4/30/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Comment, Route;

@interface WaymoreUser : NSObject

@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSArray *comments;
@property (nonatomic, retain) NSArray *likedRoutes;
@property (nonatomic, retain) NSArray *ownedRoutes;

@end
