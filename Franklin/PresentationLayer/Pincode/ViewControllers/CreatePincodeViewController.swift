//
//  CreateWalletPincodeViewController.swift
//  DiveLane
//
//  Created by Anton Grigorev on 12/09/2018.
//  Copyright © 2018 Matter Inc. All rights reserved.
//

import UIKit

class CreatePincodeViewController: PincodeViewController {
    
    // MARK: - Internal vars
    
    internal let userDefaults = UserDefaultKeys()

    internal var pincode: String = ""
    internal var repeatedPincode: String = ""
    internal var status: PincodeCreationStatus = .new

    internal var pincodeItems: [KeychainPasswordItem] = []
    
    // MARK: - Lyfesycle

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        disableBiometricsButton(true)
        changePincodeStatus(.new)
        numsIcons = [firstNum, secondNum, thirdNum, fourthNum]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigation(hidden: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setNavigation(hidden: true)
    }
    
    // MARK: - Main setup
    
    func setNavigation(hidden: Bool) {
        navigationController?.setNavigationBarHidden(hidden, animated: true)
        navigationController?.makeClearNavigationController()
    }
    
    func disableBiometricsButton(_ disable: Bool = false) {
        biometricsButton.alpha = disable ? 0.0 : 1.0
        biometricsButton.isUserInteractionEnabled = !disable
    }
    
    // MARK: - Actions

    override func numberPressedAction(number: String) {
        if status == .new {
            pincode += number
            changeNumsIcons(pincode.count)
            if pincode.count == 4 {
                let newStatus: PincodeCreationStatus = .verify
                changePincodeStatus(newStatus)
            }
        } else if status == .verify {
            repeatedPincode += number
            changeNumsIcons(repeatedPincode.count)
            if repeatedPincode.count == 4 {
                let newStatus: PincodeCreationStatus = repeatedPincode == pincode ? .ready : .wrong
                changePincodeStatus(newStatus)
            }
        } else if status == .wrong {
            changePincodeStatus(.verify)
            repeatedPincode += number
            changeNumsIcons(repeatedPincode.count)
        }
    }

    override func deletePressedAction() {
        switch status {
        case .new:
            if pincode != "" {
                pincode.removeLast()
                changeNumsIcons(pincode.count)
            }
        default:
            if repeatedPincode != "" {
                repeatedPincode.removeLast()
                changeNumsIcons(repeatedPincode.count)
            }
        }
    }

    func changePincodeStatus(_ newStatus: PincodeCreationStatus) {
        status = newStatus
        messageLabel.text = status.rawValue
        if status == .wrong {
            repeatedPincode = ""
            changeNumsIcons(0)
        } else if status == .ready {
            savePincode()
        } else if status == .verify {
            changeNumsIcons(0)
        }
    }
    
    func savePincode() {
        DispatchQueue.global().async { [unowned self] in
            do {
                let pincodeItem = KeychainPasswordItem(service: KeychainConfiguration.serviceNameForPincode,
                                                       account: "pincode",
                                                       accessGroup: KeychainConfiguration.accessGroup)
                let pin = self.pincode
                try pincodeItem.savePassword(pin)
                self.userDefaults.setPincodeExists()
                self.finish()
            } catch let error {
                fatalError("Error updating keychain for pin - \(error)")
            }
        }
    }

    func finish() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [unowned self] in
            self.navigationController?.popViewController(animated: true)
        })
    }
}
