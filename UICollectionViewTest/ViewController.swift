//
//  ViewController.swift
//  UICollectionViewTest
//
//  Created by Koko Wing on 4/12/19.
//  Copyright © 2019 Koko Wing. All rights reserved.
//

import UIKit
import GoogleSignIn

@objc(ViewController)

class ViewController: UIViewController, GIDSignInUIDelegate, UICollectionViewDataSource, UICollectionViewDelegate  {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var scrollingTimer = Timer()
    
    var dataArray:[String] = ["avocadoToast", "burgerFries", "caeserSalad", "chickenSandwhich", "chickenTortillaSoup", "roastedPotatoes", "salmon", "tacos", "tritip"]
    
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var disconnectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        //automatically sign in the user
        GIDSignIn.sharedInstance().signInSilently()
        
        // TODO(developer) Configure the sign-in button look/feel
        // [START_EXCLUDE]
        NotificationCenter.default.addObserver(self,
            selector: #selector(ViewController.receiveToggleAuthUINotification(_:)),
            name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
            object: nil)
        
        statusText.text = "Initialized Swift app..."
        toggleAuthUI()
        // [END_EXCLUDE]
        
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+3) {
//            self.performSegue(withIdentifier: "nextPage", sender: nil)
//        }
        
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(rightSwipe)
        
    
    }
    
    
    @IBAction func didTapSignOut(_ sender: Any) {
        GIDSignIn.sharedInstance().signOut()
        statusText.text = "Signed out."
        toggleAuthUI()
    }
    
    @IBAction func didTapDisconnect(_ sender: Any) {
        GIDSignIn.sharedInstance().disconnect()
        statusText.text = "Disconnecting."
    }
    
    // [START toggle_auth]
    func toggleAuthUI() {
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            // Signed in
            signInButton.isHidden = true
            signOutButton.isHidden = false
            disconnectButton.isHidden = false
        } else {
            signInButton.isHidden = false
            signOutButton.isHidden = true
            disconnectButton.isHidden = true
            statusText.text = "Google Sign in\niOS Demo"
        }
    }
    // [END toggle_auth]
    
    @objc func receiveToggleAuthUINotification(_ notification: NSNotification) {
        if notification.name.rawValue == "ToggleAuthUINotification" {
            self.toggleAuthUI()
            if notification.userInfo != nil {
                guard let userInfo = notification.userInfo as? [String:String] else { return }
                self.statusText.text = userInfo["statusText"]!
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self,
            name: NSNotification.Name(rawValue: "ToggleAuthUINotification"),
            object: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CustomCollectionViewCell
        
        cell.myImage.image = UIImage(named: dataArray[indexPath.row])
        
        var rowIndex = indexPath.row
        let numberOfRecords:Int = self.dataArray.count - 1
        if (rowIndex < numberOfRecords) {
            rowIndex = (rowIndex + 1)
        }else {
            rowIndex = 0
        }
        
        scrollingTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(ViewController.startTimer(theTimer:)), userInfo: rowIndex, repeats: true)
        
        return cell
    }

    @objc func startTimer(theTimer:Timer) {
        UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
            self.collectionView.scrollToItem(at: IndexPath(row: theTimer.userInfo! as! Int,section:0), at: .centeredHorizontally, animated: false)
        }, completion: nil)
    }
}

extension UIViewController {
    @objc func swipeAction(swipe:UISwipeGestureRecognizer) {
        switch swipe.direction.rawValue {
        case 1:
            performSegue(withIdentifier: "goLeft", sender: self)
        case 2:
            performSegue(withIdentifier: "goRight", sender: self)
//        case 3:
//            performSegue(withIdentifier: "goingLeft", sender: self)
//        case 4:
//            performSegue(withIdentifier: "goingRight", sender: self)
        default:
            
            break
        }
    }
}
