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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        createUIViewOnNode()
        // Create a new scene
        //let scene = SCNScene(named: "dodecahedron.scnassets/dodecahedron.scn")!
        
        // Set the scene to the view
       // sceneView.scene = scene
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

    func shapeNode() {
        let scene = SCNScene(named: "dodecahedron.scnassets/dodecahedron.scn")!
        let node = scene.rootNode.childNode(withName: "dodecahedron", recursively: true)
        
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
        
        let shape = SCNShape(path: path, extrusionDepth: 0.2) //20 cm
        let color = UIColor.red
        shape.firstMaterial?.diffuse.contents = color
        shape.chamferRadius = 0.1
        //create a node
        let pentagonNode = SCNNode(geometry: shape)
        //position the node and add to the scene
        pentagonNode.position.z = -1
        return pentagonNode
    }
    
    //Test UI paste on top of node
    func createUIViewOnNode(){
        
        //1. Create An Empty Node
        let holderNode = createPentagon()
        
        
        //2. Create A New Material
        let material = SCNMaterial()
        
        //3. Create A UIView As A Holder For Content
        let viewToAdd = CalendarView(frame: CGRect(x: 100, y: 100, width: 500, height: 500))
        
        //5. Set The Materials Contents
        material.diffuse.contents = viewToAdd
        
        //6. Set The 1st Material Of The Plane
        holderNode.geometry?.firstMaterial = material
        material.isDoubleSided = true
        //holderNode.addChildNode(node)
        
        //7. Add To The Scene & Position It
        sceneView.scene.rootNode.addChildNode(holderNode)
        
        holderNode.position = SCNVector3(0, 0, -1.0)
    }
    
}
