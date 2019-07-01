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
        for item in 1...12 {
            viewControllers.append(CalendarViewController.make(inputIndex: item))
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
        let scene = SCNScene(named: "dodecahedron.scnassets/Dodecahedron4.scn")!
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
  
        for item in 0...11 {
            let material = SCNMaterial()
            material.diffuse.contents = UIImage(view: calendarViewControllers[item].view)
            dodecahedronNode.childNodes[item].geometry?.firstMaterial = material
        }
        
        //7. Add To The Scene & Position It
        sceneView.scene.rootNode.addChildNode(dodecahedronNode)
        dodecahedronNode.position = vector
        return dodecahedronNode
    }
    
    func addRotationGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        self.view.addGestureRecognizer(panGesture)
        

    }
    
    //gesture code based of off https://github.com/anoop4real/AR-RotateEarthWithGesture
    @objc func handleGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!)
        
        let x = Float(translation.y)
        let y = Float(-translation.x)
        let anglePan = (sqrt(pow(x,2)+pow(y,2)))*(Float)(Double.pi)/180.0
        
        var rotationVector = SCNVector4()
        rotationVector.x = x
        rotationVector.y = y
        rotationVector.z = 0.0
        rotationVector.w = anglePan
        
        
        self.dodecaNode.rotation = rotationVector
    }
    
}


extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
}
