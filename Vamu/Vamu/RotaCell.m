//
//  RotaCell.m
//  Vamu
//
//  Created by Guilherme Augusto on 09/04/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "RotaCell.h"
#import "CustomAnnotation.h"

#define MINIMUM_ZOOM_ARC 0.014
#define ANNOTATION_REGION_PAD_FACTOR 1.15
#define MAX_DEGREES_ARC 360

@implementation RotaCell{
    MKRoute *_route;
    NSIndexPath *_indexPath;
    __weak IBOutlet UILabel *lblTempo;
    __weak IBOutlet UILabel *lblDistancia;
    __weak IBOutlet UILabel *lblRouteName;
    __weak IBOutlet MKMapView *mapa;
}

@synthesize delegate, favorita, btnEstrela;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"RotaCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
    }

    return self;
}

- (IBAction)btnIniciarNagevacaoClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(iniciarRota:)]) {
        [delegate iniciarRota:_route];
    }
}

-(RotaCell*)initWithRoute:(MKRoute *)route indexPath:(NSIndexPath *)indexPath delegate:(id<RotaCellDelegate>)viewDelegate favorito:(BOOL)favorito{
    _route = route;
    _indexPath = indexPath;
    self.favorita = favorito;
    self.delegate = viewDelegate;
    [self inicia];
    return self;
}

-(RotaCell *)initWithRotaVO:(RotasVO *)rota indexPath:(NSIndexPath *)indexPath delegate:(id<RotaCellDelegate>)viewDelegate{
    self.rotaVO = rota;
    _indexPath = indexPath;
    _route = rota.rota;
    self.favorita = rota.trajetoFavorito ? YES : NO;
    self.delegate = viewDelegate;
    [self inicia];
    return self;
}

- (IBAction)btnEstrelaClick:(id)sender {
    self.favorita = !self.favorita;
    [self imagemFavorita];
    if (self.delegate) {
        if (!self.favorita) {
            if ([self.delegate respondsToSelector:@selector(removerRotaFavorita:)]) {
                [delegate removerRotaFavorita:self.rotaVO];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(salvarRotaFavorita:)]) {
                [delegate salvarRotaFavorita:self.rotaVO.rota];
            }
        }
    }
}

-(void) inicia{
    mapa.mapType = MKMapTypeStandard;
    mapa.delegate = self;
    mapa.showsUserLocation = YES;
    [mapa removeOverlays:[mapa overlays]];
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.3f, 0.3f);
    
    MKCoordinateRegion regionSrc = {mapa.userLocation.coordinate, span};
    MKCoordinateRegion regionThatFits = [mapa regionThatFits:regionSrc];
    
    [mapa setRegion:regionThatFits animated:NO];
    [mapa setMapType:MKMapTypeStandard];
    
    lblTempo.text = [self stringFromTimeInterval:_route.expectedTravelTime];
    lblDistancia.text = [NSString stringWithFormat:@"%.1f Km", _route.distance/1000];
    if (_rotaVO && _rotaVO.trajetoFavorito) {
        lblRouteName.text = [NSString stringWithFormat:@"%@ %@", self.rotaVO.trajetoFavorito.descricao, _route.name];
    } else {
        lblRouteName.text = _route.name;
    }
    [mapa addOverlay:_route.polyline level:MKOverlayLevelAboveRoads];
    
    [self zoomMapViewToFitAnnotations:mapa animated:YES];
    
    [self imagemFavorita];
}

-(void) imagemFavorita{
    if (self.favorita) {
        [btnEstrela setBackgroundImage:[UIImage imageNamed:@"ico-estrela-amarela_5.png"] forState:UIControlStateNormal];
    } else {
        [btnEstrela setBackgroundImage:[UIImage imageNamed:@"ico-estrela-cinza_5.png"] forState:UIControlStateNormal];
    }
}

-(void) createAndAddAnnotationForCoordinate : (CLLocationCoordinate2D) coordinate expectedTime:(NSTimeInterval) expectedTime{
    CustomAnnotation *annotation = [[CustomAnnotation alloc] initWithLocation:coordinate expectedTravelTime:expectedTime];
    [mapa addAnnotation:annotation];
}

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02ld h %02ld min", (long)hours, (long)minutes];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor colorWithRed:0.5 green:0.5 blue:1.0 alpha:0.5];
    renderer.lineWidth = 5.0;
    return renderer;
}

- (void)zoomMapViewToFitAnnotations:(MKMapView *)mapView animated:(BOOL)animated
{
    NSArray *annotations = mapView.annotations;
    NSInteger count = [mapView.annotations count];
    if ( count == 0) { return; } //bail if no annotations
    
    //convert NSArray of id <MKAnnotation> into an MKCoordinateRegion that can be used to set the map size
    //can't use NSArray with MKMapPoint because MKMapPoint is not an id
    MKMapPoint points[count]; //C array of MKMapPoint struct
    for( int i=0; i<count; i++ ) //load points C array by converting coordinates to points
    {
        CLLocationCoordinate2D coordinate = [(id <MKAnnotation>)[annotations objectAtIndex:i] coordinate];
        points[i] = MKMapPointForCoordinate(coordinate);
    }
    //create MKMapRect from array of MKMapPoint
    MKMapRect mapRect = [[MKPolygon polygonWithPoints:points count:count] boundingMapRect];
    //convert MKCoordinateRegion from MKMapRect
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    
    //add padding so pins aren't scrunched on the edges
    region.span.latitudeDelta  *= ANNOTATION_REGION_PAD_FACTOR;
    region.span.longitudeDelta *= ANNOTATION_REGION_PAD_FACTOR;
    //but padding can't be bigger than the world
    if( region.span.latitudeDelta > MAX_DEGREES_ARC ) { region.span.latitudeDelta  = MAX_DEGREES_ARC; }
    if( region.span.longitudeDelta > MAX_DEGREES_ARC ){ region.span.longitudeDelta = MAX_DEGREES_ARC; }
    
    //and don't zoom in stupid-close on small samples
    if( region.span.latitudeDelta  < MINIMUM_ZOOM_ARC ) { region.span.latitudeDelta  = MINIMUM_ZOOM_ARC; }
    if( region.span.longitudeDelta < MINIMUM_ZOOM_ARC ) { region.span.longitudeDelta = MINIMUM_ZOOM_ARC; }
    //and if there is a sample of 1 we want the max zoom-in instead of max zoom-out
    if( count == 1 )
    {
        region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
        region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
    }
    [mapView setRegion:region animated:animated];
}

@end
