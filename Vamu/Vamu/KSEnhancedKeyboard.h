//
//  KSEnhancedKeyboard.h
//  Vamu
//
//  Created by Márcio S. Manske on 03/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol KSEnhancedKeyboardDelegate

- (void)nextDidTouchDown;
- (void)previousDidTouchDown;
- (void)doneDidTouchDown;

@end

@interface KSEnhancedKeyboard : NSObject

@property (nonatomic, strong) id <KSEnhancedKeyboardDelegate> delegate;
- (UIToolbar *)getToolbarWithPrevEnabled:(BOOL)prevEnabled NextEnabled:(BOOL)nextEnabled DoneEnabled:(BOOL)doneEnabled;

@end


