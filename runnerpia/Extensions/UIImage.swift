//
//  UIImage.swift
//  runnerpia
//
//  Created by Jun on 2023/05/15.
//

import UIKit

// MARK: Image resizing
extension UIImage{
    func newScaleOfImage(targetSize: CGSize, autoResize: Bool) -> CGSize{
        // 가로세로 스케일링 비율 측정
        let widthScaleRatio = targetSize.width / self.size.width
        let heightScaleRatio = targetSize.height / self.size.height
        
        // 가로세로 스케일링 비율 중 더 큰쪽에 맞추기
        let scaleFactor = min(widthScaleRatio, heightScaleRatio)
        
        // 이미지 리사이징시 비율은 맞추되, 오토레이아웃에 설정해둔 height값 기준으로 크기를 최대높이를 조절한다
        return CGSize(width: self.size.width * scaleFactor, height: autoResize ? self.size.height * scaleFactor : 100)
    }
    
    // autoResize 파라미터가 필요할지 -> 나중에 프로필사진 등록 후에 확인필요
    func scalePreservingAspectRatio(targetSize: CGSize, autoResize: Bool) -> UIImage{
        
        // 새로운 스케일 계산
        let scaledSize = newScaleOfImage(targetSize: targetSize, autoResize: autoResize)
        let renderer = UIGraphicsImageRenderer(size: scaledSize)
        
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: scaledSize))
        }
        
        return scaledImage
    }
}
