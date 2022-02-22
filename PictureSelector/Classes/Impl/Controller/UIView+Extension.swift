//
//  UIView+Extension.swift
//  PictureSelector
//
//  Created by liugq on 2021/8/6.
//

import UIKit

extension UIView {
    // MARK: 坐标尺寸

    var origin: CGPoint {
        get {
            return frame.origin
        }
        set(newValue) {
            var rect = frame
            rect.origin = newValue
            frame = rect
        }
    }

    var size: CGSize {
        get {
            return frame.size
        }
        set(newValue) {
            var rect = frame
            rect.size = newValue
            frame = rect
        }
    }

    var left: CGFloat {
        get {
            return frame.origin.x
        }
        set(newValue) {
            var rect = frame
            rect.origin.x = newValue
            frame = rect
        }
    }

    var top: CGFloat {
        get {
            return frame.origin.y
        }
        set(newValue) {
            var rect = frame
            rect.origin.y = newValue
            frame = rect
        }
    }

    var right: CGFloat {
        get {
            return (frame.origin.x + frame.size.width)
        }
        set(newValue) {
            var rect = frame
            rect.origin.x = (newValue - frame.size.width)
            frame = rect
        }
    }

    var bottom: CGFloat {
        get {
            return (frame.origin.y + frame.size.height)
        }
        set(newValue) {
            var rect = frame
            rect.origin.y = (newValue - frame.size.height)
            frame = rect
        }
    }

    var width: CGFloat {
        return frame.size.width
    }

    var height: CGFloat {
        return frame.size.height
    }

    // MARK: - 位移

    // 移动到指定中心点位置
    func moveToPoint(point: CGPoint) {
        var center = self.center
        center.x = point.x
        center.y = point.y
        self.center = center
    }

    // 缩放到指定大小
    func scaleToSize(scale: CGFloat) {
        var rect = frame
        rect.size.width *= scale
        rect.size.height *= scale
        frame = rect
    }

    // MARK: - 毛玻璃效果

    // 毛玻璃
    func effectViewWithAlpha(alpha: CGFloat) {
        let effect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let effectView = UIVisualEffectView(effect: effect)
        effectView.frame = bounds
        effectView.alpha = alpha

        addSubview(effectView)
    }

    // MARK: - 边框属性

    // 圆角边框设置
    func layer(_ radius: CGFloat, borderWidth: CGFloat, borderColor: UIColor) {
        if radius > 0.0 {
            layer.cornerRadius = radius
            layer.masksToBounds = true
            clipsToBounds = true
        }

        if borderWidth > 0.0 {
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = borderWidth
        }
    }

    // MARK: - 翻转

    // 旋转 旋转180度 M_PI
    func viewTransformWithRotation(rotation: CGFloat) {
        transform = CGAffineTransform(rotationAngle: rotation)
    }

    // 缩放
    func viewScaleWithSize(size: CGFloat) {
        transform = transform.scaledBy(x: size, y: size)
    }

    // 水平，或垂直翻转
    func viewFlip(isHorizontal: Bool) {
        if isHorizontal {
            // 水平
            transform = transform.scaledBy(x: -1.0, y: 1.0)
        } else {
            // 垂直
            transform = transform.scaledBy(x: 1.0, y: -1.0)
        }
    }
}
