//
//  MyReviewViewController.swift
//  runnerpia
//
//  Created by juyeong koh on 2023/06/07.
//


import UIKit

final class MyReviewViewController: UIViewController {
    
    // MARK: - Properties
      var myReviewView = MyReviewView()


    // MARK: - LifeCycle

  override func viewDidLoad() {
    super.viewDidLoad()

    configureNavigation()
    configureDelegate()
    configureUI()

  }
  
      override func loadView() {
        view = myReviewView
    }
    
    
    // MARK: - Selectors
    
    // MARK: - Helpers
  
      private func configureUI() {
    }
    
    private func configureNavigation() {
        navigationController?.navigationBar.tintColor = .black
        
    }
    
    private func configureDelegate() {
    }
    

}
