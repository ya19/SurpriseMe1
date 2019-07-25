//
//  ItemPopUpViewController.swift
//  SurpriseMe
//
//  Created by hackeru on 14/07/2019.
//  Copyright © 2019 Surprise. All rights reserved.
//

import UIKit

class ItemPopUpViewController: UIViewController {
    var item:Product?
    var count:Int?
    var addToCart:Bool = false
    @IBAction func popUpClose(_ sender: UIButton) {
//        self.view.removeFromSuperview()
            self.view.removeFromSuperview()

    }
    
    @IBAction func xBtnClose(_ sender: UIButton) {
        addToCart = false
//        self.view.removeFromSuperview()
        PopUp.remove(controller: self)
        
    }
    @IBAction func addToCart(_ sender: Any) {
        Toast.show(message: "\(item?.name ?? "") added \n to cart", controller: self.parent!)
        addToCart = false
        
        let treat = Treat(id: "#1", date: nil, product: item!, giver: currentUser, getter: nil, treatStatus: TreatStatus.NotUsed)
        CartManager.shared.treats.append(treat)
        
        PopUp.remove(controller: self)
//        self.view.removeFromSuperview()
    }
    
    
    @IBOutlet weak var itemDescription: UITextView!
    @IBOutlet weak var addToCartBtn: SAButton!
    @IBOutlet weak var popUpClose: SAButton!
    @IBOutlet weak var xButton: SAButton!
    
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemTitle: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        AppMenu.clearMenu()
        self.view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        initViews()
        
        // Do any additional setup after loading the view.
    }
    
    func initViews(){
        itemImage.image = item?.image
        itemTitle.text = item?.name
        itemPrice.text = "Price: \(item?.price ?? 0.0)"
        itemDescription.text = item?.desc
        if addToCart{
            addToCartBtn.isHidden = false
            xButton.isHidden = false
        }else{
            popUpClose.isHidden = false
        }
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