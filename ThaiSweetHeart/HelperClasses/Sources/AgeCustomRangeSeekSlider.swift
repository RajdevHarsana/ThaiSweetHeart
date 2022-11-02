//
//  CustomRangeSeekSlider.swift
//  RangeSeekSlider
//
//  Created by Keisuke Shoji on 2017/03/16.
//
//

import UIKit

@IBDesignable final class AgeCustomRangeSeekSlider: RangeSeekSlider {

    fileprivate let ages: [Int] = [
        18, 19, 20, 21, 22, 23, 24, 25,26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99
        ]

    override func setupStyle() {
        let pink: UIColor = #colorLiteral(red: 0.0000000000, green: 0.5019607843, blue: 0.0000000000, alpha: 1) // greenCSS3 #008000
        let gray: UIColor = #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1) // gray #808080

        minValue = 0.0
        maxValue = CGFloat(ages.count - 1)
        selectedMinValue = 18.0
        selectedMaxValue = CGFloat(ages.count - 1)
        minDistance = 1.0
        handleColor = pink
        minLabelColor = pink
        maxLabelColor = pink
        colorBetweenHandles = pink
        tintColor = gray
        numberFormatter.locale = Locale(identifier: "ja_JP")
        numberFormatter.numberStyle = .currency
        labelsFixed = true
        initialColor = gray

        delegate = self
    }

    fileprivate func priceString(value: CGFloat) -> String {
        let index: Int = Int(roundf(Float(value)))
        let price: Int = ages[index]
        if price == .min {
            return "Min"
        } else if price == .max {
            return "Max"
        } else {
            let priceString: String? = numberFormatter.string(from: price as NSNumber)
            return priceString ?? ""
        }
    }
}


// MARK: - RangeSeekSliderDelegate

extension AgeCustomRangeSeekSlider: RangeSeekSliderDelegate {

    func rangeSeekSlider(_ slider: RangeSeekSlider, stringForMinValue minValue: CGFloat) -> String? {
        return priceString(value: minValue)
    }

    func rangeSeekSlider(_ slider: RangeSeekSlider, stringForMaxValue maxValue: CGFloat) -> String? {
        return priceString(value: maxValue)
    }
}
