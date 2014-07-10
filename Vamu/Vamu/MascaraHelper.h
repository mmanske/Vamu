//
//  MascaraHelper.h
//  Vamu
//
//  Created by Márcio S. Manske on 08/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kMascara_CPF @"000.000.000-00";

@interface MascaraHelper : NSObject

+(NSString*) MASCARA_CPF;

-(void)formatInput:(UITextField*)aTextField string:(NSString*)aString range:(NSRange)aRange mascara:(NSString*) mascara;
- (BOOL)mascarar:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string mascara:(NSString*) mascara;

@end
