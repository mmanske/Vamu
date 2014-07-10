//
//  KSEnhancedKeyboard.m
//  Vamu
//
//  Created by Márcio S. Manske on 03/07/14.
//  Copyright (c) 2014 Enter Sistemas. All rights reserved.
//

#import "KSEnhancedKeyboard.h"

@implementation KSEnhancedKeyboard

- (void)nextPrevHandlerDidChange:(id)sender
{
    if (!self.delegate) return;
    
    switch ([(UISegmentedControl *)sender selectedSegmentIndex])
    {
        case 0:
            [self.delegate previousDidTouchDown];
            break;
        case 1:
            [self.delegate nextDidTouchDown];
            break;
        default:
            break;
    }
}

- (void)doneDidClick:(id)sender
{
    if (!self.delegate) return;
    [self.delegate doneDidTouchDown];
}

- (UIToolbar *)getToolbarWithPrevEnabled:(BOOL)prevEnabled NextEnabled:(BOOL)nextEnabled DoneEnabled:(BOOL)doneEnabled
{
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.tintColor = [UIColor colorWithRed:51 green:51 blue:51 alpha:1];
    //[toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar setBarStyle:UIBarStyleBlackOpaque];
    [toolbar sizeToFit];
    
    NSMutableArray *toolbarItems = [[NSMutableArray alloc] init];
    
    UISegmentedControl *leftItems = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Anterior", @"Próximo", nil]];


    [leftItems setEnabled:prevEnabled forSegmentAtIndex:0];
    [leftItems setEnabled:nextEnabled forSegmentAtIndex:1];
    leftItems.momentary = YES; // do not preserve button's state
    [leftItems addTarget:self action:@selector(nextPrevHandlerDidChange:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem *nextPrevControl = [[UIBarButtonItem alloc] initWithCustomView:leftItems];
    nextPrevControl.style = UIBarButtonItemStyleBordered;
    [toolbarItems addObject:nextPrevControl];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [toolbarItems addObject:flexSpace];
    
    //UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneDidClick:)];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"OK"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                                                  action:@selector(doneDidClick:)];
    
    
    [toolbarItems addObject:doneButton];
    
    toolbar.items = toolbarItems;
    
    return toolbar;
}


@end
