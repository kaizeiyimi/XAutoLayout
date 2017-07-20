////: Playground - noun: a place where people can play
//
import UIKit
import XAutoLayout


let vc = UIViewController()

let view = vc.view!
view.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

view.backgroundColor = UIColor.purple
let v1 = UIView()
v1.backgroundColor = UIColor.orange
v1.frame = CGRect(x: 10, y: 5, width: 40, height: 40)
view.addSubview(v1)

let v2 = UIView(frame: CGRect(x: 10, y: 55, width: 40, height: 40))
v2.backgroundColor = UIColor.red
view.addSubview(v2)

[v1, v2].forEach{$0.translatesAutoresizingMaskIntoConstraints = false}

//NSLayoutConstraint.activateConstraints( v1.xEdge =/ [10,5,-10,-20] )
//xmakeConstraints(direction: .leftToRight) {
//    v1.xEdge =/ [view.xTop,view.xLeading.xc(5),nil,-20]
//    v1.xHeight.xEqual(70)
//
////    v1.xHeight =/ 35.xm(2)
////    NSLayoutConstraint(item: v1, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 2, constant: 35).active = true
//
//    v2.xSize =/ [20, 20]
//    [v2.xTop, v2.xLeading] =/ [v1.xTop, v1.xLeading.xc(10)]
//
//}

view


(view.topAnchor =/ view.bottomAnchor).constant
(view.topAnchor =/ view.bottomAnchor.c(10)).constant
//view.topAnchor.c(10) =/ view.bottomAnchor

//[view.topAnchor, view.bottomAnchor] =/ [view.topAnchor, view.bottomAnchor]
//[view.topAnchor, view.bottomAnchor] =/ [view.topAnchor, nil]
//[view.topAnchor, view.bottomAnchor] =/ [nil, view.bottomAnchor.c(10)]
//[view.topAnchor, view.bottomAnchor] =/ [view.topAnchor, view.bottomAnchor.c(10)]

"xx"
