//
//  ViewController.swift
//  demo
//
//  Created by mac on 09/11/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var dateBtn:UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
  
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }


    @IBAction func selectDateAction(_ sender:UIButton){
        
        iOSDatePicker().showDate(animation: .zoomIn, pickerMode: .date) { (date) in
            let str = Utils.stringFromDate(date: date, format: "dd,MMM yyyy")
            print(str)
            sender.setTitle(str, for: .normal)
        }
        
    }
    
    
    @IBAction func nextDateAction(_ sender:UIButton){
        
        let str = Utils.nextDate()
        dateBtn.setTitle(str, for: .normal)
    }

    
    @IBAction func previosDateAction(_ sender:UIButton){
       
        let str = Utils.nextDate()
        dateBtn.setTitle(str, for: .normal)
    }

    
    
}

