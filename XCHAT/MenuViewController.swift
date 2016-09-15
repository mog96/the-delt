//
//  MenuViewController.swift
//  XCHAT
//
//  Created by Mateo Garcia on 5/13/15.
//  Copyright (c) 2015 Mateo Garcia. All rights reserved.
//

import UIKit
import Parse

protocol MenuDelegate {
    func menuButtonTapped()
}

class MenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var hamburgerViewController: HamburgerViewController?
    
    let kProfileCellHeight: CGFloat = 172
    let kMenuCellHeight: CGFloat = 55
    // var kNumCells = 7
    var kNumCells = 8 // FOR ADMIN
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.tableView.canCancelContentTouches = false
        
        if let isAdmin = PFUser.currentUser()?.objectForKey("isAdmin") as? Bool {
            if isAdmin {
                self.kNumCells = 8
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

    
// MARK: Table View

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCellWithIdentifier("ProfileCell")!
        case 1:
            cell = tableView.dequeueReusableCellWithIdentifier("ReelCell")!
        case 2:
            cell = tableView.dequeueReusableCellWithIdentifier("ChatCell")!
        case 3:
            cell = tableView.dequeueReusableCellWithIdentifier("AuxCell")!
        case 4:
            cell = tableView.dequeueReusableCellWithIdentifier("CalendarCell")!
        case 5:
            cell = tableView.dequeueReusableCellWithIdentifier("MembersCell")!
        case 7:
            cell = tableView.dequeueReusableCellWithIdentifier("AdminCell")!
        default:
            cell = tableView.dequeueReusableCellWithIdentifier("SettingsCell")!
        }
        
        cell.frame.size.height = self.kMenuCellHeight
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.kNumCells
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return self.kProfileCellHeight
        default:
            return self.kMenuCellHeight
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        print(indexPath.row)
        switch indexPath.row {
        case 0: // PROFILE
            let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)
            let profileController = profileStoryboard.instantiateViewControllerWithIdentifier("ProfileNavigationController") as! UINavigationController
            PFUser.currentUser()?.fetchInBackground()
            
            self.hamburgerViewController?.contentViewController = profileController
            
        case 1: // REEL
            let reelStoryboard = UIStoryboard(name: "Reel", bundle: nil)
            let reelNavigationController = reelStoryboard.instantiateViewControllerWithIdentifier("ReelNavigationController") as! UINavigationController
            let firstViewController = reelNavigationController.viewControllers[0] as! ReelViewController
            firstViewController.menuDelegate = self
            
            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Slide)
            self.hamburgerViewController?.contentViewController = reelNavigationController
            
        case 2: // CHAT
            let chatStoryboard = UIStoryboard(name: "Chat", bundle: nil)
            let chatNavigationController = chatStoryboard.instantiateViewControllerWithIdentifier("ChatNavigationController") as! UINavigationController
            let firstViewController = chatNavigationController.viewControllers[0] as! ChatViewController
            firstViewController.menuDelegate = self
            
            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Slide)
            self.hamburgerViewController?.contentViewController = chatNavigationController
            
        case 3: // AUX
            let storyboard = UIStoryboard(name: "Aux", bundle: nil)
            let nc = storyboard.instantiateViewControllerWithIdentifier("AuxNC") as! UINavigationController
            let firstVC = nc.viewControllers[0] as! AuxViewController
            firstVC.menuDelegate = self
            
            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Slide)
            self.hamburgerViewController?.contentViewController = nc
            
        case 4: // CALENDAR
            let calendarStoryboard = UIStoryboard(name: "Calendar", bundle: nil)
            let calendarNavigationController = calendarStoryboard.instantiateViewControllerWithIdentifier("Nav") as! UINavigationController
            let firstViewController = calendarNavigationController.viewControllers[0] as! CalendarViewController
            firstViewController.menuDelegate = self
            
            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Slide)
            self.hamburgerViewController?.contentViewController = calendarNavigationController
            
        case 5: // MEMBERS
            let storyboard = UIStoryboard(name: "Members", bundle: nil)
            let nc = storyboard.instantiateViewControllerWithIdentifier("Members") as! UINavigationController
            let firstViewController = nc.viewControllers[0] as! MembersViewController
            firstViewController.menuDelegate = self
            firstViewController.hamburgerViewController = self.hamburgerViewController
            
            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Slide)
            self.hamburgerViewController?.contentViewController = nc
            
        case 7: // ADMIN
            let storyboard = UIStoryboard(name: "Admin", bundle: nil)
            let nc = storyboard.instantiateViewControllerWithIdentifier("AdminNC") as! UINavigationController
            let firstVC = nc.viewControllers[0] as! AdminViewController
            firstVC.menuDelegate = self
            firstVC.hamburgerViewController = self.hamburgerViewController
            
            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Slide)
            self.hamburgerViewController?.contentViewController = nc
            
        default: // SETTINGS
            let settingsStoryboard = UIStoryboard(name: "Settings", bundle: nil)
            let settingsNavigationController = settingsStoryboard.instantiateViewControllerWithIdentifier("SettingsNavigationController") as! UINavigationController
            let firstViewController = settingsNavigationController.viewControllers[0] as! SettingsViewController
            firstViewController.menuDelegate = self
            
            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: .Slide)
            self.hamburgerViewController?.contentViewController = settingsNavigationController
        }
        
    }
}


// MARK: - Menu Delegate

extension MenuViewController: MenuDelegate {
    func menuButtonTapped() {
        
        print("SHOW HIDE MENU")
        
        self.hamburgerViewController?.showOrHideMenu()
    }
}
