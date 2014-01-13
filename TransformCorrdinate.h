//
//  TransformCorrdinate.h
//  TransformCorrdinateDemo
//
//  Created by jimple on 14-1-13.
//  Copyright (c) 2014年 Jimple Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface TransformCorrdinate : NSObject


// 百度坐标转谷歌坐标
+ (void)transformatBDLat:(CGFloat)fBDLat BDLng:(CGFloat)fBDLng toGoogleLat:(CGFloat *)pfGoogleLat googleLng:(CGFloat *)pfGoogleLng;
+ (CLLocationCoordinate2D)getGoogleLocFromBaiduLocLat:(CGFloat)fBaiduLat lng:(CGFloat)fBaiduLng;

//// 谷歌坐标转百度坐标
+ (CLLocationCoordinate2D)getBaiduLocFromGoogleLocLat:(CGFloat)fGoogleLat lng:(CGFloat)fGoogleLng;

// GPS坐标转谷歌坐标
+ (CLLocationCoordinate2D)GPSLocToGoogleLoc:(CLLocationCoordinate2D)objGPSLoc;


@end
