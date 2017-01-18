//
//  ViewController.swift
//  EzPaint
//
//  Created by iOS Student on 1/18/17.
//  Copyright © 2017 tek4fun. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UICollectionViewDataSource {
    @IBOutlet weak var mainView: UIImageView!
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var opacity: CGFloat = 1.0
    var swiped = false
    var baseImage = UIImage()
    var pixel: Int = 5

    let imgColors = ["black", "grey", "red", "blue", "lightblue", "darkgreen", "lightgreen", "brown", "darkorange", "yellow"]

    let colors: [(CGFloat, CGFloat, CGFloat)] = [
        (0, 0, 0),
        (105.0 / 255.0, 105.0 / 255.0, 105.0 / 255.0),
        (1.0, 0, 0),
        (0, 0, 1.0),
        (51.0 / 255.0, 204.0 / 255.0, 1.0),
        (102.0 / 255.0, 204.0 / 255.0, 0),
        (102.0 / 255.0, 1.0, 0),
        (160.0 / 255.0, 82.0 / 255.0, 45.0 / 255.0),
        (1.0, 102.0 / 255.0, 0),
        (1.0, 1.0, 0),
        (1.0, 1.0, 1.0),
        ]



    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func buttonClick(_ sender: AnyObject) {
        let index = sender.tag
        switch index! {
        case 0:
            pixel = 5
        case 1:
            pixel = 10
        case 2:
            pixel = 30
        case 3:
            (red,green,blue) = colors[10]
        default:
            break
        }
    }

    @IBAction func reset(_ sender: AnyObject) {
        mainView.image = baseImage
    }

    @IBAction func save(_ sender: AnyObject) {
        UIImageWriteToSavedPhotosAlbum(mainView.image!, self, nil, nil)
    }

    @IBAction func album(_ sender: AnyObject) {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imgPicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage:UIImage = (info[UIImagePickerControllerOriginalImage]) as? UIImage
        {
            baseImage = pickedImage
            mainView.image = baseImage
        }
        self.dismiss(animated: true, completion: nil)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touches = touches.first {
            lastPoint = touches.location(in: mainView)
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        if let touch = touches.first
        {
            let currentPoint = touch.location(in: mainView)
            drawLineFome(fromPoint: lastPoint, toPoint: currentPoint)
            lastPoint = currentPoint
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped
        {
            drawLineFome(fromPoint: lastPoint, toPoint: lastPoint)
        }
    }

    func drawLineFome(fromPoint: CGPoint, toPoint: CGPoint)
    {
        UIGraphicsBeginImageContext(mainView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        mainView.image?.draw(in: CGRect(x: 0, y: 0, width: mainView.frame.size.width, height: mainView.frame.size.height))

        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))

        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(CGFloat(pixel))
        context?.setStrokeColor(red: red, green: green, blue: blue, alpha: 1.0)
        context?.setBlendMode(CGBlendMode.normal)

        context?.strokePath()


        mainView.image = UIGraphicsGetImageFromCurrentImageContext()
        mainView.alpha = opacity
        UIGraphicsEndImageContext()

    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count - 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {


        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellColection", for: indexPath) as! CellCustomize
        cell.filteredImageView.image = UIImage(named: imgColors[indexPath.item])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        (red,green,blue) = colors[indexPath.item]
    }
    
}

