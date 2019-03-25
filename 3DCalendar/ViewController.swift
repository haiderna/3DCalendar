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
    
    let viewToAdd = CalendarViewController()
    let colors = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.blue, UIColor.purple, UIColor.magenta, UIColor.cyan, UIColor.black, UIColor.gray, UIColor.lightGray, UIColor.darkGray]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        createUIViewOnNode(vector: SCNVector3(x: 0, y: -0.1, z: -0.1))

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
        node?.scale = SCNVector3(0.2, 0.2, 0.2)
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
        var plane = SCNPlane(width: 0.1, height: 0.1)
        plane.firstMaterial?.diffuse.contents = viewToAdd.view
        let planeNode = SCNNode(geometry: plane)
        planeNode.position.z = -1.0
        return planeNode
    }
    
    func createCub() -> SCNNode {
        var cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 1.0)
        let cubeNode = SCNNode(geometry: cube)
        cubeNode.position.z = -1.0
        return cubeNode
    }
    
    //Test UI paste on top of node
    func createUIViewOnNode(vector: SCNVector3){
        
        //1. Create An Empty Node
        let holderNode = shapeNode()
        var planeNode = createPlane()
        holderNode.position.y = -10.0
        //2. Create A New Material
        let material = SCNMaterial()
        let viewMaterial = SCNMaterial()
        var material3 = SCNMaterial()
        
        //3. Create A UIView As A Holder For Content
       
        let label = UILabel(frame: CGRect(x: 250, y: 0, width: 500, height: 250))
        label.text = "2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26"
        label.textColor = UIColor.red
        label.backgroundColor = UIColor.purple
        
        var image = UIImage(named: "close")
        
        //5. Set The Materials Contents
        //viewMaterial.diffuse.contents = view
        material.diffuse.contents = viewMaterial
        var material2 = SCNMaterial()
        material2.diffuse.contents = UIColor.green
        material3.diffuse.contents = UIColor.purple
        
        //planeNode.geometry?.firstMaterial?.diffuse.contents = viewToAdd.view
        holderNode.childNodes[10].geometry?.firstMaterial?.diffuse.contents = viewToAdd.view
       // holderNode.childNodes[0].geometry?.firstMaterial?.diffuse.wrapS = SCNWrapMode.clampToBorder
        //6. Set The 1st Material Of The Plane
//        holderNode.geometry?.firstMaterial = material2
//        holderNode.geometry?.firstMaterial?.diffuse.wrapS = SCNWrapMode.repeat
//        holderNode.geometry?.firstMaterial?.diffuse.wrapT = SCNWrapMode.repeat
//        holderNode.childNodes[11].geometry?.firstMaterial?.diffuse.contents = material
//        holderNode.childNodes[11].name = "mysteryNode"
//        holderNode.childNodes[0].geometry?.firstMaterial?.diffuse.contents = image
//        holderNode.childNodes[0].geometry?.firstMaterial?.diffuse.mipFilter = .linear
//
        holderNode.childNodes[0].geometry?.firstMaterial = material2
//        holderNode.childNodes[2].geometry?.firstMaterial = material
//        holderNode.childNodes[2].geometry?.firstMaterial = material
//        holderNode.childNodes[3].geometry?.firstMaterial = material2
//        holderNode.childNodes[4].geometry?.firstMaterial = material
//        holderNode.childNodes[5].geometry?.firstMaterial = material2
//        holderNode.childNodes[6].geometry?.firstMaterial = material
        
        //material.isDoubleSided = true
        //holderNode.addChildNode(node)
        
        //7. Add To The Scene & Position It
        sceneView.scene.rootNode.addChildNode(holderNode)
        
        holderNode.position = vector
    }
    
}
