//
//  MapaGoogleViewController.m
//  Vamu
//
//  Created by Guilherme Augusto on 22/03/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "MapaGoogleViewController.h"
#import "AppHelper.h"

@interface MapaGoogleViewController ()

@end

@implementation MapaGoogleViewController{
    GMSMapView *mapView_;
}

@synthesize rota, participanteLogado;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    participanteLogado = [AppHelper getParticipanteLogado];
    rota = [AppHelper getRota];
    
    float latitude, longitude;
    
    NSArray *configs = [Configuracao getAll];
    if ([configs count] > 0) {
        Configuracao *config = [configs objectAtIndex:0];
        latitude = config.ultLatitude;
        longitude = config.ultLongitude;
    } else {
        latitude = -22.9542082;
        longitude = -43.3640968;
    }
    
	GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                            longitude:longitude
                                                                 zoom:6];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;

    self.view = mapView_;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(latitude, longitude);
    marker.title = @"Rio de Janeiro";
    marker.snippet = @"Brasil";
    marker.map = mapView_;
    
    self.exibirNavigationBar = YES;
    [self setTitle:@"Mapa"];
    
    self.frostedViewController.delegate = self;
    ((MenuViewController*) self.frostedViewController.menuViewController).delegate = self;
    self.exibirNavigationBar = YES;
    
    if (rota) {
        [self desenharRota];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) desenharRota{
    GMSMutablePath *path = [GMSMutablePath path];
    
    for (int x = 0; x < rota.polyline.pointCount-1; x++) {
        [path addLatitude:rota.polyline.points[x].x longitude:rota.polyline.points[x].y];
    }
    
    GMSPolyline *polyLine = [GMSPolyline polylineWithPath:path];
    polyLine.map = mapView_;
    polyLine.strokeWidth = 5;
    polyLine.geodesic = YES;
    polyLine.strokeColor = [UIColor redColor];
}

#pragma mark - REFrostedViewControllerDelegate
-(void) frostedViewController:(REFrostedViewController *)frostedViewController willHideMenuViewController:(UIViewController *)menuViewController{
    //ir para view selecionada
}

#pragma mark - MenuViewControllerDelegate
-(void)onSelecionouView:(BaseViewController *)viewSelecionada{
    [self.frostedViewController hideMenuViewController];
}

@end
