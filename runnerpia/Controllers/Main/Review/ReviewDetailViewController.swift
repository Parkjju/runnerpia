//
//  ReviewDetailViewController.swift
//  runnerpia
//
//  Created by Jun on 2023/06/08.
//

import UIKit
import PhotosUI

class ReviewDetailViewController: UIViewController {
    
    let placeholderText = "최소 30자 이상 작성해주세요. (비방, 욕설을 포함한 관련없는 내용은 통보 없이 삭제될 수 있습니다."
    
    var selectedImages: [UIImage] = [UIImage(systemName: "plus")!]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let reviewDetailView = ReviewDetailView()
        self.view = reviewDetailView
        
        self.title = "리뷰 등록"
    }
    
    func setupImagePicker(){
        // 피커뷰 설정 관련 인스턴스
        var configuration = PHPickerConfiguration()

        // The default value is 1. Setting the value to 0 sets the selection limit to the maximum that the system supports.
        // 디폴트는 1개를 가져올 수 있고 0개 선택시 무한대로 가져올 수 있다고 함
        configuration.selectionLimit = 11 - selectedImages.count

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

extension ReviewDetailViewController: PHPickerViewControllerDelegate{
    // reload하면서 이미지 순서가 뒤바뀌는 문제 발생
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        // MARK: addImage도 포함해서 11개
        if(results.count + selectedImages.count > 11){
            let alert = UIAlertController(title: "사진 등록", message: "사진은 10장까지만 등록이 가능합니다.", preferredStyle: .alert)
            let success = UIAlertAction(title: "확인", style:.default)
            alert.addAction(success)
            
            present(alert, animated: true)
            return
        }
        
        // MARK: 이미지 로드를 안하고 dismiss를 하면 비동기작업 자체를 실행하면 안됨
        if(results.count == 0){
            return
        }
        
        let itemProviders = results.map { $0.itemProvider }
        
        let group = DispatchGroup()
        let imageQueue = DispatchQueue(label: "imageQueue", attributes: .concurrent)
        
        // MARK: DispatchGroup으로 모든 작업 끝마친 뒤 리로드 비동기작업 하나만 붙이기
        // MARK: didSet으로 배열에 매번 비동기 실행할 경우 경쟁상황 심함
        // MARK: 이미지 append 작업은 다른 큐에서 처리
        // wait메서드 처리
        // group enter는 한번 하는데 forEach에서 여러번 leave -> ERROR
        imageQueue.async(group: group) {
            itemProviders.forEach { itemProvider in
                if(itemProvider.canLoadObject(ofClass: UIImage.self)){
                    group.enter()
                    itemProvider.loadObject(ofClass: UIImage.self) { image, _ in
                        
                        self.selectedImages.append(image as! UIImage)
                        group.leave()
                    }
                }
            }
        }
        group.wait()
        
        // MARK: 더이상 경쟁상황은 없음 Thread-safe 코드 작성 마무리
        // MARK: 컬렉션뷰 리로드 이후 셀 위치 꼬이는 문제 -> layout변경에 따라 달라지는 부분 처리
        group.notify(queue: DispatchQueue.main) {
            // 설마 리로드랑 viewHeight처리도 순서에 맞춰 진행?
            let view = self.view as! ReviewDetailView
            view.photoCollectionView.reloadData()
            view.updateCollectionViewHeight()
        }
    }
}

extension ReviewDetailViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView.tag == 1){
            return selectedImages.count
        }else{
            return 0
        }
    }
    
    // MARK: reload후 이미지 세팅 정상동작
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 의존성을 삭제하는 코드?
        // 서브뷰 인덱싱으로 하면 추후 뷰가 추가될 경우 코드가 꼬임 -> tag속성으로 처리
        if(collectionView.tag == 1){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Photo", for: indexPath) as! PhotoCollectionViewCell
            cell.selectedImage = selectedImages[indexPath.item]
            
            return cell
        }else{
            return UICollectionViewCell()
        }
    }
}

extension ReviewDetailViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // MARK: 컬렉션뷰 4컬럼 배치를 위한 값 계산
        // MARK: estimatedSize로 지정할 경우 배치가 이상해짐
        // MARK: 포토 컬렉션뷰에만 해당하는 문제이며 나머지는 intrinsicSize에 따라 자동 fitting
        return CGSize(width: (UIScreen.main.bounds.width - 62) / 4, height: (UIScreen.main.bounds.width - 62) / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView.tag == 1 && indexPath.item == 0){
            setupImagePicker()
        }
    }
}

extension ReviewDetailViewController: PhotoCollectionViewCellEventDelegate{
    func removeButtonTapped(_ selected: PhotoCollectionViewCell){
        guard let removeIndex = selectedImages.firstIndex(of: selected.selectedImage!) else {return}
        selectedImages.remove(at: removeIndex)
        
        // MARK: 지우는게 너무 밋밋함
        DispatchQueue.main.async {
            let view = self.view as! ReviewDetailView
            view.photoCollectionView.reloadData()
            view.updateCollectionViewHeight()
        }
    }
}

extension ReviewDetailViewController: UITextViewDelegate{
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
        let view = self.view as! ReviewDetailView
        view.numberOfTextInput.text = "\(textView.text.count) / 300"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count <= 300
    }
}
