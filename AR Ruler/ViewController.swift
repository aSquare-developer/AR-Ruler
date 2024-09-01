//
//  ViewController.swift
//  AR Ruler
//
//  Created by Artur Anissimov on 31.08.2024.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var dotNodes = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touchLocation = touches.first?.location(in: sceneView) {
            guard let query = sceneView.raycastQuery(from: touchLocation, allowing: .estimatedPlane, alignment: .any) else { return }
            
            let hitResults = sceneView.session.raycast(query)
            
            if let hitResult = hitResults.first {
                addDot(at: hitResult)
            }
        }
        
        
        
    }
    
    func addDot(at hitResult: ARRaycastResult) {
        // Create Sphere
        let dotGeometry = SCNSphere(radius: 0.005)
        
        // Create Material for our Sphere
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        
        // Add our created material into our Sphere
        dotGeometry.materials = [material]
        
        // Create object from our sphere
        let node = SCNNode(geometry: dotGeometry)
        
        // Get the position of our object
        node.position = SCNVector3(
            x: hitResult.worldTransform.columns.3.x,
            y: hitResult.worldTransform.columns.3.y,
            z: hitResult.worldTransform.columns.3.z
        )
        
        // Add to our scene
        sceneView.scene.rootNode.addChildNode(node)
        
        dotNodes.append(node)
        
        if dotNodes.count >= 2 {
            calculate()
        }
        
    }
    
    func calculate() {
        guard let start = dotNodes.first else { return }
        guard let end = dotNodes.last else { return }
        
        print("Start: \(start.position) / End: \(end.position)")
        
        let a = end.position.x - start.position.x
        let b = end.position.y - start.position.y
        let c = end.position.z - start.position.z
        
        let distance = sqrt(pow(a, 2) + pow(b, 2) + pow(c, 2))
        
        print(abs(distance))
    }

}
