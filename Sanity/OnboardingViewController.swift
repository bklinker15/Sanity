//
//  OnboardingViewController.swift
//  Sanity
//
//  Created by Jordan Coppert on 11/19/17.
//  Copyright © 2017 CSC310Team22. All rights reserved.
//

import UIKit
import paper_onboarding

class OnboardingViewController: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate {
    var userEmail:String!
    var visited:Bool = false
    
    @IBOutlet weak var completeOnboardingButton: UIButton!
    @IBOutlet weak var onboardingView: OnboardingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onboardingView.dataSource = self
        onboardingView.delegate = self
        completeOnboardingButton.layer.cornerRadius = 15
        completeOnboardingButton.clipsToBounds = true
        completeOnboardingButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if visited == true {
            self.dismiss(animated: false, completion: nil)
        } else {
            visited = true
        }
    }
    
    func onboardingItemsCount() -> Int {
        return 5
    }
    
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        let backgroundColor1 = UIColor(red: 66/255, green: 244/255, blue: 161/255, alpha: 1)
        let backgroundColor2 = UIColor(red: 65/255, green: 244/255, blue: 190/255, alpha: 1)
        
        let titleFont = UIFont(name: "DidactGothic-Regular", size: 36)
        let descriptionFont = UIFont(name: "DidactGothic-Regular", size: 24)
        
        return [(imageName: UIImage(named: "dollarSign")!, title: "Budgeting made simple.", description: "Welcome to $anity! Before you get started being a budgeting-pro here's some tips to get you started", iconName: UIImage(), color: backgroundColor1, titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont!, descriptionFont: descriptionFont!),
                (imageName: UIImage(named: "chart")!, title: "Break it down!", description: "Tap on any budget to see how you've been your spending money, the money you have left to spend in the current budget period, or to edit the budget", iconName: UIImage(), color: backgroundColor2, titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont!, descriptionFont: descriptionFont!),
                (imageName: UIImage(named: "piggybank")!, title: "Waste not, want not.", description: "Money left over in a budget rolls over to the next budget period!", iconName: UIImage(), color: backgroundColor1, titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont!, descriptionFont: descriptionFont!),
                (imageName: UIImage(named: "gas")!, title: "Pump the brakes!", description: "If you go over budget in one period, your spending limit for the next will be automatically reduced so you know to spend wisely.", iconName: UIImage(), color: backgroundColor2, titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont!, descriptionFont: descriptionFont!),
                (imageName: UIImage(named: "add")!, title: "Ready, set, go!", description: "Tap the plus icon to create your first budget and start adding purchases. Happy budgeting :)", iconName: UIImage(), color: backgroundColor1, titleColor: UIColor.white, descriptionColor: UIColor.white, titleFont: titleFont!, descriptionFont: descriptionFont!)
            ][index]
        
    }
    
    @objc func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index == 3 {
            if self.completeOnboardingButton.alpha == 1.0 {
                UIView.animate(withDuration: 0.4, animations: {
                    self.completeOnboardingButton.alpha = 0.0
                })
            }
        }
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 4 {
            UIView.animate(withDuration: 0.4, animations: {
                self.completeOnboardingButton.alpha = 1
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case "onboardingComplete":
                let destination = segue.destination as? UINavigationController
                if let vc = destination?.topViewController as? DashboardViewController {
                    //vc.userEmail = self.userEmail
                }
            default: break
            }
        }
    }

}
