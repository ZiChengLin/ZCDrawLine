//
//  ZCAnnotation.h
//  ZCDrawLine
//
//  Created by 林梓成 on 15/7/3.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface ZCAnnotation : NSObject<MKAnnotation>

// 是MKAnnotation协议里面的必须实现的属性
@property(nonatomic) CLLocationCoordinate2D coordinate;
// 可选属性
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *subtitle;

@end
