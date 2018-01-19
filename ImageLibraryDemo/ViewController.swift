//
//  ViewController.swift
//  ImageLibraryDemo
//
//  Created by Mayank on 1/14/18.
//  Copyright © 2018 Mayank. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var segmentPushPop: UISegmentedControl!
    
//    var library: ImageLibraryViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Private Methods
    
   

    //MARK:- Button Action
    
    

    @IBAction func tapShowImages(_ sender: Any)
    {
        let library = ImageLibraryViewController()
        library.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        
        library.arrayImages = [UIImage.init(named: "random.jpg")!,"https://i.ytimg.com/vi/PCwL3-hkKrg/maxresdefault.jpg",UIImage.init(named: "random.jpg")!]
        library.showBottomBar = true // optional bottom bar
        library.selectedIndex = 0 // to start the library from any particular index. Defaults to first image.
        self.present(library, animated: true) {
            
        }
    }
}

