//
//  PostDetailViewController.swift
//  runnerpia
//
//  Created by 박경준 on 2023/05/25.
//

import UIKit
import NMapsMap

class PostDetailViewController: UIViewController {
    
    var bindingData: (Date, (TimeInterval, TimeInterval), (Int, Int), [NMGLatLng])?{
        didSet{
            let view = self.view as! PostDetailView
            view.bindingData = bindingData
        }
    }
    
    let placeholderText = "최소 30자 이상 작성해주세요. (비방, 욕설을 포함한 관련없는 내용은 통보 없이 삭제될 수 있습니다."

    override func viewDidLoad() {
        super.viewDidLoad()

        let postDetailView = PostDetailView()
        self.view = postDetailView
    }
    
    // MARK: objc methods
    @objc func scrollViewTapHandler(sender: UITapGestureRecognizer){
        sender.view?.endEditing(true)
    }
    
    @objc func moveUpAction(){
        // MARK: 키보드 업 액션 필요
    }


}

extension PostDetailViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView.tag == 3){
            return 4
        }
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 의존성을 삭제하는 코드?
        // 서브뷰 인덱싱으로 하면 추후 뷰가 추가될 경우 코드가 꼬임 -> tag속성으로 처리
        if(collectionView.tag == 1){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Tag", for: indexPath) as! TagCollectionViewCell
            switch(indexPath.item){
            case 0:
                cell.isSecureTag = true
                cell.tagName = globalSecureTags[indexPath.item]
            case 1:
                cell.isSecureTag = false
                cell.tagName = globalRecommendedTags[indexPath.item]
            case 2:
                cell.tagName = "+3"
                cell.isGradient = true
            case 3:
                cell.isSecureTag = false
                cell.tagName = globalRecommendedTags[indexPath.item]
            case 4:
                cell.isSecureTag = false
                cell.tagName = globalRecommendedTags[2]
            case 5:
                cell.isSecureTag = false
                cell.tagName = globalRecommendedTags[3]
            default:
                break
            }
            return cell
        }else if(collectionView.tag == 2){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Tag", for: indexPath) as! TagCollectionViewCell
            switch(indexPath.item){
            case 0:
                cell.isSecureTag = true
                cell.tagName = globalSecureTags[indexPath.item]
            case 1:
                cell.isSecureTag = true
                cell.tagName = globalRecommendedTags[indexPath.item]
            case 2:
                cell.tagName = "+3"
                cell.isGradient = true
            case 3:
                cell.isSecureTag = true
                cell.tagName = globalRecommendedTags[indexPath.item]
            case 4:
                cell.isSecureTag = false
                cell.tagName = globalRecommendedTags[2]
            case 5:
                cell.isSecureTag = false
                cell.tagName = globalRecommendedTags[3]
            default:
                break
            }
            return cell
        }else if(collectionView.tag == 3){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Photo", for: indexPath) as! PhotoCollectionViewCell
            
            switch(indexPath.item){
            case 0:
                cell.isAddButton = true
            default:
                break
            }
            
            return cell
        }else{
            return UICollectionViewCell()
        }
        
        
    }
}

extension PostDetailViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 80, height: 80)
    }
}

// MARK: 텍스트뷰 델리게이트 - 글자수 뷰 업데이트 및 플레이스 홀더 UI 조작 필요
extension PostDetailViewController: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView.text == placeholderText){
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty){
            textView.text = placeholderText
            textView.textColor = .textGrey02
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let view = self.view as! PostDetailView
        view.numberOfTextInput.text = "\(textView.text.count) / 300"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 300
    }
}
