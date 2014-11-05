//
//  KelimeIAPHelper.m
//  YDS Kelime Widget
//
//  Created by Ahmet Yalcinkaya on 11/5/14.
//  Copyright (c) 2014 Hayal Co. All rights reserved.
//

#import "KelimeIAPHelper.h"

static NSString *kIdentifierKelime = @"YDS_ALL_WORDS";

@implementation KelimeIAPHelper

// Obj-C Singleton pattern
+ (KelimeIAPHelper *)sharedInstance
{
    static KelimeIAPHelper *sharedInstance;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        NSSet *productIdentifiers = [NSSet setWithObjects:
                                     kIdentifierKelime,
                                     nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

- (NSString *)descriptionForProduct:(SKProduct *)product
{
    
    if ([product.productIdentifier isEqualToString:kIdentifierKelime])
    {
        return product.localizedDescription;
    }
    return nil;
}

@end
