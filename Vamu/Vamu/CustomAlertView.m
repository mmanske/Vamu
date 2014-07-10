//
//  CustomAlertView.m
//  Boticario Mobile
//
//  Created by Guilherme Augusto on 29/04/13.
//  Copyright (c) 2013 CM Net Soluções. All rights reserved.
//

#import "CustomAlertView.h"

@implementation CustomAlertView

@synthesize login;

- (id)init{
    if (self = [super init]) {
        login = NO;
    }
    return self;
}

-(void) layoutSubviews{
    for (UIView *subview in self.subviews) {
        if ([[subview.class description] isEqualToString:@"UIAlertButton"]) {
            UIButton *button = (UIButton *)subview;
            button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Neue" size:button.titleLabel.font.pointSize];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [button setBackgroundImage:[UIImage imageNamed:@"btn-top-dir.png"] forState:UIControlStateNormal];

//            if (login) {
//                if ([button.titleLabel.text isEqualToString:@"Cancelar"] || [button.titleLabel.text isEqualToString:@"Não"]) {
//                    button.frame = CGRectMake(15, 120, button.frame.size.width, button.frame.size.height);
//                } else {
//                    button.frame = CGRectMake(143, 120, button.frame.size.width, button.frame.size.height);
//                }
//            } else {
//                button.frame = CGRectMake(78, 80, button.frame.size.width - 130, button.frame.size.height);
//            }
        }
        
        if ([subview isMemberOfClass:[UIImageView class]]) {
            UIImageView *imgTeste = (UIImageView*)subview;
            [imgTeste setImage:[UIImage imageNamed:@"pop_up_bg.png"]];
            
        }
    }
    if (login) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y - 34, self.frame.size.width, 200);
    }
}

@end
