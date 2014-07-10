//
//  ActivityVamu.m
//  Vamu
//
//  Created by Guilherme Augusto on 17/05/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "ActivityVamu.h"

@implementation ActivityVamu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)exibir{
    self.layer.cornerRadius  = 5;
    self.layer.masksToBounds = YES;
}

@end
