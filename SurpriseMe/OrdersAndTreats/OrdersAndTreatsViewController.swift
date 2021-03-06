//
//  OrdersAndTreatsViewController.swift
//  SurpriseMe
//
//  Created by Youval Ella on 17/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit


class OrdersAndTreatsViewController: UIViewController {
    
    var myTreats:[Treat]?
    var myTreatsGivers:[String:String]?
    @IBOutlet weak var ordersTreatsSegmented: UISegmentedControl!
    
    @IBAction func showMenu(_ sender: UIBarButtonItem) {
        AppMenu.toggleMenu(parent: self)
    }
    @IBAction func showCart(_ sender: Any) {
        VCManager.shared.initCartVC(caller: self)

    }
    
    @IBAction func showNotifications(_ sender: Any) {
        VCManager.shared.initNotifications(refresh: false, caller: self)

    }
    @IBOutlet weak var ordersTreatsTableView: UITableView!
    
    @IBAction func valueChange(_ sender: UISegmentedControl) {
        ordersTreatsTableView.reloadData()
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        AppMenu.clearMenu()
        
        self.navigationItem.title = "My Treats & Orders"
        
        ordersTreatsTableView.delegate = self
        ordersTreatsTableView.dataSource = self

    }
    override func viewWillDisappear(_ animated: Bool) {
        if var navigationArray = self.navigationController?.viewControllers{
            var remember = -1;
            for i in 0..<navigationArray.count{
                if  let _ = navigationArray[i] as? OrdersAndTreatsViewController{
                    remember = i
                }
            }
            if remember != -1{
                navigationArray.remove(at: remember) // To remove previous UIViewController
                self.navigationController?.viewControllers = navigationArray
            }
        }
        
    }

}

extension OrdersAndTreatsViewController : UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height / 7
    }
    
    
}

extension OrdersAndTreatsViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(ordersTreatsSegmented.selectedSegmentIndex){
        case 0: return  CurrentUser.shared.get()!.myOrders.count
        case 1: return myTreats!.count
        default:
            return 1
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch(ordersTreatsSegmented.selectedSegmentIndex){
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "orderCell") as? OrderCell else{return UITableViewCell()}
            
            
            cell.order = CurrentUser.shared.get()!.myOrders[indexPath.row]
            cell.idLabel.text = CurrentUser.shared.get()!.myOrders[indexPath.row].id
            //to do: don't forget to make the calculation ahead.
            cell.priceLabel.text = "\(CurrentUser.shared.get()!.myOrders[indexPath.row].price) ₪"
            cell.dateLabel.text = CurrentUser.shared.get()!.myOrders[indexPath.row].dateString
            cell.delegate = self
            
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "treatCell") as? TreatCell else{return UITableViewCell()}
            let treat = myTreats![indexPath.row]
            cell.populate(treat:treat,giver: myTreatsGivers![treat.id]!)
            cell.delegate = self
            cell.statusDelegate = self
            return cell
            
        default:
            return UITableViewCell()
        }
        
    }
    
    

}

protocol ShowPopUpDelegate{
    //send treat so you can know if the date was expired or not.
    func useTreat(treat: Treat)
    
    func showTreats(order:Order)
}

extension OrdersAndTreatsViewController : ShowPopUpDelegate{

    
    func useTreat(treat: Treat) {
        let useTreatVC = self.storyboard?.instantiateViewController(withIdentifier: "useTreatController") as! UseTreatViewController
            useTreatVC.treat = treat
            useTreatVC.delegate = self
        
        let _ = PopUp.toggle(child: useTreatVC, parent: self,toggle:true)
 
        
    }
    
    func showTreats(order: Order){
        VCManager.shared.initTreatsForOrder(order: order)
    }

}

protocol SentVoucherDelegate {
    func sentVoucher()
}

extension OrdersAndTreatsViewController : SentVoucherDelegate{
    func sentVoucher() {
            ordersTreatsTableView.reloadData()
    }
}


protocol TreatStatusChangedDelegate{
    func updateStatus(treatID : String,status :TreatStatus)
}

extension OrdersAndTreatsViewController : TreatStatusChangedDelegate,RefreshTreats{
    
    func updateStatus(treatID : String, status :TreatStatus) {
        
        for i in 0..<myTreats!.count{
            if myTreats![i].id == treatID{
                myTreats![i].treatStatus = status
                if ordersTreatsTableView != nil{
                    ordersTreatsTableView.reloadData()
                }
                print("Status changed.")
            }
        }
        
        
    }
    
    func refresh(myTreats: [Treat], myTreatsGivers: [String : String]) {
        self.myTreatsGivers = myTreatsGivers
        self.myTreats = myTreats
        if ordersTreatsTableView != nil{
            ordersTreatsTableView.reloadData()
        }
    }
}
protocol RefreshTreats{
    func refresh(myTreats:[Treat], myTreatsGivers:[String:String])
}
