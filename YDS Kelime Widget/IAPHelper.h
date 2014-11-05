//
//  IAPHelper.h
//  BuyFruit
//
//  Created by Michael Beyer on 12.09.13.
//  Copyright (c) 2013 Michael Beyer. All rights reserved.
//

@import Foundation;
@import StoreKit;

// Declaration of a notification we'll use to notify listeners when a product has been purchased
UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;

// Block definition
typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray *products);

@interface IAPHelper : NSObject

// Method definition
// Initializer that takes a list of product identifiers, such as de.smmb.buyfruit.apple, de.smmb.buyfruit.orange, etc.
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
// Method to retrieve information about the products from iTunes Connect
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;
// Method to start buying a product
- (void)buyProduct:(SKProduct *)product;
// Method to determine if a product has been purchased
- (BOOL)productPurchased:(NSString *)productIdentifier;
// Method to restore completed transactions
- (void)restoreCompletedTransactions;

@end
