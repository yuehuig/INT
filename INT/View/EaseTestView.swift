//
//  EaseTestView.swift
//  INT
//
//  Created by 郭月辉 on 2021/11/27.
//

import UIKit

class EaseTestView: UIView {
    
    private var clickAction: ((String?) -> Void)?
    var textF: UITextField!
    var btn: UIButton!
    
    private weak var target: NSObject?
    private var preFuncName: String?
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func btnClick(sender: UIButton) {
        if let target = target,
            let preFuncName = preFuncName {
            let sel = Selector("\(preFuncName)\(textF.text?.trimmed ?? "")")
            if (target.responds(to: sel)) {
                printLog("call func => [\(sel.description)]")
                target.perform(sel)
            }
        }
        clickAction?(textF.text?.trimmed)
    }
    
    @objc func showToView(_ superV: UIView, target: NSObject, preFuncName: String = "test", clickAction:((String?) -> Void)?) {
        superV.addSubview(self)
        self.size = CGSize(width: 300, height: 50)
        self.y = 100
        self.center.x = superV.center.x
        self.target =  target
        self.preFuncName = preFuncName
        self.clickAction = clickAction
    }
}

extension EaseTestView {
    private func setupUI() {
        backgroundColor = .cyan
        let tf = UITextField()
        tf.backgroundColor = .white
        tf.cornerRadius = 20
        textF = tf
        
        btn = UIButton(type: .custom)
        btn.backgroundColor = .white
        btn.setTitle("👌🏻", for: .normal)
        btn.cornerRadius = 20
        
        addSubview(textF)
        addSubview(btn)
        btn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textF.frame = CGRect(x: 10, y: 5, width: self.width - 10 * 3 - 60, height: self.height - 5 * 2)
        btn.frame = CGRect(x: textF.frame.maxX + 10, y: textF.frame.minY, width: 60, height: textF.height)
    }
}
