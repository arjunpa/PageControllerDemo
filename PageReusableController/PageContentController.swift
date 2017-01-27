//
//  PageContentController.swift
//  PageReusableController
//
//  Created by Arjun P A on 26/01/17.
//  Copyright © 2017 Arjun P A. All rights reserved.
//

import UIKit

class PageContentController: UIViewController, ACReusableObject {

    var reuseIdentifier: String!
    
    var pageIndex:Int!
    
    var label:UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.label)
        self.label.translatesAutoresizingMaskIntoConstraints = false
        let constraintX = NSLayoutConstraint.init(item: self.label, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0)
        let constraintY = NSLayoutConstraint.init(item: self.label, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0)
        
        self.view.addConstraints([constraintX, constraintY])
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setContent(){
        if pageIndex != nil{
            self.label.text = "\(pageIndex!)"
        }
    }
    
    required init!(reuseIdentifier identifier: String!) {
        super.init(nibName: nil, bundle: nil)
        self.reuseIdentifier = identifier
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        
        if parent == nil{
        //    print("removed from parent")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
      //  print("deinit")
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
