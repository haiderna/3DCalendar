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
    
    let colors = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.blue, UIColor.purple, UIColor.magenta, UIColor.cyan, UIColor.black, UIColor.gray, UIColor.orange, UIColor.white]


    let calendarViewControllers: [UIViewController] = {
        var viewControllers = [UIViewController]()
        for item in 0...11 {
            viewControllers.append(CalendarViewController())
        }
        return viewControllers
    }()

    var materials = [SCNMaterial]()
    var dodecaNode = SCNNode()
    
    //Gestures
    //Store The Rotation Of The CurrentNode
    var currentAngleY: Float = 0.0
    //Not Really Necessary But Can Use If You Like
    var isRotating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        dodecaNode = createUIViewOnNode(vector: SCNVector3(x: 0, y: -0.1, z: -0.1))
        addRotationGesture()

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

    func createUIViewOnNode(vector: SCNVector3) -> SCNNode {
        let dodecahedronNode = shapeNode()
        dodecahedronNode.position.y = -10.0

//        zip(dodecahedronNode.childNodes, calendarViewControllers).forEach { (node, calendarViewController) in
            let material = SCNMaterial()
            material.diffuse.contents = calendarViewControllers.first!.view
            materials.append(material)
            dodecahedronNode.childNodes.first?.geometry?.firstMaterial = material
//        }

        
        //7. Add To The Scene & Position It
        sceneView.scene.rootNode.addChildNode(dodecahedronNode)
        
        dodecahedronNode.position = vector
        return dodecahedronNode
    }
    
    func addRotationGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(moveNode(_:)))
        self.view.addGestureRecognizer(panGesture)
        
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotateNode(_:)))
        self.view.addGestureRecognizer(rotateGesture)
    }
    
    @objc func moveNode(_ gesture: UIPanGestureRecognizer) {
        
        if !isRotating{
            
            //1. Get The Current Touch Point
            let currentTouchPoint = gesture.location(in: self.sceneView)
            
            //2. Get The Next Feature Point Etc
            guard let hitTest = self.sceneView.hitTest(currentTouchPoint, types: .existingPlane).first else { return }
            
            //3. Convert To World Coordinates
            let worldTransform = hitTest.worldTransform
            
            //4. Set The New Position
            let newPosition = SCNVector3(worldTransform.columns.3.x, worldTransform.columns.3.y, worldTransform.columns.3.z)
            
            //5. Apply To The Node
            dodecaNode.simdPosition = float3(newPosition.x, newPosition.y, newPosition.z)
            
        }
    }
    
    @objc func rotateNode(_ gesture: UIRotationGestureRecognizer){
        
        //1. Get The Current Rotation From The Gesture
        let rotation = Float(gesture.rotation)
        
        //2. If The Gesture State Has Changed Set The Nodes EulerAngles.y
        if gesture.state == .changed{
            isRotating = true
            dodecaNode.eulerAngles.y = currentAngleY + rotation
        }
        
        //3. If The Gesture Has Ended Store The Last Angle Of The Cube
        if(gesture.state == .ended) {
            currentAngleY = dodecaNode.eulerAngles.y
            isRotating = false
        }
    }
    
}


class TestViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .green
        view.frame = .init(x: 0, y: 0, width: 500, height: 500)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.backgroundColor = UIColor.orange.cgColor
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
