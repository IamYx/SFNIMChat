//
//  UIView+An.swift
//  NIMSDKSwift
//
//  Created by 姚肖 on 2025/3/17.
//

import UIKit

extension UIView {
    func addBreathAnimation() {
        self.layer.removeAnimation(forKey: "breathing")
        self.layer.add(makeBreathAnimation(), forKey: "breathing")
    }
    
    func delBreathAnimation() {
        self.layer.removeAnimation(forKey: "breathing")
    }
    
    private func makeBreathAnimation() -> CAAnimationGroup {
        let scaleAnim = CABasicAnimation(keyPath: "transform.scale")
        scaleAnim.fromValue = 0.95
        scaleAnim.toValue = 1.25
        
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation")
        rotationAnim.fromValue = CGFloat.pi/24
        rotationAnim.toValue = -CGFloat.pi/24
        
        let group = CAAnimationGroup()
        group.animations = [scaleAnim, rotationAnim]
        group.duration = 2
        group.autoreverses = true
        group.repeatCount = .infinity
        
        return group
    }
}
