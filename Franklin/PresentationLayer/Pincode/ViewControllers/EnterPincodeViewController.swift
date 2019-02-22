//
//  EnterPincodeViewController.swift
//  DiveLane
//
//  Created by Anton Grigorev on 13/09/2018.
//  Copyright © 2018 Matter Inc. All rights reserved.
//

import UIKit
import LocalAuthentication
import Web3swift

class EnterPincodeViewController: PincodeViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var closeButton: UIButton!
    
    // MARK: - Internal vars
    
    internal var pincode: String = ""
    internal var status: PincodeEnterStatus = .enter

    internal var enterCase: EnterPincodeCases = .enterWallet
    internal var plasmaTX: PlasmaTransaction?
    internal var etherTX: WriteTransaction?
    
    internal let alerts = Alerts()
    internal let plasmaService = PlasmaService()
    internal let appController = AppController()
    
    // MARK: - Inits
    
    convenience init<T>(for enterCase: EnterPincodeCases, data: T?) {
        self.init()
        self.enterCase = enterCase
        if T.self == PlasmaTransaction.self {
            plasmaTX = data as? PlasmaTransaction
        } else if T.self == WriteTransaction.self {
            etherTX = data as? WriteTransaction
        }
    }
    
    // MARK: - Lifesycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        changePincodeStatus(.enter)
        numsIcons = [firstNum, secondNum, thirdNum, fourthNum]
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        enterWithBiometrics()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        if enterCase == .enterWallet {
            closeButton.alpha = 0
            closeButton.isUserInteractionEnabled = false
        }
        
        let context = LAContext()
        var error: NSError?
        if !context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            disableBiometricsButton(true)
            biometricsButton.isUserInteractionEnabled = false
        }
    }
    
    // MARK: - Screen status

    func disableBiometricsButton(_ disable: Bool = false) {
        biometricsButton.alpha = disable ? 0.0 : 1.0
        biometricsButton.isUserInteractionEnabled = !disable
    }

    func changePincodeStatus(_ newStatus: PincodeEnterStatus) {
        status = newStatus
        messageLabel.text = status.rawValue
        if status == .wrong {
            pincode = ""
            changeNumsIcons(0)
        } else if status == .ready {
            enterWithPincode()
        }
    }
    
    // MARK: - Actions
    
    override func numberPressedAction(number: String) {
        if status == .enter {
            pincode += number
            changeNumsIcons(pincode.count)
            if pincode.count == 4 {
                let newStatus: PincodeEnterStatus = checkPin(pincode) ? .ready : .wrong
                changePincodeStatus(newStatus)
            }
        } else if status == .wrong {
            changePincodeStatus(.enter)
            pincode += number
            changeNumsIcons(pincode.count)
        }
    }
    
    override func deletePressedAction() {
        if pincode != "" {
            pincode.removeLast()
            changeNumsIcons(pincode.count)
        }
    }
    
    override func biometricsPressedAction() {
        enterWithBiometrics()
    }
    
    func enterWithBiometrics() {
        
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            var type = "Touch ID"
            if #available(iOS 11, *) {
                switch context.biometryType {
                case .touchID:
                    type = "Touch ID"
                case .faceID:
                    type = "Face ID"
                case .none:
                    type = "Error"
                }
            }
            
            let reason = "Authenticate with " + type
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                   localizedReason: reason,
                                   reply: { [unowned self] (success, _) in
                                    if success {
                                        self.enterWithPincode()
                                    }
            })
        }
    }

    func checkPin(_ passcode: String) -> Bool {
        do {
            let pincodeItem = KeychainPasswordItem(service: KeychainConfiguration.serviceNameForPincode,
                    account: "pincode",
                    accessGroup: KeychainConfiguration.accessGroup)
            let keychainPincode = try pincodeItem.readPassword()
            return pincode == keychainPincode
        } catch {
            fatalError("Error reading password from keychain - \(error)")
        }
    }

    func enterWithPincode() {
        switch enterCase {
        case .transaction:
            break
//            if let etherTx = etherTX {
//                sendEtherTx(etherTx)
//            } else if let plasmaTX = plasmaTX {
//                sendPlasmaTx(plasmaTX)
//            } else {
//                alerts.showErrorAlert(for: self, error: "Transaction is wrong") { [unowned self] in
//                    returnToStartTab()
//                }
//            }
        default:
            returnToStartTab()
        }
    }

//    func sendPlasmaTx(_ tx: PlasmaTransaction) {
//        DispatchQueue.global().async { [unowned self] in
//            guard let wallet = CurrentWallet.currentWallet else {
//                alerts.showErrorAlert(for: self, error: "Can't figure wallet to use") {
//                    returnToStartTab()
//                }
//                return
//            }
//            let testnet: Bool
//            if CurrentNetwork.currentNetwork == Web3Network(network: .Mainnet) {
//                testnet = false
//            } else if CurrentNetwork.currentNetwork == Web3Network(network: .Rinkeby) {
//                testnet = true
//            } else {
//                alerts.showErrorAlert(for: self, error: "Wrong network \(CurrentNetwork.currentNetwork.name), please choose Mainnet or Rinkeby for tests") {
//                    returnToStartTab()
//                }
//                return
//            }
//            do {
//                let password = try wallet.getPassword()
//                let privateKey = try wallet.getPrivateKey(withPassword: password)
//                let privateKeyData = Data(hex: privateKey)
//                let signedTx = try tx.sign(privateKey: privateKeyData)
//
//                let result = try plasmaService.sendRawTX(transaction: signedTx, onTestnet: testnet)
//                if result {
//                    alerts.showSuccessAlert(for: self) {
//                        returnToStartTab()
//                    }
//                } else {
//                    alerts.showErrorAlert(for: self, error: "Sending failed") {
//                        returnToStartTab()
//                    }
//                }
//            } catch let error {
//                alerts.showErrorAlert(for: self, error: error) {
//                    returnToStartTab()
//                }
//            }
//        }
//    }

//    func sendEtherTx(_ tx: WriteTransaction) {
//        DispatchQueue.global().async { [unowned self] in
//            guard let wallet = CurrentWallet.currentWallet else {
//                alerts.showErrorAlert(for: self, error: "Can't figure wallet to use") {
//                    navigationController?.popViewController(animated: true)
//                }
//                return
//            }
//            do {
//                let password = try wallet.getPassword()
//                let result = try tx.send(password: password, transactionOptions: nil)
//                let hash = result.hash
//                alerts.showSuccessAlert(for: self, with: "Transaction hash: \(hash)", completion: {
//                    returnToStartTab()
//                })
//            } catch let error {
//                alerts.showErrorAlert(for: self, error: error) {
//                    returnToStartTab()
//                }
//            }
//
//        }
//    }

    func returnToStartTab() {
        DispatchQueue.main.asyncAfter(deadline: .now()+0.25) { [unowned self] in
            UIView.animate(withDuration: Constants.Main.animationDuration) { [unowned self] in
                self.view.alpha = 0
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    let tabViewController = self.appController.goToApp()
                    tabViewController.view.backgroundColor = Colors.background
                    let transition = CATransition()
                    transition.duration = Constants.Main.animationDuration
                    transition.type = CATransitionType.push
                    transition.subtype = CATransitionSubtype.fromRight
                    transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
                    self.view.window!.layer.add(transition, forKey: kCATransition)
                    self.present(tabViewController, animated: false, completion: nil)
                })
            }
        }
    }
    
}
