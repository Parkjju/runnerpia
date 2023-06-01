//
//  RouteManager.swift
//  runnerpia
//
//  Created by Jun on 2023/05/29.
//

import UIKit
import CoreLocation

let firstData = Route(user: User(userId: "경준", nickname: "경준"), routeName: "한강 잠실 러닝길한강 잠실 러닝길한강 잠실 러닝길" ,distance: 500, arrayOfPos: [CLLocationCoordinate2D(latitude: 37.2785, longitude: 127.1452),CLLocationCoordinate2D(latitude: 37.2779, longitude: 127.1452),CLLocationCoordinate2D(latitude: 37.2767, longitude: 127.1444)], runningTime: "500분", review: "두줄까지 작성됩니다. 두줄 넘어가면 좌/우 여백 유지하면서 좌측 정렬로 줄내림되면서 ... 처리 됩니다.두줄까지 작성됩니다. 두줄 넘어가면 좌/우 여백 유지하면서 좌측 정렬로 줄내림되면서 ... 처리 됩니다.", runningDate: "12월 31일 토요일 오후 6~9시", recommendedTags: ["1","2"], secureTags: ["0","1","2"], files: [])
let secondData = Route(user: User(userId: "경준", nickname: "경준"),routeName: "한강 잠실 러닝길",distance: 300,arrayOfPos: [CLLocationCoordinate2D(latitude: 37.2759, longitude: 127.1488), CLLocationCoordinate2D(latitude: 37.2765, longitude: 127.1493), CLLocationCoordinate2D(latitude: 37.2771, longitude: 127.1502)], runningTime: "320분", review: "예시 데이터입니다. 여기 러닝 코스 아주 괜찮습니다. 붕어빵 가게도 있습니다. 중간에 ㅕ편의점도 있어요 ! 경치가 좋아요~ 고양이가 많습니당", runningDate: "12월 30일 일요일 오후 2~3시", recommendedTags: ["0","1","2"], secureTags: ["0","1"], files: nil)

let array: [Route] = [firstData, secondData]

class RouteManager{
    static let shared = RouteManager()
    
    func getRoutes() -> [Route]{
        // HTTP
        return array
    }
    
    
}
