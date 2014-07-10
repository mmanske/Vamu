//
//  DefinirTrajetoCell.m
//  Vamu
//
//  Created by Guilherme Augusto on 25/03/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "DefinirTrajetoCell.h"

@implementation DefinirTrajetoCell

@synthesize lblDistancia, lblObs, lblTempo;
@synthesize btnDefinirTrajeto;
@synthesize delegate = _delegate;
@synthesize indexArray = _indexArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"DefinirTrajetoCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
    }
    
    [[self delegate] respondsToSelector:@selector(selecionouTrajeto)];
    
    return self;
}

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)hours, (long)minutes];
}

-(DefinirTrajetoCell *)iniciarComRota:(MKRoute *)rota delegate:(id)dele index:(int)index{

    _delegate = dele;
    _indexArray = index;
    
    lblTempo.text = [self stringFromTimeInterval:rota.expectedTravelTime];
    
    float latInicial = rota.polyline.points[0].x;
    float lonInicial = rota.polyline.points[0].y;
    float latFinal   = rota.polyline.points[rota.polyline.pointCount-1].x;
    float lonFinal   = rota.polyline.points[rota.polyline.pointCount-1].y;

    
    CLLocation *localizacaoInicial = [[CLLocation alloc] initWithLatitude:latInicial longitude:lonInicial];
    CLLocation *localicacaoFinal   = [[CLLocation alloc] initWithLatitude:latFinal longitude:lonFinal];
    
    if (latInicial != 0.0f && lonInicial != 0.0f && latFinal != 0.0f && lonFinal != 0.0f) {
        CLLocationDistance distance = [localizacaoInicial distanceFromLocation:localicacaoFinal];
        lblDistancia.text = [NSString stringWithFormat:@"%.1f Km", distance/1000];
        lblDistancia.hidden = NO;
    } else {
        lblDistancia.hidden = YES;
    }
    
    return self;
}

- (IBAction)btnDefinirTrajetoClick:(id)sender {
}
@end
