//
//  JSONObjects.m
//  JSONkitArc
//
//  Created by Marcio Manske on 10/05/12.
//  Copyright (c) 2012 CMNet Solucoes em Infotmatica. All rights reserved.
//

#import "JSONObjects.h"

@implementation NSData(JSONObjects)

- (id)objectFromJSONData {
    NSError *error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:self options:NSJSONReadingMutableContainers error:&error];
    return object;
}

@end

@implementation NSString(JSONObjects)
+(id) objectFromFile:(NSString*) path {
    NSInputStream *stream = [NSInputStream inputStreamWithFileAtPath:path];
    [stream open];
    NSError *error = nil;
    id object = [NSJSONSerialization JSONObjectWithStream:stream options:NSJSONReadingMutableContainers error:&error];
    [stream close];
    return object;
}

- (id)objectFromJSONString {
    //NSData *data = [self dataUsingEncoding: NSASCIIStringEncoding];
    //NSData *data = [self dataUsingEncoding: NSUnicodeStringEncoding];
    NSData *data = [self dataUsingEncoding: NSUTF8StringEncoding allowLossyConversion:YES];
    NSError *error = nil;
    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        NSLog(@"%@", error.localizedDescription);
        NSLog(@"%@", error.localizedFailureReason);
        NSLog(@"%@", error.localizedRecoveryOptions);
    }
    return object;
}

- (NSString *)JSONString {
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self 
                                                options:kNilOptions error:&error];
    if (error != nil) {
        return nil;   
    }
    
    NSString* aStr;
	aStr = [[NSString alloc] initWithData:result encoding:NSASCIIStringEncoding];
    
    return aStr;
}

- (NSData *)JSONData {
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self 
                                                options:kNilOptions error:&error];
    if (error != nil) {
        return nil;   
    }
    return result;   
}

@end


@implementation NSDictionary(JSONObjects)



- (NSString *)JSONString {
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self 
                                                options:kNilOptions error:&error];
    if (error != nil) {
        return nil;   
    }
    
    NSString* aStr;
	aStr = [[NSString alloc] initWithData:result encoding:NSASCIIStringEncoding];
    
    return aStr;
}

- (NSData *)JSONData {
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self 
                                                options:kNilOptions error:&error];
    if (error != nil) {
        return nil;   
    }
    return result;   
}

@end

@implementation NSArray(JSONObjects)


- (NSString *)JSONString {
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self 
                                                options:kNilOptions error:&error];
    if (error != nil) {
        return nil;   
    }
    
    NSString* aStr;
	aStr = [[NSString alloc] initWithData:result encoding:NSASCIIStringEncoding];
    
    return aStr;
}

- (NSData *)JSONData {
    NSError* error = nil;
    id result = [NSJSONSerialization dataWithJSONObject:self 
                                                options:kNilOptions error:&error];
    if (error != nil) {
        return nil;   
    }
    return result;   
}

@end