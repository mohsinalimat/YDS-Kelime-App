//
//  IAPHelper.swift
//  YDS Kelime Widget
//
//  Created by Ahmet Yalcinkaya on 2/4/15.
//  Copyright (c) 2015 Hayal Co. All rights reserved.
//

import UIKit
import StoreKit

let IAPHelperProductPurchasedNotification:String = "IAPHelperProductPurchasedNotification"

class IAPHelper: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver{
    
    var productsRequest:SKProductsRequest?
    var completionHandler:((Bool,NSArray) -> Void)? // (BOOL success, NSArray *products)
    // ... the list of product identifiers passed in, ...
    var productIdentifiers:NSSet!
    // ... and the list of product identifiers that have been previously purchased.
    var productsDict:[String:SKProduct] = [:]
    
    init(productIdentifiers:NSSet)  {
        super.init()
        self.productIdentifiers = productIdentifiers
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
    }
    
    func requestProductsWithCompletionHandler(handler:((Bool,NSArray) -> Void)) {
        self.completionHandler = handler
        println("Requesting products \(productIdentifiers)")
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest?.delegate = self
        productsRequest?.start()
    }
    
    // Mark: SKProductsRequestDelegate
    
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!)  {
        println("Loaded list of products")
        self.productsRequest = nil
        
        let skproducts = response.products
        for product in skproducts {
            productsDict[product.productIdentifier] = product as? SKProduct
        }
        self.completionHandler?(true, skproducts)
        completionHandler = nil
    }
    
    func request(request: SKRequest!, didFailWithError error: NSError!)  {
        NSLog("Failed to load list of products.");
        
        let alert = UIAlertView(title: "Failed to load list of products.", message: "", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"")
        alert.show()
        
        productsRequest = nil
        self.completionHandler?(false, NSArray())
        self.completionHandler = nil
    }
    
    /*  func productPurchased(productIdentifier:String) -> Bool {
    return productsDict
    }
    */
    
    func buyProduct(product:SKProduct) {
        NSLog("Buying %@ ... (buyProduct ind IAPHelper)", product.productIdentifier);
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.defaultQueue().addPayment(payment)
    }
    
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
        for transaction in transactions as [SKPaymentTransaction] {
            switch transaction.transactionState {
            case .Purchased:
                completeTransaction(transaction)
                break
            case .Failed:
                failedTransaction(transaction)
                break
            case .Restored:
                restoreTransaction(transaction)
                break
            case .Purchasing:
                println("Purchasing!")
            default:
                break
            }
            
        }
    }
    
    func localizedPriceForProduct(product:SKProduct) -> String {
        let priceFormatter = NSNumberFormatter()
        priceFormatter.formatterBehavior = NSNumberFormatterBehavior.Behavior10_4
        priceFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        
        priceFormatter.locale = product.priceLocale
        return priceFormatter.stringFromNumber(product.price)!
    }
    
    func completeTransaction(transaction:SKPaymentTransaction) {
        
        NSLog("completeTransaction...")
        
        let alert = UIAlertView(title: "Satın alma başarılı!", message: "Ürünü satın aldığınız için teşekkürler.", delegate:nil, cancelButtonTitle:"OK")
        alert.show()
        
        self.provideContentForProductIdentifier(transaction.payment.productIdentifier)
        
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
        
    }
    
    func restoreTransaction(transaction:SKPaymentTransaction) {
        println("Restore transaction")
        
        let alert = UIAlertView(title: "İşleminiz başarıyla tamamlandı!", message: "İyi eğlenceler!", delegate:nil, cancelButtonTitle:"OK")
        alert.show()
        
        self.provideContentForProductIdentifier(transaction.originalTransaction.payment.productIdentifier)
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
        
    }
    
    func failedTransaction(transaction:SKPaymentTransaction) {
        println("Failed transaction")
        if transaction.error.code != SKErrorPaymentCancelled {
            
            let alert = UIAlertView(title: "Hata!", message: "Bir Hata Oluştu.", delegate:nil, cancelButtonTitle:"OK")
            alert.show()
            
            println("Transaction error: \(transaction.error.localizedDescription)")
        }
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
    }
    
    func restoreCompletedTransactions() {
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }
    
    func provideContentForProductIdentifier(productIdentifier:String) {
        NSLog("provideContentForProductIdentifier")
        
        NSNotificationCenter.defaultCenter().postNotificationName(IAPHelperProductPurchasedNotification, object: productIdentifier)
        
    }
}
