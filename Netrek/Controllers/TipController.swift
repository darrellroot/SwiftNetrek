//
//  TipController.swift
//  Netrek
//
//  Created by Darrell Root on 3/30/19.
//  Copyright © 2019 Network Mom LLC. All rights reserved.
//

import Cocoa
import StoreKit

enum productIdentifiers: String {
    case tip5 = "net.networkmom.netrek.tip5"
}
class TipController: NSViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    var products: [String:SKProduct] = [:]
    private var productsRequest: SKProductsRequest?
    private var receiptRefreshRequest: SKReceiptRefreshRequest?

    @IBOutlet weak var tipButtonOutlet: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestProducts()
        // Do view setup here.
        self.updateDisplay()
    }
    
    @IBAction func restoreButton(_ sender: NSButton) {
        refreshReceipt()
    }
    
    @IBAction func tipButton(_ sender: NSButton) {
        debugPrint("Tip button pressed")
        if let product = products[productIdentifiers.tip5.rawValue] {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            debugPrint("Unable to find product")
        }
    }
    
    private func updateDisplay() {
        debugPrint("TipController.updateDisplay")
        if UserDefaults.standard.bool(forKey: productIdentifiers.tip5.rawValue) {
            DispatchQueue.main.async {
                self.tipButtonOutlet.title = "Network Mom LLC thanks you for supporting Mac Netrek client development!"
                self.tipButtonOutlet.sizeToFit()
            }
        }
    }
    private func requestProducts() {
        debugPrint("TipController.requestProducts")
        productsRequest?.cancel()
        productsRequest = SKProductsRequest(productIdentifiers: [productIdentifiers.tip5.rawValue])
        productsRequest?.delegate = self
        productsRequest?.start()
    }

    private func refreshReceipt() {
        debugPrint("TipController.refreshReceipt")

        receiptRefreshRequest?.cancel()
        receiptRefreshRequest = SKReceiptRefreshRequest()
        receiptRefreshRequest?.delegate = self
        receiptRefreshRequest?.start()
    }

    func requestDidFinish(_ request: SKRequest) {
        debugPrint("TipController.requestDidFinish")

        getLicensesFromReceipt()
        updateDisplay()
        //printLicenses()
        //SKPaymentQueue.default().restoreCompletedTransactions()
    }

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        debugPrint("TipController.productsRequest")

        for product in response.products {
            debugPrint("Got product response for product \(product.productIdentifier)")
            debugPrint("Product localized title: \(product.localizedTitle)")
            debugPrint("Product localized description: \(product.localizedDescription)")
            products[product.productIdentifier] = product
            if product.productIdentifier == productIdentifiers.tip5.rawValue && UserDefaults.standard.bool(forKey: productIdentifiers.tip5.rawValue) == false {
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .currency
                numberFormatter.locale = product.priceLocale
                let formattedPrice = numberFormatter.string(from: product.price) ?? "\(product.price)"
                DispatchQueue.main.async {
                    self.tipButtonOutlet.title = "\(product.localizedTitle)\n\(product.localizedDescription)\n\(formattedPrice)"
                    self.tipButtonOutlet.sizeToFit()
                }
            }
        }
        updateDisplay()
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                complete(transaction: transaction)
            case .failed:
                //fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            }
        }
    }
    private func restore(transaction: SKPaymentTransaction) {
        debugPrint("TipController.restore")
        processTransaction(transaction: transaction)
    }
    private func complete(transaction: SKPaymentTransaction) {
        debugPrint("TipController.complete")
        processTransaction(transaction: transaction)
    }
    private func processTransaction(transaction: SKPaymentTransaction) {
        debugPrint("TipController.processTransaction")
        printTransaction(transaction: transaction)
        let productIdentifier = transaction.payment.productIdentifier
        guard let transactionIdentifier = transaction.transactionIdentifier else {
            debugPrint("Error: in process transaction but no transaction identifier")
            return
        }
        let transactionDate = transaction.transactionDate ?? Date()
        
        // Now we have a new transaction to enter
        switch productIdentifier {
        case productIdentifiers.tip5.rawValue:
            debugPrint("transactionState \(transaction.transactionState)")
            switch transaction.transactionState {
                
            case .purchasing:
                return
            case .purchased:
                UserDefaults.standard.set(true, forKey: productIdentifiers.tip5.rawValue)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                return
            case .restored:
                debugPrint("attempting to process original transaction")
                if let originalTransaction = transaction.original {
                    processTransaction(transaction: originalTransaction)
                }
                return
            case .deferred:
                return
            }
        default:
            debugPrint("Error: unknown product identifier \(productIdentifier)")
        }
    }

    private func printTransaction(transaction: SKPaymentTransaction) {
        debugPrint("TipController.printTransaction")
        debugPrint("product identifiers \(transaction.payment.productIdentifier)")
        debugPrint("transaction identifiers \(String(describing: transaction.transactionIdentifier))")
        debugPrint("transaction date \(String(describing: transaction.transactionDate))")
        debugPrint("transaction state \(transaction.transactionState.rawValue)")
    }
    private func getLicensesFromReceipt() {
        guard let parsedReceipt = getReceipt() else { return }
        
        for purchase in parsedReceipt.inAppPurchaseReceipts ?? [] {
            if let transactionIdentifier = purchase.transactionIdentifier, let purchaseDate = purchase.purchaseDate, let product = purchase.productIdentifier {
                guard product == productIdentifiers.tip5.rawValue else {
                    debugPrint("Invalid product identifier \(product) found")
                    return
                }
                UserDefaults.standard.set(true, forKey: productIdentifiers.tip5.rawValue)
                debugPrint("Activated new license ID")
            }
        }
    }
    private func getReceipt() -> ParsedReceipt? {
        debugPrint("Trying to analyze receipt")
        let receiptLoader = ReceiptLoader()
        let receiptData: Data
        do {
            receiptData = try receiptLoader.loadReceipt()
        } catch {
            debugPrint("Unable to load in app purchase receipt")
            return nil
        }
        
        let receiptExtractor = ReceiptExtractor()
        guard let receiptContainer: UnsafeMutablePointer<PKCS7> = receiptExtractor.loadReceipt() else {
            debugPrint("Unable to extract in app purchase receipt")
            return nil
        }
        let receiptParser = ReceiptParser()
        var parsedReceipt: ParsedReceipt?
        do {
            parsedReceipt = try receiptParser.parse(receiptContainer)
        } catch {
            debugPrint("Unable to parse in app purcase receipt")
            return nil
        }
        return parsedReceipt
    }

}
