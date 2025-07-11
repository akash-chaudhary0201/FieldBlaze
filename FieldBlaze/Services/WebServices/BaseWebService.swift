//
//  BaseWebService.swift
//  FRATELLI
//
//  Created by Sakshi on 21/10/24.
//

import Foundation
import UIKit
import Alamofire

struct EndPoints {
    var GET_ALL_CUSTOMERS = "SELECT+Id, Name, ParentId, Type, PI_Payment_Terms__c, RE_Price_Book__r.Id ,RE_Price_Book__r.Name, BillingAddress FROM Account ORDER BY Name ASC NULLS LAST LIMIT 1"
    var SEND_ACCOUNT = "composite/tree/Account/"
    var SEND_ADVOCACY_REQUEST = "composite/tree/Advocacy_Request__c/"
    var CONATCT = "composite/tree/Contact/"
    var SEND_SALES_ORDER = "composite/tree/Sales_Order__c/"
    var SEND_SALES_ORDER_LINE_ITEMS = "composite/tree/Order_Item__c/"
    var SEND_RISK_STOCKS = "composite/tree/Risk_Stock__c/"
    var SEND_RISK_STOCK_LINE_ITEMS = "composite/tree/Risk_Stock_Line_Item__c/"
    var SEND_POSM_REQUEST = "composite/tree/POSM__c/"
    var SEND_POSM_LINE_ITEMS_REQUEST = "composite/tree/POSM_Line_Item__c/"
    var SEND_SALES_ORDERS = "composite/tree/Sales_Order__c/"
    var SEND_ORDER_LINE_ITEMS = "composite/tree/Order_Item__c/"
    var SEND_ASSET_VISIBILITY = "composite/tree/Order_Item__c/"
    var SEND_ASSET_REQUEST = "composite/tree/Order_Item__c/"
    var SEND_ASSET_LINE_ITEMS_REQUEST = "composite/tree/Order_Item__c/"
    var SEND_ACTION_ITEMS = "composite/tree/Task/"
    var SEND_CALL_FOR_HELP = "composite/tree/Call_For_Help__c/"
    var SEND_LOCATION = "composite/tree/HMI__User_Location_Track__c/"
    var SEND_SKIP = "composite/tree/Outlet_Adherance_Report__c/"
    var SEND_VISIT = "composite/sobjects/Visits__c/Id/"
    var QCR_IMAGE_UPLOAD = "services/apexrest/fileUpload"
}

enum ContentType: String {
    case multipart = "multipart/form-data"
    case json = "application/json"
    case urlEncoded = "application/x-www-form-urlencoded"
    case none = ""
}

let tokenExpiredErrorMessage = "Session expired or invalid"

class BaseWebService {
    let validation = Validation()
    let reachabilityManager = NetworkReachabilityManager()
    func setLoader() {
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 100
        config.spinnerColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        config.foregroundColor = .black
        config.foregroundAlpha = 0.5
        SwiftLoader.setConfig(config: config)
    }
    
    func getHeader(contentType: ContentType = .json) ->  [String: String] {
        var header: [String: String] = [:]
        if !(Defaults.accessToken ?? "").isEmpty {
            header["Authorization"] = "Bearer \(Defaults.accessToken ?? "")"
        }
        if contentType == .multipart {
            header["Content-Type"] = "multipart/form-data"
        } else if contentType == .json  {
            header["Content-Type"] = "application/json"
            header["accept"] = "application/json"
        } else if contentType == .urlEncoded  {
            header["Content-Type"] = "application/x-www-form-urlencoded"
        } else if contentType == .none {
        }
        return header
    }
    
    func processRequestUsingPostMethod(url: String, parameters: [String: Any]?, showLoader: Bool, contentType: ContentType, closure:@escaping (String?, Bool?, Any?, Int?) -> ()) {
        print(url)
        setLoader()
        if !reachabilityManager!.isReachable {
            closure(INTERNET_NOT_AVAILABLE_STR, false, nil, nil)
            return
        }
        if showLoader == true {
            SwiftLoader.show(title: "Loading...", animated: true)
        }
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders(getHeader(contentType: contentType)))
            .responseJSON { response in
                print(response)
                SwiftLoader.hide()
                let dict = response.value as? [String : Any] ?? [:]
                print(dict)
                let errorDict = dict["error"] as? [String : Any] ?? [:]
                let errorMessage = errorDict["message"] as? String ?? ERROR_OCCURRED
                if let statusCode = response.response?.statusCode {
                    if (statusCode == 401) {
                        if errorMessage == tokenExpiredErrorMessage {
                            Utility.tokenExpiredAction()
                            closure(errorMessage, false, nil, statusCode)
                        } else {
                            closure(errorMessage, false, nil, statusCode)
                        }
                    }
                    if statusCode == 200 || statusCode == 201 || statusCode == 203 || statusCode == 204 {
                        closure(nil, true, response.value, statusCode)
                    } else {
                        let dict = response.value as? [String : Any] ?? [:]
                        closure(errorMessage, false, dict, statusCode)
                    }
                } else {
                    closure(errorMessage, false, nil, response.response?.statusCode)
                }
            }
    }
    
    
    func processRequestUsingGetMethod(url: String, parameters: [String: Any]?, showLoader: Bool,  closure:@escaping (String?, Bool?, Any?, Int?) -> ()) {
        setLoader()
        if !reachabilityManager!.isReachable {
            closure(INTERNET_NOT_AVAILABLE_STR, false, nil, nil)
            return
        }
        if showLoader == true {
            SwiftLoader.show(title: "Loading...", animated: true)
        }
        AF.request(url, method: .get, parameters: parameters, headers: HTTPHeaders(getHeader()))
            .responseJSON { response in
                SwiftLoader.hide()
                let dict = response.value as? [String : Any] ?? [:]
                let errorDict = dict["error"] as? [String : Any] ?? [:]
                let errorMessage = errorDict["message"] as? String ?? ERROR_OCCURRED
                if let statusCode = response.response?.statusCode {
                    if (statusCode == 401) {
                        if errorMessage == tokenExpiredErrorMessage {
                            //                            Utility.tokenExpiredAction()
                            closure(errorMessage, false, nil, statusCode)
                        } else {
                            closure(errorMessage, false, nil, statusCode)
                        }
                        return
                    }
                    if statusCode == 200 || statusCode == 201 || statusCode == 203 || statusCode == 204 {
                        closure(nil, true, response.value, statusCode)
                    } else {
                        let dict = response.value as? [String : Any] ?? [:]
                        closure(dict["message"] as? String ?? ERROR_OCCURRED, false, dict, statusCode)
                    }
                } else {
                    closure(errorMessage, false, nil, response.response?.statusCode)
                }
            }
    }
    
    func processRequestUsingPutMethod(url: String, parameters: [String: Any]?, showLoader: Bool, closure:@escaping (String?, Bool?, Any?, Int?) -> ()) {
        setLoader()
        if !reachabilityManager!.isReachable {
            closure(INTERNET_NOT_AVAILABLE_STR, false, nil, nil)
            return
        }
        if showLoader {
            DispatchQueue.main.async() {
                SwiftLoader.show(title: "Loading...", animated: true)
            }
        }
        AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders(getHeader(contentType: .json))) .responseJSON { response in
            SwiftLoader.hide()
            let dict = response.value as? [String : Any] ?? [:]
            let errorDict = dict["error"] as? [String : Any] ?? [:]
            let errorMessage = errorDict["message"] as? String ?? ERROR_OCCURRED
            if let statusCode = response.response?.statusCode {
                if (statusCode == 401) {
                    if errorMessage == tokenExpiredErrorMessage {
                        Utility.tokenExpiredAction()
                        closure(errorMessage, false, nil, statusCode)
                    } else {
                        closure(errorMessage, false, nil, statusCode)
                    }
                    return
                }
                if statusCode == 200 || statusCode == 201 || statusCode == 203 || statusCode == 204 {
                    closure(nil, true, response.value, statusCode)
                } else {
                    let dict = response.value as? [String : Any] ?? [:]
                    closure(dict["message"] as? String ?? ERROR_OCCURRED, false, dict, statusCode)
                }
            } else {
                closure(errorMessage, false, nil, response.response?.statusCode)
            }
        }
    }
    
    func processRequestUsingDeleteMethod(url: String, parameters: [String: Any]?, showLoader: Bool, closure:@escaping (String?, Bool?, Any?, Int?) -> ()) {
        setLoader()
        if !reachabilityManager!.isReachable {
            closure(INTERNET_NOT_AVAILABLE_STR, false, nil, nil)
            return
        }
        if showLoader {
            DispatchQueue.main.async() {
                SwiftLoader.show(title: "Loading...", animated: true)
            }
        }
        AF.request(url, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders(getHeader(contentType: .json)))
            .responseJSON { response in
                SwiftLoader.hide()
                let dict = response.value as? [String : Any] ?? [:]
                let errorDict = dict["error"] as? [String : Any] ?? [:]
                let errorMessage = errorDict["message"] as? String ?? ERROR_OCCURRED
                if let statusCode = response.response?.statusCode {
                    if (statusCode == 401) {
                        if errorMessage == tokenExpiredErrorMessage {
                            Utility.tokenExpiredAction()
                            closure(errorMessage, false, nil, statusCode)
                        } else {
                            closure(errorMessage, false, nil, statusCode)
                        }
                        return
                    }
                    if statusCode == 200 || statusCode == 201 || statusCode == 203 || statusCode == 204 {
                        closure(nil, true, response.value, statusCode)
                    } else {
                        let dict = response.value as? [String : Any] ?? [:]
                        closure(dict["message"] as? String ?? ERROR_OCCURRED, false, dict, statusCode)
                    }
                } else {
                    closure(errorMessage, false, nil, response.response?.statusCode)
                }
            }
    }
    
    func multipartSingleImageUpload(isUpdate: Bool, url: String, imageKey: String, image: UIImage, closure:@escaping (String?, Bool?, Any?, Int?) -> ()) {
        if !reachabilityManager!.isReachable {
            closure(INTERNET_NOT_AVAILABLE_STR, false, nil, nil)
            return
        }
        setLoader()
        SwiftLoader.show(title: "Loading...", animated: true)
        var httpMethod = HTTPMethod(rawValue: "POST")
        if isUpdate {
            httpMethod =  HTTPMethod(rawValue: "PUT")
        }
        AF.upload(multipartFormData: { multiPart in
            multiPart.append((image.jpegData(compressionQuality: 1.0)!), withName: imageKey, fileName: "\(Utility.getUniqueName()).jpeg", mimeType: "image/jpeg")
        }, to: url, method: httpMethod , headers: HTTPHeaders(getHeader(contentType: .multipart)))
        .uploadProgress(queue: .main, closure: { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        })
        .responseJSON(completionHandler: { response in
            SwiftLoader.hide()
            let dict = response.value as? [String : Any] ?? [:]
            let errorDict = dict["error"] as? [String : Any] ?? [:]
            let errorMessage = errorDict["message"] as? String ?? ERROR_OCCURRED
            if let statusCode = response.response?.statusCode {
                if (statusCode == 401) {
                    if errorMessage == tokenExpiredErrorMessage {
                        Utility.tokenExpiredAction()
                        closure(errorMessage, false, nil, statusCode)
                    } else {
                        closure(errorMessage, false, nil, statusCode)
                    }
                }
                if statusCode == 200 || statusCode == 201 || statusCode == 203 || statusCode == 204 {
                    closure(nil, true, response.value, statusCode)
                } else {
                    let dict = response.value as? [String : Any] ?? [:]
                    closure(errorMessage, false, dict, statusCode)
                }
            } else {
                closure(errorMessage, false, nil, response.response?.statusCode)
            }
        })
    }
    
    func multipartUploadImagewithParam(url: String, parameters: [String: Any]?, multupleImages: [UIImage], isUpdate: Bool = false, closure:@escaping (String?, Bool?, Any?, Int?) -> ()) {
        if !reachabilityManager!.isReachable {
            closure(INTERNET_NOT_AVAILABLE_STR, false, nil, nil)
            return
        }
        setLoader()
        SwiftLoader.show(title: "Loading...", animated: true)
        var httpMethod = HTTPMethod(rawValue: "POST")
        if isUpdate {
            httpMethod = HTTPMethod(rawValue: "PUT")
        }
        AF.upload(multipartFormData:{
            (multipartFormData) in
            for (key, value) in parameters! {
                if value is [String] {
                    let array = value as? [String] ?? []
                    for data in array {
                        multipartFormData.append((data as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key, mimeType: "text")
                    }
                } else {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key, mimeType: "text")
                }
            }
            for img in multupleImages {
                multipartFormData.append((img.jpegData(compressionQuality: 1.0)!), withName: "attachments", fileName: "\(Utility.getUniqueName()).jpeg", mimeType: "image/jpeg")
            }
        }, to: url, method: httpMethod , headers: HTTPHeaders(getHeader(contentType: .multipart)))
        .uploadProgress(queue: .main, closure: { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        })
        .responseJSON(completionHandler: { response in
            SwiftLoader.hide()
            let dict = response.value as? [String : Any] ?? [:]
            let errorDict = dict["error"] as? [String : Any] ?? [:]
            let errorMessage = errorDict["message"] as? String ?? ERROR_OCCURRED
            if let statusCode = response.response?.statusCode {
                if (statusCode == 401) {
                    if errorMessage == tokenExpiredErrorMessage {
                        Utility.tokenExpiredAction()
                        closure(errorMessage, false, nil, statusCode)
                    } else {
                        closure(errorMessage, false, nil, statusCode)
                    }
                }
                if statusCode == 200 || statusCode == 201 || statusCode == 203 || statusCode == 204 {
                    closure(nil, true, response.value, statusCode)
                } else {
                    let dict = response.value as? [String : Any] ?? [:]
                    closure(errorMessage, false, dict, statusCode)
                }
            } else {
                closure(errorMessage, false, nil, response.response?.statusCode)
            }
        })
    }
    
    func processRequestUsingPatchMethod(url: String, parameters: [String: Any]?, showLoader: Bool, closure:@escaping (String?, Bool?, Any?, Int?) -> ()) {
        setLoader()
        if !reachabilityManager!.isReachable {
            closure(INTERNET_NOT_AVAILABLE_STR, false, nil, nil)
            return
        }
        if showLoader {
            DispatchQueue.main.async() {
                SwiftLoader.show(title: "Loading...", animated: true)
            }
        }
        AF.request(url, method: .patch, parameters: parameters, encoding: JSONEncoding.default, headers: HTTPHeaders(getHeader(contentType: .json))) .responseJSON { response in
            SwiftLoader.hide()
            print(response)
            let dict = response.value as? [[String : Any]] ?? []
            let errorDict = dict[0]
            let errorMessage = errorDict["message"] as? String ?? ERROR_OCCURRED
            if let statusCode = response.response?.statusCode {
                if (statusCode == 401) {
                    if errorMessage == tokenExpiredErrorMessage {
                        Utility.tokenExpiredAction()
                        closure(errorMessage, false, nil, statusCode)
                    } else {
                        closure(errorMessage, false, nil, statusCode)
                    }
                }
                if statusCode == 200 || statusCode == 201 || statusCode == 203 || statusCode == 204 {
                    closure(nil, true, response.value, statusCode)
                } else {
                    let dict = response.value as? [String : Any] ?? [:]
                    closure(dict["message"] as? String ?? ERROR_OCCURRED, false, dict, statusCode)
                }
            } else {
                closure(errorMessage, false, nil, response.response?.statusCode)
            }
        }
    }
}

