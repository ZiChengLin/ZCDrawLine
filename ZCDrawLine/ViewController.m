//
//  ViewController.m
//  ZCDrawLine
//
//  Created by 林梓成 on 15/7/3.
//  Copyright (c) 2015年 lin. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ZCAnnotation.h"

@interface ViewController ()<CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic)CLLocationCoordinate2D locationCoordinate2D;    // 显示我的位置的2D坐标

@property (nonatomic)CLLocationCoordinate2D destinationCoordinate2D; // 显示目标位置的2D坐标

@property (strong, nonatomic)CLLocationManager *locationManager;     // 位置管理者

@property (strong, nonatomic)MKMapView *mapView;   // 地图的信息

@end

@implementation ViewController

- (MKMapView *)mapView {
    
    if (_mapView == nil) {
        
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height-100)];
    }
    
    return _mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.mapView];
    
    self.mapView.delegate = self;
    
    // 1、初始化位置管理者
    self.locationManager = [[CLLocationManager alloc] init];
    // 2、对于iOS8版本的判断
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    // 设置一个目的位置
    self.destinationCoordinate2D = CLLocationCoordinate2DMake(23.1234, 113.3456);
    
    
}

/**
 *  点击地图上我的位置按钮执行的方法
 *  作用：将用户的位置信息显示在地图上
 *
 *  @param sender
 */
- (IBAction)doBtn1:(id)sender {
    
    self.mapView.showsUserLocation = YES;
    
}
/**
 *  点击地图上的目的位置按钮执行的方法
 *  作用：将目的地的位置信息显示在地图上
 *
 *  @param sender
 */
- (IBAction)doBtn2:(id)sender {
    
    //1、创建一个标注视图来显示目的位置
    ZCAnnotation *anno = [[ZCAnnotation alloc] init];
    //2、设置目的位置的坐标
    anno.coordinate = self.destinationCoordinate2D;
    //3、标注视图的标题和附标题
    anno.title = @"广州";
    anno.subtitle = @"天河区东莞庄路鸿德国际酒店";
    //4、将标注视图插在地图上
    [self.mapView addAnnotation:anno];
    
    // 将标注视图设置在地图的中心
    // 设置一个区域范围
    MKCoordinateRegion region;
    // 设置比例尺
    region.span.latitudeDelta = 0.1;
    region.span.longitudeDelta = 0.1;
    // 设置中心点
    region.center = self.destinationCoordinate2D;
    
    [self.mapView setRegion:region animated:YES];
}

/**
 *  点击地图上线路信息的按钮所执行的方法
 *  作用：将我的位置与目的位置通过线连起来
 *
 *  @param sender
 */
- (IBAction)doBtn3:(id)sender {
    
    // 设置起点位置
    CLLocationCoordinate2D fromCoordinate2D = self.locationCoordinate2D;
    // 设置终点位置
    CLLocationCoordinate2D toCoordinate2D = self.destinationCoordinate2D;
    
    // 将2D坐标类型的位置转化为MKPlacemark类型
    MKPlacemark *fromPlacemark = [[MKPlacemark alloc] initWithCoordinate:fromCoordinate2D addressDictionary:nil];
    MKPlacemark *toPlacemark = [[MKPlacemark alloc] initWithCoordinate:toCoordinate2D addressDictionary:nil];
    
    // 创建mapItem
    MKMapItem *fromItem = [[MKMapItem alloc] initWithPlacemark:fromPlacemark];
    MKMapItem *toItem = [[MKMapItem alloc] initWithPlacemark:toPlacemark];
    
    // 设置一个请求
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = fromItem;
    request.destination = toItem;
    // 如果两点之间有多条线路 会返回多条。默认是NO
    request.requestsAlternateRoutes = YES;
    
    // 创建一个线路信息
    MKDirections *direction = [[MKDirections alloc] initWithRequest:request];
    
    // 画出路线
    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        
        if (error) {
            NSLog(@"请查看是否设置了起点和终点");
        } else {
            
            MKRoute *route = response.routes[2];
            // 将线路添加到地图上
            [self.mapView addOverlay:route.polyline];
        }
    }];
}


#pragma mark 实现在地图上画线的代理方法

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.lineWidth = 5.0;    // 设置线路的宽度
    renderer.strokeColor = [UIColor blackColor];
    return renderer;
}

#pragma mark 定位用户当前位置的代理方法

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    self.locationCoordinate2D = userLocation.coordinate;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
