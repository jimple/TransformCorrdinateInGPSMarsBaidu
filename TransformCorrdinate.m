//
//  TransformCorrdinate.m
//  TransformCorrdinateDemo
//
//  Created by jimple on 14-1-13.
//  Copyright (c) 2014年 Jimple Chen. All rights reserved.
//

#import "TransformCorrdinate.h"

@implementation TransformCorrdinate


// 百度坐标转谷歌坐标
const CGFloat x_pi = 3.14159265358979324 * 3000.0 / 180.0;
+ (void)transformatBDLat:(CGFloat)fBDLat BDLng:(CGFloat)fBDLng toGoogleLat:(CGFloat *)pfGoogleLat googleLng:(CGFloat *)pfGoogleLng
{
    CGFloat x = fBDLng - 0.0065f, y = fBDLat - 0.006f;
    CGFloat z = sqrt(x * x + y * y) - 0.00002f * sin(y * x_pi);
    CGFloat theta = atan2(y, x) - 0.000003f * cos(x * x_pi);
    *pfGoogleLng = z * cos(theta);
    *pfGoogleLat = z * sin(theta);
}

+ (CLLocationCoordinate2D)getGoogleLocFromBaiduLocLat:(CGFloat)fBaiduLat lng:(CGFloat)fBaiduLng
{
    CGFloat fLat;
    CGFloat fLng;
    
    [[self class] transformatBDLat:fBaiduLat BDLng:fBaiduLng toGoogleLat:&fLat googleLng:&fLng];
    
    CLLocationCoordinate2D objLoc;
    objLoc.latitude = fLat;
    objLoc.longitude = fLng;
    return objLoc;
}

// 谷歌坐标转百度坐标
+ (CLLocationCoordinate2D)getBaiduLocFromGoogleLocLat:(CGFloat)fGoogleLat lng:(CGFloat)fGoogleLng
{
    CLLocationCoordinate2D objLoc;
    
    CGFloat x = fGoogleLng, y = fGoogleLat;
    CGFloat z = sqrt(x * x + y * y) + 0.00002f * sin(y * x_pi);
    CGFloat theta = atan2(y, x) + 0.000003f * cos(x * x_pi);
    objLoc.longitude = z * cos(theta) + 0.0065;
    objLoc.latitude = z * sin(theta) + 0.006;
    
    return objLoc;
}

/*******************       === GPS-Google  BEGIN  ===    *******************/
/*               在网上看到的根据这个 c# 代码改的 GPS坐标转火星坐标               */
/*  https://on4wp7.codeplex.com/SourceControl/changeset/view/21483#353936  */
/***************************************************************************/

const double pi = 3.14159265358979324;
//
// Krasovsky 1940
//
// a = 6378245.0, 1/f = 298.3
// b = a * (1 - f)
// ee = (a^2 - b^2) / a^2;
const double a = 6378245.0;
const double ee = 0.00669342162296594323;

bool outOfChina(double lat, double lon);
static double transformLat(double x, double y);
static double transformLon(double x, double y);

// World Geodetic System ==> Mars Geodetic System
CLLocationCoordinate2D transformFromWGSCoord2MarsCoord(CLLocationCoordinate2D wgsCoordinate)
{
    double wgLat = wgsCoordinate.latitude;
    double wgLon = wgsCoordinate.longitude;
    
    if (outOfChina(wgLat, wgLon))
    {
        return wgsCoordinate;
    }
    
    double dLat = transformLat(wgLon - 105.0, wgLat - 35.0);
    double dLon = transformLon(wgLon - 105.0, wgLat - 35.0);
    double radLat = wgLat / 180.0 * pi;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
    
    CLLocationCoordinate2D marsCoordinate = {wgLat + dLat, wgLon + dLon};
    return marsCoordinate;
}

bool outOfChina(double lat, double lon)
{
    if (lon < 72.004 || lon > 137.8347)
        return true;
    if (lat < 0.8293 || lat > 55.8271)
        return true;
    return false;
}

double transformLat(double x, double y)
{
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(abs(x));
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
    return ret;
}

double transformLon(double x, double y)
{
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(abs(x));
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
    return ret;
}
/*******************       === GPS-Google  END  ===    *******************/

// GPS坐标转谷歌坐标
+ (CLLocationCoordinate2D)GPSLocToGoogleLoc:(CLLocationCoordinate2D)objGPSLoc
{
    return transformFromWGSCoord2MarsCoord(objGPSLoc);
}





@end
