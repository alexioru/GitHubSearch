//
//  UISegmentedControl.swift
//  GitHubSearch
//
//  Created by Alexey Rodionov on 10/10/18.
//  Copyright © 2018 Alexey Rodionov. All rights reserved.
//

import Foundation
import UIKit

extension UISegmentedControl {
    func setSegmentStyle() {
        let height = self.bounds.height
        let wight = self.bounds.width / CGFloat(self.numberOfSegments)
        let clearImage = imageWithColor(UIColor.clear, width: wight, height: height)
        
        setBackgroundImage(clearImage, for: .normal, barMetrics: .default)
        setBackgroundImage(clearImage, for: .selected, barMetrics: .default)
        setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        let normalAttributes = [NSAttributedString.Key.font: Fonts.smallFont, NSAttributedString.Key.foregroundColor: Colors.gray]
        let selectedAttributes = [NSAttributedString.Key.font: Fonts.smallFont, NSAttributedString.Key.foregroundColor: Colors.blue]
        
        setTitleTextAttributes(normalAttributes, for: .normal)
        setTitleTextAttributes(selectedAttributes, for: .selected)
        
    }
    
    private func imageWithColor(_ color: UIColor, width: CGFloat, height: CGFloat) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  width, height: height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
    
    func replaceSegments(_ segments: Array<String>) {
        self.removeAllSegments()
        for segment in segments {
            self.insertSegment(withTitle: segment, at: self.numberOfSegments, animated: false)
        }
    }
}
