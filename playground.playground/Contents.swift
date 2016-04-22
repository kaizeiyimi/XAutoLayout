////: Playground - noun: a place where people can play
//
import UIKit
import XAutoLayout


let vc = UIViewController()

let view = vc.view
view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

view.backgroundColor = UIColor.purpleColor()
let v1 = UIView()
v1.backgroundColor = UIColor.orangeColor()
v1.frame = CGRect(x: 10, y: 5, width: 40, height: 40)
view.addSubview(v1)

let v2 = UIView(frame: CGRect(x: 10, y: 55, width: 40, height: 40))
v2.backgroundColor = UIColor.redColor()
view.addSubview(v2)

[v1, v2].forEach{$0.translatesAutoresizingMaskIntoConstraints = false}

//NSLayoutConstraint.activateConstraints( v1.xEdge =/ [10,5,-10,-20] )
xmakeConstraints(.LeftToRight) {
    v1.xEdge =/ [10,5,nil,-20]
    
//    v1.xHeight =/ 35.xc(10).xm(2)
//    NSLayoutConstraint(item: v1, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 2, constant: 35).active = true
    v1.xHeight.xEqual(70)
    
    v1.heightAnchor.constraintEqualToAnchor(v2.topAnchor)
    
    v2.xSize =/ [50, view.heightAnchor.xc(-50)]
    [v2.xTop, v2.xLeading] =/ [10, 20]
    
}

view
