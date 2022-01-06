//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

//        let label = UILabel()
//        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
//        label.text = "Hello World!"
//        label.textColor = .black
//
//        view.addSubview(label)
        
        let blueV = UIView(frame: CGRect(x: 100, y: 100, width: 200, height: 200))
        blueV.backgroundColor = .blue
        view.addSubview(blueV)
        
        let yellowV = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        yellowV.backgroundColor = .yellow
        blueV.addSubview(yellowV)
        
        let redV = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        redV.backgroundColor = .red
        yellowV.addSubview(redV)
        
        /// 1.放大缩小view的bounds view的中心点不变 放大缩小view的宽高
        /// 2.其frame也会相应变化 从(0, 0, 150, 150) -> (25.0, 25.0, 100.0, 100.0)
        /// 3.子view(redview)相对于自身的位置和大小是不变的
        yellowV.bounds.size = CGSize(width: 100, height: 100)
        printLog(yellowV.bounds)
        printLog(yellowV.frame)

        /// 改变bounds的origin 相当于更改自己内部的坐标系统
        yellowV.bounds.origin = CGPoint(x: 20, y: 20)
        printLog("修改完bounds origin")
        printLog(yellowV.bounds)
        printLog(yellowV.frame)
        
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
