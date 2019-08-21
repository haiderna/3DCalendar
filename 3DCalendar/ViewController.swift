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
    
    var materials = [SCNMaterial]()
    var dodecaNode = SCNNode()
    var currentAngleY: Float = 0.0
    var isRotating = false
    
    let calendarViewControllers: [UIViewController] = {
        let components = Calendar.current.dateComponents(in: .current, from: Date())
        let range = Calendar.current.range(of: .month, in: .year, for: Date())!
        
        let months = range.compactMap {
            DateComponents(calendar: components.calendar,
                           timeZone: components.timeZone,
                           year: components.year,
                           month: $0,
                           day: 1).date
        }
        return months.map { CalendarViewController.make(date: $0) }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        dodecaNode = setShapeAndSceneOfNode()
        putMonthViewsOnChildNodes(dodecahedronNode: dodecaNode, vector: SCNVector3(x: 0, y: -0.1, z: -0.1))
        
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

    func setShapeAndSceneOfNode() -> SCNNode {
        guard let scene = SCNScene(named: "dodecahedron.scnassets/Dodecahedron4.scn"),
            let node = scene.rootNode.childNode(withName: "dodecahedron", recursively: true) else {
                fatalError("Unable to load node")
        }
        
        node.scale = SCNVector3(0.1, 0.1, 0.1)
        return node
    }
    
    func putMonthViewsOnChildNodes(dodecahedronNode: SCNNode, vector: SCNVector3) {
        dodecahedronNode.position.y = -10.0
  
        for item in 0...calendarViewControllers.count - 1 {
            let material = SCNMaterial()
            material.diffuse.contents = calendarViewControllers[item].view
            dodecahedronNode.childNodes[item].geometry?.firstMaterial = material
        }
    
        sceneView.scene.rootNode.addChildNode(dodecahedronNode)
        dodecahedronNode.position = vector
    }
    
    func addRotationGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        self.view.addGestureRecognizer(panGesture)
        let rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(rotateNode(_:)))
        self.view.addGestureRecognizer(rotateGesture)
    }
    
    // rotation gesture code from https://stackoverflow.com/questions/49473739/ios-arkit-how-to-create-rotate-object-gesture-function/49475626
    @objc func rotateNode(_ gesture: UIRotationGestureRecognizer){
        
        let rotation = Float(gesture.rotation)
        
        if gesture.state == .changed{
            isRotating = true
            dodecaNode.eulerAngles.y = currentAngleY + rotation
        }
        
        if(gesture.state == .ended) {
            currentAngleY = dodecaNode.eulerAngles.y
            isRotating = false
        }
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
