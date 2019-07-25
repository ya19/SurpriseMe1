//
//  MenuViewController.swift
//  SurpriseMe
//
//  Created by Yossi Appo on 17/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit
let menu = UIStoryboard(name: "Menu", bundle: nil).instantiateViewController(withIdentifier: "menuVC") as! MenuViewController
class MenuViewController: UIViewController {
    var toggle = false
    @IBOutlet weak var table: UITableView!
    
    @IBAction func clear(_ sender: UIButton) {
        AppMenu.clearMenu()
    }
    @IBOutlet weak var screenBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.sendSubviewToBack(screenBtn)
        table.backgroundColor = UIColor(red: 0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1)
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
//        table.scrollToRow(at: IndexPath(row: 3, section: 0), at: .none, animated: true)
        // Do any additional setup after loading the view.

        
        //to do set the current presented view controller, and maybe change the way the menu works so it will work fine. cause if you choose friends and then back to the main its still focused on friends.
        table.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
//        table.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
//        table.reloadData()
 
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get th`e new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension MenuViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.table.frame.height / 4
    }
//    func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath? {
//        return IndexPath(row: checkFocusedCell(), section: 0)
//    }
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Screens(rawValue: indexPath.row)! {
        case Screens.Main:
            menu.toggle = !menu.toggle
            self.view.removeFromSuperview()

            if let _ = self.parent as? CategoriesViewController{
                return
            }else{
                let mainVC = UIStoryboard(name: "ShopsCollection", bundle: nil).instantiateViewController(withIdentifier: "shops") as! CategoriesViewController
                self.parent?.navigationController?.pushViewController(mainVC, animated: true)
                menu.removeFromParent()

                return
            }
        case Screens.MyFriends:
            menu.toggle = !menu.toggle
            self.view.removeFromSuperview()

            if let _ = self.parent as? FriendsViewController{
                return
            }else{
                let friendsVC = UIStoryboard(name: "Friends", bundle: nil).instantiateViewController(withIdentifier: "friends") as! FriendsViewController
                self.parent?.navigationController?.pushViewController(friendsVC, animated: true)
                menu.removeFromParent()

                return
            }
        case Screens.OrdersAndTreats:
            menu.toggle = !menu.toggle
            self.view.removeFromSuperview()

            if let _ = self.parent as? OrdersAndTreatsViewController{
                return
            }else{
                let ordersAndTreatsVC = UIStoryboard(name: "OrdersManagement", bundle: nil).instantiateViewController(withIdentifier: "orders") as! OrdersAndTreatsViewController
                self.parent?.navigationController?.pushViewController(ordersAndTreatsVC, animated: true)
                menu.removeFromParent()
                return
            }
        case .Logout:
            menu.toggle = !menu.toggle
            self.view.removeFromSuperview()
            Toast.show(message: "Logout", controller: self.parent!)
            return
        }
    }
}
extension MenuViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        var ary:[Screens] = Screens.AllCass
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuTableViewCell
        
        if indexPath.row == 0 {
            cell.setSelected(true, animated: true)
            print(indexPath.row)
        }
        let itemTitle = Screens(rawValue: indexPath.row)!.description
        cell.populate(title: itemTitle)
        
        return cell
    }
    func checkFocusedCell() -> Int{
        if let _ = self.parent as? CategoriesViewController{
            return Screens.Main.rawVaule
        }else if let _ = self.parent as? FriendsViewController{
            return Screens.MyFriends.rawVaule
        }else if let _ = self.parent as? OrdersAndTreatsViewController{
            return Screens.OrdersAndTreats.rawVaule
        }
        return -1
    }
    
//    func checkFocused()-> Int{
//        
//
//        switch UIApplication.shared.keyWindow?.rootViewController {
//            
//        case is MenuViewController:
//            return 0
//
//        case UIViewController(nibName: "FriendsViewController", bundle: nil):
//            return 1
//
//        case UIViewController(nibName: "OrdersAndTreatsViewController", bundle: nil):
//            return 2
//
//        default:
//            return -1
//        }
//    }
}