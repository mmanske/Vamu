//
//  PlacesService.h
//  Vamu
//
//  Created by Guilherme Augusto on 09/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PlacesServiceDelegate <NSObject>

-(void) placesFound:(NSMutableArray*) lugares;
-(void) noPlacesFound;

@end

@interface PlacesService : NSObject<PlacesServiceDelegate>{
    id <PlacesServiceDelegate> delegate;
}

@property (nonatomic) id delegate;

-(void) consultar:(NSString*) lugares;

@end