//
//  beerVC.swift
//  brewTest
//
//  Created by Alex Lauderdale on 12/17/16.
//  Copyright © 2016 Alex Lauderdale. All rights reserved.
//

import UIKit
import BreweryDB

class beerVC: UIViewController {

    @IBOutlet weak var beerNameLbl: UILabel!
    
    var beerName = "Ranger"
    var beerDescription = "yay"
    @IBOutlet weak var beerDescriptionLbl: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beerNameLbl.text = beerName
        beerDescriptionLbl.text = beerDescription
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
