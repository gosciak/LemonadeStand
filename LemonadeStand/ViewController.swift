//
//  ViewController.swift
//  LemonadeStand
//
//  Created by Doug Gosciak on 15/01/16.
//  Copyright (c) 2015 Doug Gosciak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //IBOutlets
    @IBOutlet weak var moneySupplyCountLbl: UILabel!
    @IBOutlet weak var lemonSupplyCountLbl: UILabel!
    @IBOutlet weak var iceCubeSupplyCountLbl: UILabel!
    @IBOutlet weak var lemonPurchaseCountLbl: UILabel!
    @IBOutlet weak var iceCubePurchaseCountLbl: UILabel!
    @IBOutlet weak var lemonMixCountLbl: UILabel!
    @IBOutlet weak var iceCubeMixCountLbl: UILabel!

    var supplies = Supplies(aMoney: 10, aLemons: 1, aIceCubes: 1)
    let price = Price()
    
    var lemonsToPurchase = 0
    var iceCubesToPurchase = 0
    
    var lemonsToMix = 0
    var iceCubesToMix = 0
    
    var weatherArray: [[Int]] = [[-10, -9, -5, -7], [5, 8, 10, 9], [22, 25, 27, 23]]
    var weatherToday: [Int] = [0, 0, 0, 0]
    
    var weatherImageView: UIImageView =
                        UIImageView(frame: CGRect(x: 20, y: 50, width: 50, height: 50))

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.addSubview(weatherImageView)
        simulateWeatherToday()
        updateMainView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //IBActions
 
    @IBAction func purchaseLemonButtonPressed(sender: UIButton) {
        if supplies.money >= price.lemon {
            lemonsToPurchase += 1
            supplies.money -= price.lemon
            supplies.lemons += 1
            updateMainView()
        }
        else {
            showAlertWithText(message: "You don't have enough money to buy a lemon")
        }
    }
    
    @IBAction func purchaseIceCubeButtonPressed(sender: UIButton) {
        if supplies.money >= price.iceCube {
            iceCubesToPurchase += 1
            supplies.money -= price.iceCube
            supplies.iceCubes += 1
            updateMainView()
        }
        else {
            showAlertWithText(header: "Error", message: "You don't have enough money to buy an ice cube")
        }
    }
    
    @IBAction func unpurchaseLemonButtonPressed(sender: UIButton) {
        if lemonsToPurchase > 0 {
            lemonsToPurchase -= 1
            supplies.money += price.lemon
            supplies.lemons -= 1
            updateMainView()
        }
        else {
            showAlertWithText(message: "You don't have any lemon to return")
        }
    }
    
    @IBAction func unpurchaseIceCubeButtonPressed(sender: UIButton) {
        if iceCubesToPurchase > 0 {
            iceCubesToPurchase -= 1
            supplies.money += price.iceCube
            supplies.iceCubes -= 1
            updateMainView()
        }
        else {
            showAlertWithText(message: "You don't have any ice cube to return")
        }
    }
    
    @IBAction func mixLemonButtonPressed(sender: UIButton) {
        if supplies.lemons > 0 {
            lemonsToPurchase = 0
            supplies.lemons -= 1
            lemonsToMix += 1
            updateMainView()
        }
        else {
            showAlertWithText(message: "You don't have enough lemon inventory")
        }
    }
    
    @IBAction func mixIceCubeButtonPressed(sender: UIButton) {
        if supplies.iceCubes > 0 {
            iceCubesToPurchase = 0
            supplies.iceCubes -= 1
            iceCubesToMix += 1
            updateMainView()
        }
        else {
            showAlertWithText(message: "You don't have enough ice cube inventory")
        }

    }
    
    @IBAction func unmixLemonButtonPressed(sender: UIButton) {
        if lemonsToMix > 0 {
            lemonsToPurchase = 0
            lemonsToMix -= 1
            supplies.lemons += 1
            updateMainView()
        }
        else {
            showAlertWithText(message: "You have no lemon to un-mix")
        }
    }
    
    @IBAction func unmixIceCubeButtonPressed(sender: UIButton) {
        if iceCubesToMix > 0 {
            iceCubesToPurchase = 0
            iceCubesToMix -= 1
            supplies.iceCubes += 1
            updateMainView()
        }
        else {
            showAlertWithText(message: "You have no ice cube to un-mix")
        }
    }
    
    @IBAction func startDayButtonPressed(sender: UIButton) {
        
//        let customers = Int(arc4random_uniform(UInt32(11)))
        let average = findAverage(weatherToday)
        let customers = Int(arc4random_uniform(UInt32(abs(average))))
        println(" ")
        println("customers: \(customers)")

        if lemonsToMix == 0 || iceCubesToMix == 0 {
            showAlertWithText(message: "You need to add at least 1 Lemon and 1 Ice Cube")
        }
        else {
            let lemonadeRatio = Double(lemonsToMix) / Double(iceCubesToMix)
            for x in 0...(customers - 1) {
                let preference = Double(arc4random_uniform(UInt32(101))) / 100
                if preference < 0.4 && lemonadeRatio > 1 {
                    supplies.money += 1
                    println("Paid LR > 1 for customer no. \(x)")
                }
                else if preference > 0.6 && lemonadeRatio < 1 {
                    supplies.money += 1
                    println("Paid LR < 1 for customer no. \(x)")
                }
                else if preference <= 0.6 && preference >= 0.4 && lemonadeRatio == 1 {
                    supplies.money += 1
                    println("Paid LR = 1 for customer no. \(x)")
                }
                else {
                    println("No pay for customer no. \(x)")
                }
            }
            lemonsToPurchase = 0
            iceCubesToPurchase = 0
            lemonsToMix = 0
            iceCubesToMix = 0
            
            simulateWeatherToday()
            updateMainView()
        }
    }
    
    // Helper functions
    
    func updateMainView() {
        moneySupplyCountLbl.text = "$\(supplies.money)"
        lemonSupplyCountLbl.text = "\(supplies.lemons) Lemons"
        iceCubeSupplyCountLbl.text = "\(supplies.iceCubes) Ice Cubes"
        
        lemonPurchaseCountLbl.text = "\(lemonsToPurchase)"
        iceCubePurchaseCountLbl.text = "\(iceCubesToPurchase)"

        lemonMixCountLbl.text = "\(lemonsToMix)"
        iceCubeMixCountLbl.text = "\(iceCubesToMix)"
    }
    
    func showAlertWithText (header : String = "Warning", message : String) {
        var alert = UIAlertController(
            title: header,
            message: message,
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(
            title: "Ok",
            style: UIAlertActionStyle.Default,
            handler: nil))
        
        self.presentViewController(
            alert,
            animated: true,
            completion: nil)
    }
    
    func simulateWeatherToday() {
        let index = Int(arc4random_uniform((UInt32(weatherArray.count))))
        weatherToday = weatherArray[index]
        
        switch index {
        case 0: weatherImageView.image = UIImage(named: "cold")
        case 1: weatherImageView.image = UIImage(named: "mild")
        case 2: weatherImageView.image = UIImage(named: "warm")
        default: weatherImageView.image = UIImage(named: "warm")
        }
    }
    
    func findAverage(data:[Int]) -> Int {
        var sum = 0
        for x in data {
            sum += x
        }
        
        // Get the average of the items in the sum variable and then round up using the ceil function.
        var average:Double = Double(sum) / Double(data.count)
        var rounded:Int = Int(ceil(average))
        return rounded
    }
    
}

