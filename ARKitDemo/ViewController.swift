//
//  ViewController.swift
//  ARKitDemo
//
//  Created by wuufone on 2019/7/21.
//  Copyright © 2019 江武峯. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {

    @IBOutlet weak var arScnView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupArScnView()
        setupScene()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.arScnView.session.run(ARWorldTrackingConfiguration(), options: [.resetTracking])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.arScnView.session.pause()
    }
    
    // MARK: -
    
    fileprivate func setupArScnView() {
        arScnView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
        arScnView.showsStatistics = true
    }
    
    fileprivate func setupScene() {
        arScnView.scene = SCNScene(named: "Scenes.scnassets/scene1.scn")!
    }
}

