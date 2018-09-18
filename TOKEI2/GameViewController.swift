//
//  GameViewController.swift
//  TOKEI2
//
//  Created by ただひろ on 2018/09/18.
//  Copyright © 2018年 Goemon. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    var scene: SCNScene!
    var fmtH: DateFormatter!
    var fmtM: DateFormatter!
    var fmtS: DateFormatter!
    var hariH: SCNNode!
    var hariM: SCNNode!
    var hariS: SCNNode!

    func makeTextH() -> SCNNode {
        let n = 12
        let node = SCNNode()
        for i in 0 ..< n {
            let text = SCNNode(geometry: SCNBox(width: 0.5, height: 0.10, length: 0.1, chamferRadius: 0))
            text.geometry?.firstMaterial?.diffuse.contents = UIColor.white
            let t = CGFloat.pi * 2 / CGFloat(n) * CGFloat(i)
            let x = cos(t) * 3.0
            let y = sin(t) * 3.0
            text.position = SCNVector3(x, y, 0)
            text.rotation = SCNVector4(0, 0, 1, t)
            node.addChildNode(text)
        }
        return node
    }
    
    func makeTextM() -> SCNNode {
        let n = 60
        let node = SCNNode()
        for i in 0 ..< n {
            let text = SCNNode(geometry: SCNBox(width: 0.5, height: 0.02, length: 0.1, chamferRadius: 0))
            text.geometry?.firstMaterial?.diffuse.contents = UIColor.white
            let t = CGFloat.pi * 2 / CGFloat(n) * CGFloat(i)
            let x = cos(t) * 3.0
            let y = sin(t) * 3.0
            text.position = SCNVector3(x, y, 0)
            text.rotation = SCNVector4(0, 0, 1, t)
            node.addChildNode(text)
        }
        return node
    }

    func makeTextF() -> SCNNode {
        let n = 12
        let node = SCNNode()
        for i in 0 ..< n {
            let text = SCNNode(geometry: SCNBox(width: 0.5, height: 0.10, length: 0.1, chamferRadius: 0))
            text.geometry?.firstMaterial?.diffuse.contents = UIColor.gray
            let t = CGFloat.pi * 2 / CGFloat(n) * CGFloat(i)
            let x = cos(t) * 4.3
            let y = sin(t) * 4.3
            text.position = SCNVector3(x, y, 0)
            text.rotation = SCNVector4(0, 0, 1, t)
            node.addChildNode(text)
        }
        return node
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        scene = SCNScene(named: "art.scnassets/tokei.scn")!
        let nodeTextM = makeTextM()
        let nodeTextH = makeTextH()
        let nodeTextF = makeTextF()

        nodeTextM.position = SCNVector3(0, 0, 0.1)
        nodeTextH.position = SCNVector3(0, 0, 0.2)
        nodeTextF.position = SCNVector3(0, 0, 1.6)
        scene.rootNode.addChildNode(nodeTextM)
        scene.rootNode.addChildNode(nodeTextH)
        scene.rootNode.addChildNode(nodeTextF)

        fmtH = DateFormatter()
        fmtM = DateFormatter()
        fmtS = DateFormatter()
        fmtH.dateFormat = "HH"
        fmtM.dateFormat = "mm"
        fmtS.dateFormat = "ss"
        
        hariM = scene.rootNode.childNode(withName: "HARI-M", recursively: true)
        hariH = scene.rootNode.childNode(withName: "HARI-H", recursively: true)
        hariS = scene.rootNode.childNode(withName: "HARI-S", recursively: true)

        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {
            _ in
            let t = Date()
            let strH = self.fmtH.string(from: t)
            let strM = self.fmtM.string(from: t)
            let strS = self.fmtS.string(from: t)
            let h = Int(strH)!
            let m = Int(strM)!
            let s = Int(strS)!
            self.hariH.rotation = SCNVector4(0, 0, 1, CGFloat.pi * 2 /  720 * -CGFloat(h * 60 + m))
            self.hariM.rotation = SCNVector4(0, 0, 1, CGFloat.pi * 2 / 3600 * -CGFloat(m * 60 + s))
            self.hariS.rotation = SCNVector4(0, 0, 1, CGFloat.pi * 2 / 60 * -CGFloat(s))
        })

        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 20)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
    }
}
