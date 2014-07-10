//
//  MascaraHelper.m
//  Vamu
//
//  Created by Márcio S. Manske on 08/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "MascaraHelper.h"

@implementation MascaraHelper


-(void)formatInput:(UITextField*)aTextField string:(NSString*)aString range:(NSRange)aRange mascara:(NSString*) mascara
{
    
    //Copying the contents of UITextField to an variable to add new chars later
    NSString* value = aTextField.text;
    
    NSString* formattedValue = value;
    
    //Make sure to retrieve the newly entered char on UITextField
    aRange.length = 1;
    
    NSString* _mask = [mascara substringWithRange:aRange];
    
    //Checking if there's a char mask at current position of cursor
    if (_mask != nil) {
        NSString *regex = @"[0-9]*";
        
        NSPredicate *regextest = [NSPredicate
                                  predicateWithFormat:@"SELF MATCHES %@", regex];
        //Checking if the character at this position isn't a digit
        if (! [regextest evaluateWithObject:_mask]) {
            //If the character at current position is a special char this char must be appended to the user entered text
            formattedValue = [formattedValue stringByAppendingString:_mask];
        }
        
        if (aRange.location + 1 < [mascara length]) {
            _mask =  [mascara substringWithRange:NSMakeRange(aRange.location + 1, 1)];
            if([_mask isEqualToString:@" "])
                formattedValue = [formattedValue stringByAppendingString:_mask];
        }
    }
    //Adding the user entered character
    formattedValue = [formattedValue stringByAppendingString:aString];
    
    //Refreshing UITextField value
    aTextField.text = formattedValue;
}

- (BOOL)mascarar:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string mascara:(NSString*) mascara
{
        if ([textField.text length] == [mascara length]) {
            if(! [string isEqualToString:@""])
                return NO;
            else
                return YES;
        }
        //If the user has started typing text on UITextField the formatting method must be called
        else if ([textField.text length] || range.location == 0) {
            if (string) {
                if(! [string isEqualToString:@""]) {
                    [self formatInput:textField string:string range:range mascara:mascara];
                    return NO;
                }
                return YES;
            }
            return YES;
        }
    return YES;
}

+(NSString*) MASCARA_CPF {
    return kMascara_CPF;
}

@end
