//
//  ViewController.swift
//  3DCalendar
//
//  Created by Najia Haider on 2/13/19.
//  Copyright © 2019 Najia Haider. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    let viewToAdd = CalendarView(frame: CGRect(x: 100, y: 100, width: 500, height: 550))
    let videoView = VideoTester(frame: CGRect(x: 200, y: 200, width: 1000, height: 1000))
    let colors = [UIColor.red, UIColor.blue, UIColor.green, UIColor.purple, UIColor.orange, UIColor.yellow, UIColor.magenta, UIColor.gray, UIColor.black]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        createUIViewOnNode(vector: SCNVector3(x: 0, y: -0.6, z: -0.1))

        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    func shapeNode() -> SCNNode {
        let scene = SCNScene(named: "dodecahedron.scnassets/dodecahedron.scn")!
        let node = scene.rootNode.childNode(withName: "dodecahedron", recursively: true)
        node?.scale = SCNVector3(0.1, 0.1, 0.1)
        return node!
    }
    
    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    //pentagon via Bezier Path
    func createPentagon() -> SCNNode {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.0, y: 0.6)) //A
        path.addLine(to: CGPoint(x: -0.3, y: 0.4))//B
        path.addLine(to: CGPoint(x: -0.2, y: 0.1))//C
        path.addLine(to: CGPoint(x: 0.2, y: 0.1))//D
        path.addLine(to: CGPoint(x: 0.3, y: 0.4))//E
        path.close()
        
        let shape = SCNShape(path: path, extrusionDepth: 0.05) //20 cm
        let color = UIColor.red
        shape.firstMaterial?.diffuse.contents = color
        shape.chamferRadius = 0.0
        //create a node
        let pentagonNode = SCNNode(geometry: shape)
        //position the node and add to the scene
        pentagonNode.position.z = -1
        return pentagonNode
    }
    
    func createPlane() -> SCNNode {
        var plane = SCNPlane(width: 0.3, height: 0.3)
        plane.firstMaterial?.diffuse.contents = UIColor.red
        let planeNode = SCNNode(geometry: plane)
        planeNode.position.z = -0.5
        return planeNode
    }
    
    //Test UI paste on top of node
    func createUIViewOnNode(vector: SCNVector3){
        
        //1. Create An Empty Node
        let holderNode = shapeNode()
        
        
        //2. Create A New Material
        let material = SCNMaterial()
        let viewMaterial = SCNMaterial()
        let videoMaterial = SCNMaterial()
        
        //3. Create A UIView As A Holder For Content
       
        //5. Set The Materials Contents
        viewMaterial.diffuse.contents = viewToAdd
        material.diffuse.contents = UIColor.red
        
        let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        let player = AVPlayer(url: videoURL!)
        player.play()
    

        videoMaterial.diffuse.contents = player
        
        //6. Set The 1st Material Of The Plane
        holderNode.geometry?.firstMaterial = material
        holderNode.childNodes[0].geometry?.firstMaterial = videoMaterial
        holderNode.childNodes[1].geometry?.firstMaterial = viewMaterial
        holderNode.childNodes[2].geometry?.firstMaterial = material
        holderNode.childNodes[3].geometry?.firstMaterial = material
        holderNode.childNodes[10].geometry?.firstMaterial = material
        //material.isDoubleSided = true
        //holderNode.addChildNode(node)
        
        //7. Add To The Scene & Position It
        sceneView.scene.rootNode.addChildNode(holderNode)
        
        holderNode.position = vector
    }
    
}
