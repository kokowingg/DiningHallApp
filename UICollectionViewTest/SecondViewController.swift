//
//  SecondViewController.swift
//  UICollectionViewTest
//
//  Created by Koko Wing on 4/16/19.
//  Copyright © 2019 Koko Wing. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var diningHours: UILabel!
    
    @IBOutlet weak var diningSwitch: UISwitch!
    @IBAction func valueChanged(_ sender: UISwitch) {
        if diningSwitch.isOn {
            diningHours.text = "S week"
        }
        else {
            diningHours.text = "N week"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(rightSwipe)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
