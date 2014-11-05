//
//  KelimeIAPHelper.h
//  YDS Kelime Widget
//
//  Created by Ahmet Yalcinkaya on 11/5/14.
//  Copyright (c) 2014 Hayal Co. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IAPHelper.h"

@interface KelimeIAPHelper : IAPHelper

+ (KelimeIAPHelper *)sharedInstance;

- (NSString *)descriptionForProduct:(SKProduct *)product;

@end
