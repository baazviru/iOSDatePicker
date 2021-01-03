//
//  VRDatePicker.swift
//  demo
//
//  Created by mac on 18/11/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit

enum AnimationType{
    case scale
    case rotate
    case bounceUp
    case zoomIn
}

var currentDate = Date()
class iOSDatePicker: UIViewController {
    
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var title_lbl: UILabel!
    
    var userAction:((_ callback: Date) -> Void)? = nil
    var animationType: AnimationType = .scale
    var pickerMode = UIDatePicker.Mode.date
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.alpha = 0
        datePicker.datePickerMode = pickerMode
        datePickerView.layer.shadowColor = #colorLiteral(red: 0.07449653, green: 0.07451746613, blue: 0.07449520379, alpha: 1)
        datePickerView.layer.shadowOpacity = 0.4
        datePickerView.layer.shadowOffset = CGSize(width: 0, height: 5)
        datePickerView.layer.shadowRadius = 15
        
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(didTap))
        self.view.addGestureRecognizer(gesture)
        

        
        
        
        if pickerMode == .date{
            title_lbl.text = "Select Date"
        }
        else if pickerMode == .dateAndTime{
            title_lbl.text = "Select Date and Time"
        }
        else if pickerMode == .time{
            title_lbl.text = "Select Time"
        }else{
            title_lbl.text = "Select count down timer"
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startAnimating(type: self.animationType)
    }
    
    @IBAction func cancelAction(_ sender:UIButton){
        
        closeWithAnimation()
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func doneAction(_ sender:UIButton){
        
        currentDate = datePicker.date
        if userAction != nil{
            userAction!(datePicker.date)
        }
        
        closeWithAnimation()
        dismiss(animated: true, completion: nil)
        
    }
   
    @objc func didTap(_ sender:UITapGestureRecognizer){
        closeWithAnimation()
        dismiss(animated: true, completion: nil)
    }
    

    
    
    func showDate(animation: AnimationType, pickerMode:UIDatePicker.Mode, action: ((_ value: Date) -> Void)? = nil) {
        
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
        
        self.pickerMode = pickerMode
        self.animationType = animation
        userAction = action
        
        guard let viewController = Utils.topViewController()else{return}
        viewController.present(self, animated: true, completion: nil)
        
    }
    
    
    private func startAnimating(type: AnimationType) {
        switch type {
        case .rotate:
            datePickerView.transform = CGAffineTransform(rotationAngle: 1.5)
        case .bounceUp:
            let screenHeight = UIScreen.main.bounds.height/2 + datePickerView.frame.height/2
            datePickerView.transform = CGAffineTransform(translationX: 0, y: screenHeight)
        case .zoomIn:
            print("helo")
            datePickerView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        default:
            datePickerView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            print("use new animation ")
        }
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.view.alpha = 1
            self.datePickerView.transform = .identity
        }, completion: nil)
        
    }
    
    func closeWithAnimation(){
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
            self.view.alpha = 0
            if self.animationType == .bounceUp{
                let screenHeight = (UIScreen.main.bounds.height/2 + self.datePickerView.frame.height/2)
                self.datePickerView.transform =  CGAffineTransform(translationX: 0, y: screenHeight)
            }else if self.animationType == .zoomIn{
                self.datePickerView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }else{
                self.datePickerView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            }
            
        }, completion: nil)
        
    }
  
}

class Utils {
    
    static func stringFromDate(date:Date,format:String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let dateStr = dateFormatter.string(from: date)
        return dateStr
        
    }
    
    static func topViewController() -> UIViewController? {
        return topViewController(vc: UIApplication.shared.windows.last?.rootViewController)
    }
    
    private static func topViewController(vc:UIViewController?) -> UIViewController? {
        if let rootVC = vc {
            guard let presentedVC = rootVC.presentedViewController else {
                return rootVC
            }
            if let presentedNavVC = presentedVC as? UINavigationController {
                let lastVC = presentedNavVC.viewControllers.last
                return topViewController(vc: lastVC)
            }
            return topViewController(vc: presentedVC)
        }
        return nil
    }
    
    static func previousDate()-> String{
        let current = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
        currentDate = current
        return Utils.stringFromDate(date: current, format: "dd,MMM yyyy")
    }
    
    static func nextDate() -> String{
        
        let current = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        currentDate = current
        return Utils.stringFromDate(date: current, format: "dd,MMM yyyy")
    }

}



