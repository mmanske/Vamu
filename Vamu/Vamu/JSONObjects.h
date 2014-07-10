//
//  JSONObjects.h
//  JSONkitArc
//
//  Created by Marcio Manske on 10/05/12.
//  Copyright (c) 2012 CMNet Solucoes em Infotmatica. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData(JSONObjects)

- (id)objectFromJSONData;

@end

@interface NSString(JSONObjects)

- (id)objectFromJSONString;
+ (id) objectFromFile:(NSString*) path;
- (NSString *)JSONString;
- (NSData *)JSONData;

@end


@interface NSDictionary(JSONObjects)


- (NSString *)JSONString;
- (NSData *)JSONData;

@end

@interface NSArray(JSONObjects)


- (NSString *)JSONString;
- (NSData *)JSONData;

@end
