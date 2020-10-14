//
//  StringEncodingExtension.swift
//  SWStringEncodingExtension
//
//  Created by SSD on 2019/8/15.
//  Copyright © 2019 SSD. All rights reserved.
//

import Foundation
import CommonCrypto
public extension String {
    var md5: String? {
        var result:String? = nil
        let preResult = NSMutableString.init()
        guard let chars = cString(using: .utf8) else { return result }
        let digestLength = Int(CC_MD5_DIGEST_LENGTH)
        let lengthOfBytes = self.lengthOfBytes(using: .utf8)
        let unsignedLength = CUnsignedInt(lengthOfBytes)
        let md = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(chars, unsignedLength, md)
        for i in 0..<digestLength {
            preResult.appendFormat("%02x", md[i])
        }
        result = preResult as String
        return result
    }
}

public extension String {
    ///utf-8编码
    var utf8EncodedString: String? { return addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) }
}

public extension String {
    var base64: String? {
        var result:String? = nil
        guard let data = self.data(using: .utf8) else {
            return result
        }
        result = data.base64EncodedString(options: Data.Base64EncodingOptions.init(rawValue: 0))
        return result
    }
    ///base64解码
    var base64Decoded:String?{
        var result:String? = nil
        guard let data = Data.init(base64Encoded: self, options: Data.Base64DecodingOptions.init(rawValue: 0)) else {
            return result
        }
        result = String.init(data: data, encoding: .utf8)
        return result
    }
}

public extension String {
    var sha256: String? {
        var result:String? = nil
        guard let data = data(using: .ascii) else {
            return result
        }
        var digest = [UInt8].init(repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes { bytes in
            _ = CC_SHA256(bytes.baseAddress, CC_LONG(self.count), &digest)
        }
        result = digest.makeIterator().map { String(format: "%02X", $0) }.joined()
        return result
    }
}
