//
//  UIImage.swift
//  runnerpia
//
//  Created by Jun on 2023/05/15.
//

import UIKit

// MARK: Image resizing
extension UIImage{
    func newScaleOfImage(targetSize: CGSize) -> CGSize{
        // 가로세로 스케일링 비율 측정
        let widthScaleRatio = targetSize.width / self.size.width
        let heightScaleRatio = targetSize.height / self.size.height
        
        // 가로세로 스케일링 비율 중 더 큰쪽에 맞추기
        let scaleFactor = min(widthScaleRatio, heightScaleRatio)
        
        // 이미지 리사이징시 비율은 맞추되, 오토레이아웃에 설정해둔 height값 기준으로 크기를 최대높이를 조절한다
        return CGSize(width: self.size.width * scaleFactor, height: self.size.height * scaleFactor)
    }
    
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage{
        
        // 새로운 스케일 계산
        let scaledSize = newScaleOfImage(targetSize: targetSize)
        let renderer = UIGraphicsImageRenderer(size: scaledSize)
        
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: scaledSize))
        }
        
        return scaledImage
    }
    
    
    // MARK: 가로 또는 세로만 키우기
    
    enum Axis{
        case horizontal
        case vertical
    }
    func scaleWithoutPreserveAspectRatio(targetValue: CGFloat,originalValue: CGFloat ,axis: Axis) -> UIImage{
        
        switch axis{
        case .horizontal:
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: targetValue, height: originalValue))
            let scaledImage = renderer.image { _ in
                self.draw(in: CGRect(origin: .zero, size: CGSize(width: targetValue, height: originalValue)))
            }
            return scaledImage
        case .vertical:
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: originalValue, height: targetValue))
            let scaledImage = renderer.image { _ in
                self.draw(in: CGRect(origin: .zero, size: CGSize(width: originalValue, height: targetValue)))
            }
            return scaledImage
        }
    }
}
