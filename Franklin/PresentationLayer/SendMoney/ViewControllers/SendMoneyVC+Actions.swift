//
//  SendMoneyVC+Actions.swift
//  Franklin
//
//  Created by Anton on 20/02/2019.
//  Copyright © 2019 Matter Inc. All rights reserved.
//

import Foundation

extension SendMoneyController {
    
    func sendToken(_ token: ERC20Token) {
        DispatchQueue.global().async { [unowned self] in
            guard let wallet = CurrentWallet.currentWallet else { return }
            guard let amount = self.amountTextField.text else { return }
            guard let address = self.chosenContact?.address else { return }
            do {
                let tx = try wallet.prepareSendERC20Tx(token: token, toAddress: address, tokenAmount: amount, gasLimit: .automatic, gasPrice: .automatic)
                let password = try wallet.getPassword()
                let result = try wallet.sendTx(transaction: tx, options: nil, password: password)
                print(result.transaction.gasLimit)
                print(result.transaction.gasPrice)
                print(result.transaction.hash?.toHexString())
                self.showReady(animated: true)
            } catch let error {
                self.alerts.showErrorAlert(for: self, error: error, completion: { [unowned self] in
                    self.showStart(animated: true)
                })
            }
        }
    }
    
    func sendTokenXDai(_ token: ERC20Token) {
        DispatchQueue.global().async { [unowned self] in
            guard let wallet = CurrentWallet.currentWallet else { return }
            guard let amount = self.amountTextField.text else { return }
            guard let address = self.chosenContact?.address else { return }
            do {
                let tx = try wallet.prepareSendERC20XDaiTx(token: token, toAddress: address, tokenAmount: amount, gasLimit: .automatic, gasPrice: .automatic)
                let password = try wallet.getPassword()
                let result = try wallet.sendTx(transaction: tx, options: nil, password: password)
                print(result.transaction.gasLimit)
                print(result.transaction.gasPrice)
                print(result.transaction.hash?.toHexString())
                self.showReady(animated: true)
            } catch let error {
                self.alerts.showErrorAlert(for: self, error: error, completion: { [unowned self] in
                    self.showStart(animated: true)
                })
            }
        }
    }
    
    func sendEther() {
        DispatchQueue.global().async { [unowned self] in
            guard let wallet = CurrentWallet.currentWallet else { return }
            guard let amount = self.amountTextField.text else { return }
            guard let address = self.chosenContact?.address else { return }
            do {
                let tx = try wallet.prepareSendEthTx(toAddress: address, value: amount, gasLimit: .automatic, gasPrice: .automatic)
                let password = try wallet.getPassword()
                let result = try wallet.sendTx(transaction: tx, options: nil, password: password)
                print(result.transaction.gasLimit)
                print(result.transaction.gasPrice)
                print(result.transaction.hash?.toHexString())
                self.showReady(animated: true)
            } catch let error {
                self.alerts.showErrorAlert(for: self, error: error, completion: { [unowned self] in
                    self.showStart(animated: true)
                })
            }
        }
    }
    
    func sendXDai() {
        DispatchQueue.global().async { [unowned self] in
            guard let wallet = CurrentWallet.currentWallet else { return }
            guard let amount = self.amountTextField.text else { return }
            guard let address = self.chosenContact?.address else { return }
            do {
                let password = try wallet.getPassword()
                let tx = try wallet.prepareSendXDaiTx(toAddress: address, value: amount)
                let result = try wallet.sendTx(transaction: tx, options: nil, password: password)
                print(result.transaction.gasLimit)
                print(result.transaction.gasPrice)
                print(result.transaction.hash?.toHexString())
                self.showReady(animated: true)
            } catch let error {
                self.alerts.showErrorAlert(for: self, error: error, completion: { [unowned self] in
                    self.showStart(animated: true)
                })
            }
        }
    }
}
