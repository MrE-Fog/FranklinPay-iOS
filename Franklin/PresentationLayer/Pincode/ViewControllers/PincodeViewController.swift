//
//  PincodeViewController.swift
//  DiveLane
//
//  Created by Anton Grigorev on 12/09/2018.
//  Copyright © 2018 Matter Inc. All rights reserved.
//

import UIKit
import LocalAuthentication

class PincodeViewController: BasicViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var firstNum: UIImageView!
    @IBOutlet weak var secondNum: UIImageView!
    @IBOutlet weak var thirdNum: UIImageView!
    @IBOutlet weak var fourthNum: UIImageView!
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var biometricsButton: PinCodeBiometricsButton!
    @IBOutlet weak var deleteButton: PinCodeDeleteButton!
    
    // MARK: - Vars 
    let animation = AnimationController()

    var numsIcons: [UIImageView]?

    // MARK: - Lifesycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        container.backgroundColor = Colors.background
        var image = UIImage()
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            if #available(iOS 11, *) {
                switch context.biometryType {
                case .touchID:
                    image = UIImage(named: "touch_id") ?? UIImage()
                case .faceID:
                    image = UIImage(named: "face_id") ?? UIImage()
                case .none:
                    image = UIImage()
                }
            }
        }
        biometricsButton.setImage(image, for: .normal)
        
        deleteButton.setImage(UIImage(named: "delete"), for: .normal)
        messageLabel.textColor = Colors.mainBlue
        messageLabel.font = UIFont(name: Constants.Fonts.bold,
                                   size: 22) ?? UIFont.boldSystemFont(ofSize: 22)
        numsIcons = [firstNum, secondNum, thirdNum, fourthNum]
    }
    
    // MARK: - Screen status

    func changeNumsIcons(_ nums: Int) {
        switch nums {
        case 0:
            for i in 0...(numsIcons?.count)! - 1 {
                self.numsIcons![i].image = UIImage(named: "line")
            }
        case 4:
            for i in 0...nums - 1 {
                self.numsIcons![i].image = UIImage(named: "dot")
            }
        default:
            for i in 0...nums - 1 {
                self.numsIcons![i].image = UIImage(named: "dot")
            }
            for i in nums...(numsIcons?.count)! - 1 {
                self.numsIcons![i].image = UIImage(named: "line")
            }
        }
    }
    
    // MARK: - Button actions

    @IBAction func numButtonPressed(_ sender: PinCodeNumberButton) {
        let number = sender.currentTitle!

        animation.pressButtonCanceledAnimation(for: sender, color: Colors.lightBlue)

        numberPressedAction(number: number)

    }

    @IBAction func deletePressed(_ sender: PinCodeDeleteButton) {
        animation.pressButtonCanceledAnimation(for: sender, color: Colors.lightBlue)

        deletePressedAction()
    }

    @IBAction func biometricsPressed(_ sender: PinCodeBiometricsButton) {
        animation.pressButtonCanceledAnimation(for: sender, color: Colors.lightBlue)

        biometricsPressedAction()
    }

    func deletePressedAction() {

    }

    func numberPressedAction(number: String) {

    }

    func biometricsPressedAction() {

    }
}
