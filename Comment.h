//
//  Comment.h
//  Waymore
//
//  Created by Yuxuan Wang on 4/30/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WaymoreUser;

@interface Comment : NSObject

@property (nonatomic, retain) NSString * commentId;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) WaymoreUser *userWhoCreates;

@end
