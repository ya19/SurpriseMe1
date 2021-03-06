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
    var delegateShop:ReleaseToggle?
    var delegateCart:ReleaseCartToggle?
    @IBAction func popUpClose(_ sender: UIButton) {
        if delegateCart != nil{
            delegateCart?.releaseCartToggle()
        }
            self.view.removeFromSuperview()
        
    }
    
    @IBAction func xBtnClose(_ sender: UIButton) {
        addToCart = false
        if delegateCart != nil{
            delegateCart?.releaseCartToggle()
        }
        if delegateShop != nil{
            delegateShop?.releaseToggle()
        }
        PopUp.remove(controller: self)
        
    }
    @IBAction func addToCart(_ sender: Any) {
        Toast.show(message: "\(item?.name ?? "") added \n to cart", controller: self.parent!)
        addToCart = false
        if delegateShop != nil{
            delegateShop?.releaseToggle()
        }
        
        
        let treat = Treat(id: "", date: nil, orderId: nil, product: item!, giver: CurrentUser.shared.get()!.id, getter: nil, treatStatus: TreatStatus.Pending)
        UsersManager.shared.addToCart(treat: treat)
        
        PopUp.remove(controller: self)
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
        
    }
    
    func initViews(){
        itemImage.image = item?.image
        itemTitle.text = item?.name
        itemPrice.text = "Price: \(item?.price ?? 0.0) ₪"
        itemDescription.text = item?.desc
        if addToCart{
            addToCartBtn.isHidden = false
            xButton.isHidden = false
        }else{
            popUpClose.isHidden = false
        }
    }

}
