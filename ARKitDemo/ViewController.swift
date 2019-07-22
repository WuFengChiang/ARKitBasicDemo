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
        hideBoxNode()
        self.arScnView.session.run(ARWorldTrackingConfiguration(), options: [.resetTracking])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.arScnView.session.pause()
    }
    
    // MARK: - IBAction functions
    
    @IBAction func tapGRAction(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.arScnView)
        guard let hitTestResult = self.arScnView.hitTest(location).first else {
            return
        }
        if didRemoveTouchedBoxNode(hitTestResult) { return }
        addNewBoxNode(hitTestResult)
    }
    
    // MARK: -
    
    private func didRemoveTouchedBoxNode(_ hitTestResult: SCNHitTestResult) -> Bool {
        let hitNode = hitTestResult.node
        if hitNode.name == "box" {            
            SCNTransaction.begin()
            hitNode.eulerAngles = SCNVector3Make(0, Float.pi*4, 0)
            hitNode.position = SCNVector3Make(hitNode.position.x, hitNode.position.y, hitNode.position.z - 1)
            hitNode.geometry?.firstMaterial?.diffuse.contents = UIColor.clear
            SCNTransaction.animationDuration = 1.0
            SCNTransaction.completionBlock = {
                hitNode.removeFromParentNode()
            }
            SCNTransaction.commit()
            
            return true
        }
        return false
    }
    
    fileprivate func addNewBoxNode(_ hitTestResult: SCNHitTestResult) {
        let aBoxNode = getBoxUnsharedClone()
        aBoxNode?.isHidden = false
        aBoxNode?.position = hitTestResult.localCoordinates
        self.arScnView.scene.rootNode.addChildNode(aBoxNode!)
    }
    
    private func hideBoxNode() {
        findBoxNode()?.isHidden = true
    }
    
    private func getBoxUnsharedClone() -> SCNNode? {
        let boxNode = findBoxNode()
        let newBoxNode = boxNode?.clone()
        newBoxNode?.geometry = boxNode?.geometry?.copy() as? SCNGeometry
        newBoxNode?.geometry?.materials = [boxNode?.geometry?.materials.first?.copy() as? SCNMaterial] as! [SCNMaterial]
        return newBoxNode
    }
    
    fileprivate func findBoxNode() -> SCNNode? {
        for childNode in self.arScnView.scene.rootNode.childNodes {
            if let nodeName = childNode.name, nodeName == "box" {
                return childNode
            }
        }
        return nil
    }
    
    fileprivate func setupArScnView() {
        arScnView.debugOptions = [.showWorldOrigin, .showFeaturePoints]
        arScnView.showsStatistics = true
    }
    
    fileprivate func setupScene() {
        arScnView.scene = SCNScene(named: "Scenes.scnassets/scene1.scn")!
    }
}

