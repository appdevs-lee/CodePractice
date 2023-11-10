//
//  AlarmModel.swift
//  CodePractice
//
//  Created by Awesomepia on 2023/07/17.
//

import Foundation
import Alamofire

class User {
    static let shared = User()
    
    var accessToken: String = ""
    
    private init() {
        self.accessToken = "Bearer " + "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI0MTgiLCJyb2xlIjoiVVNFUiIsIm9zIjoyLCJ2ZXJzaW9uIjoiMS4wLjQiLCJzZXNzaW9uQXV0aCI6IlR0YWU0elpTQXVuYWc2T2JIeFRvaG5KdW5FZWF5Z0RFL0lGWGpNWHNGQWs9IiwiZXhwIjoxNjkwODUzMzQzfQ.wa-iw3khJsn8ZTqnt1sUhadcHHVmI9O_UZrO2biA8Zc"
    }
}

// MARK: DefaultResponse
struct DefaultResponse: Codable {
    let result: String
    let message: String
}

final class AlarmModel {
    private(set) var loadAlarmListRequest: DataRequest?
    private(set) var deleteAlarmRequest: DataRequest?
    private(set) var deleteAllAlarmRequest: DataRequest?
    
    private(set) var loadAlarmFollowerListRequest: DataRequest?
    private(set) var deleteFollowerRequest: DataRequest?
    private(set) var deleteAllFollowerRequest: DataRequest?
    
    private(set) var changeAlarmStatusRequest: DataRequest?
    
    func loadAlarmListRequest(lastNo: Int, success: ((AlarmItem) -> ())?, failure: ((_ errorMessage: String) -> ())?) {
        let url = "https://dev.meti.world/api/alarm"
        
        let headers: HTTPHeaders = [
            "access": "application/json",
            "Authorization": User.shared.accessToken
        ]
        
        let parameters: Parameters = [
            "lastNo": lastNo,
            "range": "10"
        ]
        
        self.loadAlarmListRequest = AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
        
        self.loadAlarmListRequest?.responseData { response in
            switch response.result {
            case .success(let data):
                guard let statusCode = response.response?.statusCode else {
                    print("loadAlarmListRequest failure: statusCode nil")
                    failure?("statusCodeNil")
                    
                    return
                }
                
                guard statusCode >= 200 && statusCode < 300 else {
                    print("loadAlarmListRequest failure: statusCode(\(statusCode))")
                    failure?("statusCodeError")
                    
                    return
                }
                
                if let decodedData = try? JSONDecoder().decode(DefaultResponse.self, from: data) {
                    if decodedData.result == "true" { // result == true
                        if let decodedData = try? JSONDecoder().decode(Alarm.self, from: data) {
                            print("loadAlarmListRequest succeeded")
                            success?(decodedData.data)
                            
                        } else { // parsing failure
                            print("loadAlarmListRequest failure: API 성공, Parsing 실패")
                            failure?("API 성공, Parsing 실패")
                        }
                        
                    } else { // result == false
                        print("loadAlarmListRequest failure: \(decodedData.message)")
                        failure?(decodedData.message)
                    }
                    
                } else { // improper structure
                    print("loadAlarmListRequest failure: improper structure")
                    failure?("알 수 없는 Response 구조")
                }
                
            case .failure(let error): // error
                print("loadAlarmListRequest error: \(error.localizedDescription)")
                failure?(error.localizedDescription)
            }
        }
    }
    
    func deleteAlarmRequest(alarmHistoryNo: Int, success: (() -> ())?, failure: ((_ errorMessage: String) -> ())?) {
        let url = "https://dev.meti.world/api/alarm"
        
        let headers: HTTPHeaders = [
            "access": "application/json",
            "Authorization": User.shared.accessToken
        ]
        
        let parameters: Parameters = [
            "alarmHistoryNo": alarmHistoryNo
                                                        ]
        self.deleteAlarmRequest = AF.request(url, method: .delete, parameters: parameters, encoding: URLEncoding.default, headers: headers)
        
        self.deleteAlarmRequest?.responseData { response in
            switch response.result {
            case .success(let data):
                guard let statusCode = response.response?.statusCode else {
                    print("deleteAlarmRequest failure: statusCode nil")
                    failure?("statusCodeNil")
                    
                    return
                }
                
                guard statusCode >= 200 && statusCode < 300 else {
                    print("deleteAlarmRequest failure: statusCode(\(statusCode))")
                    failure?("statusCodeError")
                    
                    return
                }
                
                if let decodedData = try? JSONDecoder().decode(DefaultResponse.self, from: data) {
                    if decodedData.result == "true" { // result == true
                        print("deleteAlarmRequest succeeded")
                        success?()
                        
                    } else { // result == false
                        print("deleteAlarmRequest failure: \(decodedData.message)")
                        failure?(decodedData.message)
                    }
                    
                } else { // improper structure
                    print("deleteAlarmRequest failure: improper structure")
                    failure?("알 수 없는 Response 구조")
                }
                
            case .failure(let error): // error
                print("deleteAlarmRequest error: \(error.localizedDescription)")
                failure?(error.localizedDescription)
            }
        }
    }
    
    func deleteAllAlarmRequest(success: (() -> ())?, failure: ((_ errorMassage: String) -> ())?) {
        let url = "https://dev.meti.world/api/alarm-all"
        
        let headers: HTTPHeaders = [
            "access": "application/json",
            "Authorization": User.shared.accessToken
        ]
        
        self.deleteAllAlarmRequest = AF.request(url, method: .delete, parameters: nil, encoding: URLEncoding.default, headers: headers)
        
        self.deleteAllAlarmRequest?.responseData { response in
            switch response.result {
            case .success(let data):
                guard let statusCode = response.response?.statusCode else {
                    print("deleteAllAlarmRequest failure: statusCode nil")
                    failure?("statusCodeNil")
                    
                    return
                }
                
                guard statusCode >= 200 && statusCode < 300 else {
                    print("deleteAllAlarmRequest failure: statusCode(\(statusCode))")
                    failure?("statusCodeError")
                    
                    return
                }
                
                if let decodedData = try? JSONDecoder().decode(DefaultResponse.self, from: data) {
                    if decodedData.result == "true" { // result == true
                        print("deleteAllAlarmRequest succeeded")
                        success?()
                        
                    } else { // result == false
                        print("deleteAllAlarmRequest failure: \(decodedData.message)")
                        failure?(decodedData.message)
                    }
                    
                } else { // improper structure
                    print("deleteAllAlarmRequest failure: improper structure")
                    failure?("알 수 없는 Response 구조")
                }
                
            case .failure(let error): // error
                print("deleteAllAlarmRequest error: \(error.localizedDescription)")
                failure?(error.localizedDescription)
            }
        }
    }
    
    func loadAlarmFollowerListRequest(lastNo: Int, success: ((AlarmItem) -> ())?, failure: ((_ errorMessage: String) -> ())?) {
        let url = "https://dev.meti.world/api/alarm/follower"
        
        let headers: HTTPHeaders = [
            "access": "application/json",
            "Authorization": User.shared.accessToken
        ]
        
        let parameters: Parameters = [
            "lastNo": lastNo,
            "range": 10,
        ]
        
        self.loadAlarmFollowerListRequest = AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: headers)
        
        self.loadAlarmFollowerListRequest?.responseData { response in
            switch response.result {
            case .success(let data):
                guard let statusCode = response.response?.statusCode else {
                    print("loadAlarmFollowerListRequest failure: statusCode nil")
                    failure?("statusCodeNil")
                    
                    return
                }
                
                guard statusCode >= 200 && statusCode < 300 else {
                    print("loadAlarmFollowerListRequest failure: statusCode(\(statusCode))")
                    failure?("statusCodeError")
                    
                    return
                }
                
                if let decodedData = try? JSONDecoder().decode(DefaultResponse.self, from: data) {
                    if decodedData.result == "true" { // result == true
                        if let decodedData = try? JSONDecoder().decode(Alarm.self, from: data) {
                            print("loadAlarmFollowerListRequest succeeded")
                            success?(decodedData.data)
                            
                        } else { // parsing failure
                            print("loadAlarmFollowerListRequest failure: API 성공, Parsing 실패")
                            failure?("API 성공, Parsing 실패")
                        }
                        
                    } else { // result == false
                        print("loadAlarmFollowerListRequest failure: \(decodedData.message)")
                        failure?(decodedData.message)
                    }
                    
                } else { // improper structure
                    print("loadAlarmFollowerListRequest failure: improper structure")
                    failure?("알 수 없는 Response 구조")
                }
                
            case .failure(let error): // error
                print("loadAlarmFollowerListRequest error: \(error.localizedDescription)")
                failure?(error.localizedDescription)
            }
        }
    }
    
    func deleteFollowerRequest(alarmHistoryNo: Int, success: (() -> ())?, failure: ((_ errorMessage: String) -> ())?) {
        let url = "https://dev.meti.world/api/alarm/follower"
        
        let headers: HTTPHeaders = [
            "access": "application/json",
            "Authorization": User.shared.accessToken
        ]
        
        let parameters: Parameters = [
            "alarmHistoryNo": alarmHistoryNo
        ]
        
        self.deleteFollowerRequest = AF.request(url, method: .delete, parameters: parameters, encoding: URLEncoding.default, headers: headers)
        
        self.deleteFollowerRequest?.responseData { response in
            switch response.result {
            case .success(let data):
                guard let statusCode = response.response?.statusCode else {
                    print("deleteFollowerRequest failure: statusCode nil")
                    failure?("statusCodeNil")
                    
                    return
                }
                
                guard statusCode >= 200 && statusCode < 300 else {
                    print("deleteFollowerRequest failure: statusCode(\(statusCode))")
                    failure?("statusCodeError")
                    
                    return
                }
                
                if let decodedData = try? JSONDecoder().decode(DefaultResponse.self, from: data) {
                    if decodedData.result == "true" { // result == true
                        print("deleteFollowerRequest succeeded")
                        success?()
                        
                    } else { // result == false
                        print("deleteFollowerRequest failure: \(decodedData.message)")
                        failure?(decodedData.message)
                    }
                    
                } else { // improper structure
                    print("deleteFollowerRequest failure: improper structure")
                    failure?("알 수 없는 Response 구조")
                }
                
            case .failure(let error): // error
                print("deleteFollowerRequest error: \(error.localizedDescription)")
                failure?(error.localizedDescription)
            }
        }
    }
    
    func deleteAllFollowerRequest(success: (() -> ())?, failure: ((_ errorMessage: String) -> ())?) {
        let url = "https://dev.meti.world/api/alarm/follower-all"
        
        let headers: HTTPHeaders = [
            "access": "application/json",
            "Authorization": User.shared.accessToken
        ]
        
        self.deleteAllFollowerRequest = AF.request(url, method: .delete, parameters: nil, encoding: URLEncoding.default, headers: headers)
        
        self.deleteAllFollowerRequest?.responseData { response in
            switch response.result {
            case .success(let data):
                guard let statusCode = response.response?.statusCode else {
                    print("deleteAllFollowerRequest failure: statusCode nil")
                    failure?("statusCodeNil")
                    
                    return
                }
                
                guard statusCode >= 200 && statusCode < 300 else {
                    print("deleteAllFollowerRequest failure: statusCode(\(statusCode))")
                    failure?("statusCodeError")
                    
                    return
                }
                
                if let decodedData = try? JSONDecoder().decode(DefaultResponse.self, from: data) {
                    if decodedData.result == "true" { // result == true
                        print("deleteAllFollowerRequest succeeded")
                        success?()
                        
                    } else { // result == false
                        print("deleteAllFollowerRequest failure: \(decodedData.message)")
                        failure?(decodedData.message)
                    }
                    
                } else { // improper structure
                    print("deleteAllFollowerRequest failure: improper structure")
                    failure?("알 수 없는 Response 구조")
                }
                
            case .failure(let error): // error
                print("deleteAllFollowerRequest error: \(error.localizedDescription)")
                failure?(error.localizedDescription)
            }
        }
    }
    
    func changeAlarmStatusRequest(alarmHistoryNoList: [Int], alarmHistoryStatus: String, success: (() -> ())?, failure: ((_ errorMessage: String) -> ())?) {
        let url = "https://dev.meti.world/api/alarm/status"
        
        let headers: HTTPHeaders = [
            "access": "application/json",
            "Authorization": User.shared.accessToken
        ]
        
        let parameters: Parameters = [
            "alarmHistoryNoList": alarmHistoryNoList,
            "alarmHistoryStatus": alarmHistoryStatus
        ]
        
        self.changeAlarmStatusRequest = AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        
        self.changeAlarmStatusRequest?.responseData { response in
            switch response.result {
            case .success(let data):
                guard let statusCode = response.response?.statusCode else {
                    print("changeAlarmStatusRequest failure: statusCode nil")
                    failure?("statusCodeNil")
                    
                    return
                }
                
                guard statusCode >= 200 && statusCode < 300 else {
                    print("changeAlarmStatusRequest failure: statusCode(\(statusCode))")
                    failure?("statusCodeError")
                    
                    return
                }
                
                if let decodedData = try? JSONDecoder().decode(DefaultResponse.self, from: data) {
                    if decodedData.result == "true" { // result == true
                        print("changeAlarmStatusRequest succeeded")
                        success?()
                        
                    } else { // result == false
                        print("changeAlarmStatusRequest failure: \(decodedData.message)")
                        failure?(decodedData.message)
                    }
                    
                } else { // improper structure
                    print("changeAlarmStatusRequest failure: improper structure")
                    failure?("알 수 없는 Response 구조")
                }
                
            case .failure(let error): // error
                print("changeAlarmStatusRequest error: \(error.localizedDescription)")
                failure?(error.localizedDescription)
            }
        }
    }
    
}

// MARK: Alarm
class Alarm: Codable {
    let result: String
    let message: String
    let data: AlarmItem
    
}

class AlarmItem: Codable {
    let alarmList: [AlarmDetailItem]
    let alarmCnt: Int
}

class AlarmDetailItem: Codable {
    let no: Int
    let alarmHistoryNo: Int
    let alarmKindsNo: Int
    let sender: Int
    let alarmKindsTitleKr: String?
    let alarmKindsTitleEn: String?
    let alarmHistoryBody: String?
    let alarmContents: String?
    let sendTs: String
    let recvTs: String
    let readTs: String
    let delTs: String
    
    var isCheck: Bool = false
    
    let userId: String?
    let nickname: String?
    var followingYn: String?
    let profileImgPath: String?

    enum CodingKeys: CodingKey {
        case no
        case alarmHistoryNo
        case alarmKindsNo
        case sender
        case alarmKindsTitleKr
        case alarmKindsTitleEn
        case alarmHistoryBody
        case alarmContents
        case sendTs
        case recvTs
        case readTs
        case delTs
        case userId
        case nickname
        case followingYn
        case profileImgPath
    }
    
}

struct AlarmContentsDetail: Codable {
    let contentsKindsNo: Int?
    let uuid: String?
    let contentsNo: Int?
    let commentNo: Int?
}
