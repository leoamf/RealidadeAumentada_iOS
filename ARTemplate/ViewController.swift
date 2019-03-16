//
//  ViewController.swift
//  ARTemplate
//
//  Created by aluno on 15/03/19.
//  Copyright © 2019 Anderson. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var plane : SCNPlane?
    let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01 )
    let sphere = SCNPyramid(width: 0.1, height: 0.1, length: 0.1  )
    let node = SCNNode()
    let resposta = SCNText(string: "", extrusionDepth: CGFloat(0.01))
    let planeNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.debugOptions = SCNDebugOptions.showFeaturePoints
        
        /*// Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        
        // Set the scene to the view
        sceneView.scene = scene*/
        //createCube( )

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
         let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    private func createOrange(vector: SCNVector3 ){
        let scene = SCNScene(named: "art.scnassets/Earth.dae")!
        if let orangeNode = scene.rootNode.childNode(withName: "Earth", recursively: true){
            orangeNode.position = vector
            sceneView.scene.rootNode.addChildNode(orangeNode)
             orangeNode.runAction(SCNAction.move(by: SCNVector3(0, 0.2, 0), duration: 5))
                
            
             orangeNode.runAction(
                SCNAction.repeatForever(
                    SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi * 2), z: 0, duration:10 ))
                )
            let sunNode = SCNNode()
            
            
            sunNode.position = SCNVector3(vector.x, vector.y, vector.z - 1 )
            sunNode.runAction(SCNAction.repeatForever(
                SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi * 2), z: 0, duration:10 ))
            )
        }
    }
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let anchor = anchor as? ARPlaneAnchor  {
            if (plane == nil){
              createPlane(node: node, anchor: anchor)
              createShapes(vector : planeNode.position)
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            
            let touchLocation = touch.location(in: sceneView)
            
            let results = sceneView.hitTest(touchLocation, types: ARHitTestResult.ResultType.existingPlaneUsingExtent)
            if let hitResult = results.first {
                //print(hitResult)
                _ = SCNVector3(
                    hitResult.worldTransform.columns.3.x,
                    hitResult.worldTransform.columns.3.y + 0.1,
                    hitResult.worldTransform.columns.3.z)
                //createOrange(vector: vector)
                let material = SCNMaterial()
                material.diffuse.contents = UIColor.green
                cube.materials = [material]
            }
            
            let hits = self.sceneView.hitTest(touchLocation, options: nil)
            if let tappednode = hits.first?.node {
                if tappednode == node {
                    let material = SCNMaterial()
                    material.diffuse.contents = UIColor.green
                    cube.materials = [material]
                    sphere.materials = [material]
                    resposta.string = "Correto"
                }
                else
                {
                    let material = SCNMaterial()
                    material.diffuse.contents = UIColor.red
                    sphere.materials = [material]
                    cube.materials = [material]
                    resposta.string = "Errrouuuu"
                }
                
            }
            
           
        }
    }
    
   
    
    
    private func createPlane(node: SCNNode, anchor:ARPlaneAnchor){
        plane = SCNPlane(width: CGFloat(anchor.extent.x), height: CGFloat(anchor.extent.z))
        planeNode.position = SCNVector3(anchor.center.x, 0, anchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.clear
        plane!.materials = [material]
        planeNode.geometry = plane
        node.addChildNode(planeNode)
        
        let alert = UIAlertController(title: "Carregado", message: "Procure a pergunta!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
     }
    
    private func createShapes(vector: SCNVector3){
        
        
        //START
        /*let start = SCNText(string: "Procure...", extrusionDepth: CGFloat(0.01))
        let fontStart = UIFont(name: "Futura", size: 0.08)
         start.font = fontStart
        start.alignmentMode = CATextLayerAlignmentMode.center.rawValue
        start.firstMaterial?.diffuse.contents = UIColor.yellow
        start.firstMaterial?.specular.contents = UIColor.white
        start.firstMaterial?.isDoubleSided = true
        let startNode = SCNNode(geometry: start)
        startNode.position = SCNVector3(vector.x + -0.1 , vector.y +  -1.2 , vector.z + -0.25)
        sceneView.scene.rootNode.addChildNode(startNode)*/
        
        //Pergunta
        let pergunta = SCNText(string: "Qual desses objetos tem 6 lados?", extrusionDepth: CGFloat(0.01))
        var font = UIFont(name: "Futura", size: 0.08)
        font = font?.withTraits(traits: .traitBold)

         pergunta.font = font
        pergunta.alignmentMode = CATextLayerAlignmentMode.center.rawValue
        pergunta.firstMaterial?.diffuse.contents = UIColor.orange
        pergunta.firstMaterial?.specular.contents = UIColor.white
        pergunta.firstMaterial?.isDoubleSided = true
        let perguntaNode = SCNNode(geometry: pergunta)
        perguntaNode.position = SCNVector3(vector.x + -0.25, vector.y + -0.9, vector.z + -1.5)
        sceneView.scene.rootNode.addChildNode(perguntaNode)
 
        
        //CUBO
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.blue
        cube.materials = [material]
        
        node.geometry = cube
        node.position = SCNVector3(vector.x + 0, vector.y + 0, vector.z + -1.5)
        sceneView.scene.rootNode.addChildNode(node)
        
        let text = SCNText(string: "CUBO", extrusionDepth: CGFloat(0.01))
         text.font = font
        text.alignmentMode = CATextLayerAlignmentMode.center.rawValue
        text.firstMaterial?.diffuse.contents = UIColor.orange
        text.firstMaterial?.specular.contents = UIColor.white
        text.firstMaterial?.isDoubleSided = true
        let textNode = SCNNode(geometry: text)
        textNode.position = SCNVector3(vector.x + -0.12, vector.y + -1.15, vector.z + -1.5)
        sceneView.scene.rootNode.addChildNode(textNode)

        
        //Piramide
        let materialSphere = SCNMaterial()
        materialSphere.diffuse.contents = UIColor.yellow
        sphere.materials = [materialSphere]
        let nodeSphere = SCNNode()
        nodeSphere.position = SCNVector3(vector.x + 0.5, vector.y + 0, vector.z + -1.5)
        nodeSphere.geometry = sphere
        sceneView.scene.rootNode.addChildNode(nodeSphere)
        
        let textPiramide = SCNText(string: "Pirâmide", extrusionDepth: CGFloat(0.01))
        textPiramide.font = font
        textPiramide.alignmentMode = CATextLayerAlignmentMode.center.rawValue
        textPiramide.firstMaterial?.diffuse.contents = UIColor.orange
        textPiramide.firstMaterial?.specular.contents = UIColor.white
        textPiramide.firstMaterial?.isDoubleSided = true
        let nodeTextPiramide = SCNNode(geometry: textPiramide)
        nodeTextPiramide.position = SCNVector3(vector.x + 0.29, vector.y + -1.15, vector.z + -1.5)
        sceneView.scene.rootNode.addChildNode(nodeTextPiramide)
        
        
        resposta.string = ""
        resposta.font = font
        resposta.alignmentMode = CATextLayerAlignmentMode.center.rawValue
        resposta.firstMaterial?.diffuse.contents = UIColor.orange
        resposta.firstMaterial?.specular.contents = UIColor.white
        resposta.firstMaterial?.isDoubleSided = true
        let respostaNode = SCNNode(geometry: resposta)
        respostaNode.position = SCNVector3(vector.x + 0.05, vector.y + -1.30, vector.z + -1.5)
        sceneView.scene.rootNode.addChildNode(respostaNode)
        
        
        node.runAction(
            SCNAction.repeatForever(
                SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi * 2), z: 0, duration:10 ))
        )
        
        nodeSphere.runAction(
            SCNAction.repeatForever(
                SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi * 2), z: 0, duration:10 ))
        )
        
        
        
        
        
        // sombra
        sceneView.autoenablesDefaultLighting = true;
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
}

extension UIFont {
    
    // Based on: https://stackoverflow.com/questions/4713236/how-do-i-set-bold-and-italic-on-uilabel-of-iphone-ipad
    
    func withTraits(traits:UIFontDescriptor.SymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
}
