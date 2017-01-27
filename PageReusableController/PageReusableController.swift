//
//  ViewController.swift
//  PageReusableController
//
//  Created by Arjun P A on 26/01/17.
//  Copyright © 2017 Arjun P A. All rights reserved.
//

import UIKit

protocol PageReusableControllerDelegate:class {
    func loadDataAtIndex(index:Int)
    func getControllerForReuse(controller:PageReusableController) -> UIViewController
}

class PageReusableController: UIViewController, UIScrollViewDelegate, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    fileprivate var pageController:UIPageViewController
    fileprivate var pageContainer:UIView!
    fileprivate var isFirstLayoutComplete:Bool = false
    fileprivate weak var scrollView:UIScrollView!
    fileprivate var cachedControllers:Array<UIViewController> = []
    let MAX_REUSE_COUNT:Int = 2
    var delegate:PageReusableControllerDelegate?
    var dataCount:Int
    var startAt:Int
    var nextIndex:Int = 0
    var currentIndex:Int = 0
    
    
    fileprivate var shouldLoadMoreControllers:Bool{
        get{
            return cachedControllers.count == MAX_REUSE_COUNT
        }
    }
    override func loadView() {
        //lets start from loadview
        let viewd = UIView.init(frame: UIScreen.main.bounds)
        self.view = viewd
        self.edgesForExtendedLayout = []
        self.setupPageContainer()
    }
    fileprivate func setupPageContainer(){
        self.pageContainer = UIView.init()
        self.pageContainer.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pageContainer)
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[container]-(0)-|", options: [], metrics: nil, views: ["container":self.pageContainer])
        self.view.addConstraints(constraints)
        let topConstraint = NSLayoutConstraint.init(item: self.pageContainer, attribute: .top, relatedBy: .equal, toItem: self.topLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: 0)
        let bottomConstraint = NSLayoutConstraint.init(item: self.pageContainer, attribute: .bottom, relatedBy: .equal, toItem: self.bottomLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0)
        self.view.addConstraints([topConstraint,bottomConstraint])
    }
    
    convenience init(count:Int, startAt:Int, delegate:PageReusableControllerDelegate){
        
        self.init(nibName:nil, bundle:nil)
        self.dataCount = count
        self.startAt = startAt
        self.delegate = delegate
    }
    
    override required init(nibName nibNameOrNil: String?, bundle nibBundledatOrNil: Bundle?) {
        self.dataCount = 0
        self.startAt = 0
        self.pageController = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        super.init(nibName: nibNameOrNil, bundle: nibBundledatOrNil)
        self.pageController.dataSource = self
        self.pageController.delegate = self
        getScrollView()
    }
    
    func getScrollView(){
        for subView in self.pageController.view.subviews{
            if let view = subView as? UIScrollView{
                self.scrollView = view
                view.delegate = self
                break
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
  /*  required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !isFirstLayoutComplete{
        
            isFirstLayoutComplete = true
            if let controllerToUse = self.delegate?.getControllerForReuse(controller: self) as? PageContentController{
             //   self.cachedControllers.append(controllerToUse)
                if controllerToUse.pageIndex == nil{
                    controllerToUse.pageIndex = 0
                }
                self.setupPaging(controller: controllerToUse)
            }
        }
    }

    func setupPaging(controller:UIViewController){
        self.addChildViewController(pageController)
        self.pageController.view.frame = pageContainer.bounds
        self.pageContainer.addSubview(pageController.view)
        self.pageController.didMove(toParentViewController: self)
        self.pageController.setViewControllers([controller], direction: .forward, animated: true) { (flag) in
           // controller.view.backgroundColor = UIColor.blue
            let controllerd = controller as! PageContentController
            controllerd.setContent()
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        if let pendingController = pendingViewControllers.last as? PageContentController{
            
            print(pendingController.pageIndex)
            
            self.nextIndex = pendingController.pageIndex
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let _ = previousViewControllers.last as? PageContentController{
            if completed{
                self.currentIndex = self.nextIndex
                print(self.currentIndex)
             //  visibleController.setContent()
            }
            else{
                self.nextIndex = self.currentIndex
                print(self.currentIndex)
            }
            
            
            
        }
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
   
        
        
        if let controllerToUse = self.delegate?.getControllerForReuse(controller: self) as? PageContentController{
            
            let viewController = viewController as! PageContentController

            let prevIndex = viewController.pageIndex - 1
            
                if prevIndex == -1{
                    return nil
                }
                else{
                    controllerToUse.pageIndex = prevIndex
                }
            controllerToUse.setContent()
            return controllerToUse
        }
       
        return nil
      }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let controllerToUse = self.delegate?.getControllerForReuse(controller: self) as? PageContentController{
            
            let viewController = viewController as! PageContentController
            
            if viewController.pageIndex == nil || viewController.pageIndex == self.dataCount{
                return nil
            }
  
              let nextIndex = viewController.pageIndex + 1
            
              controllerToUse.pageIndex = nextIndex

            controllerToUse.setContent()
            return controllerToUse
        }
       
        return nil
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        // Dispose of any resources that can be recreated.
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       // print(scrollView.contentOffset)
      //  print("percentage \(scrollView.contentOffset.x/scrollView.contentSize.width)")
    }
    
    
}

