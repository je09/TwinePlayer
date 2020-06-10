//
//  InfoViewController.swift
//  Twine Player
//
//  Created by je09 on 10.06.2020.
//  Copyright © 2020 Petr Grakunov. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {
      override func viewDidLoad() {
        super.viewDidLoad()
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .allButUpsideDown
    }
}
