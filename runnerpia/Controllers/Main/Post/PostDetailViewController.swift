//
//  PostDetailViewController.swift
//  runnerpia
//
//  Created by 박경준 on 2023/05/25.
//

import UIKit
import PhotosUI
import NMapsMap

class PostDetailViewController: UIViewController {
    
    var bindingData: (Date, (TimeInterval, TimeInterval), (Int, Int), [NMGLatLng])?{
        didSet{
            let view = self.view as! PostDetailView
            view.bindingData = bindingData
        }
    }
    
    let placeholderText = "최소 30자 이상 작성해주세요. (비방, 욕설을 포함한 관련없는 내용은 통보 없이 삭제될 수 있습니다."
    
    // MARK: 속성감시자에서 컬렉션뷰 리로드 하지말고 DispatchWorkItem 마지막 notify에서 리로드
    var dispatchWorkItems: [DispatchWorkItem] = []
    var numberOflastSelectedImages: Int = 0
    
    // MARK: 리로드시 이미지 추가 셀 위치가 변경되어버리는 문제
    // MARK: 컬렉션뷰 리로드에 인덱스를 유지하지 못하는 이 유
    var selectedImages: [UIImage] = []{
        didSet{
            // MARK: 비동기처리 완료된 dispatchWorkItems가 push되었다면 리로드
            if(selectedImages.count == dispatchWorkItems.count){
                DispatchQueue.main.async {
                    let view = self.view as! PostDetailView
                    view.photoCollectionView.reloadData()
                    view.updateCollectionViewHeight()
                }
                numberOflastSelectedImages = selectedImages.count
            }
        }
    }

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
    
    // MARK: Helpers
    func setupImagePicker(){
        // 피커뷰 설정 관련 인스턴스
        var configuration = PHPickerConfiguration()

        // The default value is 1. Setting the value to 0 sets the selection limit to the maximum that the system supports.
        // 디폴트는 1개를 가져올 수 있고 0개 선택시 무한대로 가져올 수 있다고 함
        configuration.selectionLimit = 10

        // 애셋 타입을 지정한다. Live Photo 등을 가져올 수도 있음
        configuration.filter = .any(of: [.images])

        // 피커뷰 객체 생성 시 파라미터에 설정을 전달
        let picker = PHPickerViewController(configuration: configuration)

        // 델리게이트 지정
        picker.delegate = self

        // 화면에 띄우기
        present(picker, animated: true)
    }


}

extension PostDetailViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView.tag == 3){
            return selectedImages.count + 1
        }
        return 6
    }
    
    // MARK: reload후 이미지 세팅 정상동작
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
            
            if(indexPath.item == 0){
                cell.isAddButton = true
            }else{
                cell.selectedImage = selectedImages[indexPath.item - 1]
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.item == 0){
            setupImagePicker()
        }
    }
}

extension PostDetailViewController: PHPickerViewControllerDelegate{
    // reload하면서 이미지 순서가 뒤바뀌는 문제 발생
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        let itemProviders = results.map { $0.itemProvider }
        
        dispatchWorkItems = []
        
        // MARK: DispatchWorkItem 적용, 비동기처리 순서 부여
        itemProviders.forEach { itemProvider in
            // MARK: canloadobject 비동기
            let dispatchWorkItem = DispatchWorkItem {
                if(itemProvider.canLoadObject(ofClass: UIImage.self)){
                    itemProvider.loadObject(ofClass: UIImage.self) { image, _ in
                        self.selectedImages.append(image as! UIImage)
                    }
                }
            }
            
            dispatchWorkItems.append(dispatchWorkItem)
            
        }
        
        for (index, item) in dispatchWorkItems.enumerated(){
            if(index == dispatchWorkItems.count - 1){
                break
            }
            item.notify(queue: DispatchQueue.main, execute: dispatchWorkItems[index + 1])
        }
        DispatchQueue.main.async(execute: dispatchWorkItems.first!)
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
