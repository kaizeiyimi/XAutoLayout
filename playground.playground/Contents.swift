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

view


(view.leadingAnchor =/ view.trailingAnchor).constant
(view.leadingAnchor =/ view.trailingAnchor.c(10)).constant
(view.leadingAnchor =/ view.trailingAnchor.c(10).p(999)).priority.rawValue


[view.topAnchor, view.bottomAnchor] =/ [view.topAnchor, view.bottomAnchor]
[view.topAnchor, view.bottomAnchor] =/ [view.topAnchor, nil]
[view.topAnchor, view.bottomAnchor] =/ [nil, view.bottomAnchor.c(10)]
[view.topAnchor, view.bottomAnchor] =/ [view.topAnchor, view.bottomAnchor.c(10)]
[view.topAnchor, view.bottomAnchor] =/ [view.topAnchor.c(10).p(750), view.bottomAnchor.c(10)]

view.widthAnchor =/ 10

"xx"
