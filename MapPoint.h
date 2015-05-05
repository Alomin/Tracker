//
//  MapPoint.h
//  Waymore
//
//  Created by Yuxuan Wang on 4/30/15.
//  Copyright (c) 2015 Waymore Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MapPoint : NSObject

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, retain) NSDate *time;

- (MapPoint *) initWithLatitude: (double) latitude withLongitude: (double) longitude withTime:(NSDate *) time;

@end
