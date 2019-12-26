//
//  String+MD5.swift
//  DMSwift
//
//  Created by Sherzod Khashimov on 8/29/19.
//  Copyright © 2019 Sherzod Khashimov. All rights reserved.
//

import Foundation
import CommonCrypto

extension String {

    /// Created MD5 hashed string.
    var MD5: String {

        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = self.data(using:.utf8)!
        var digestData = Data(count: length)

        #if swift(>=5.0)

            _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
                messageData.withUnsafeBytes { messageBytes -> UInt8 in
                    if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                        let messageLength = CC_LONG(messageData.count)
                        CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                    }
                    return 0
                }
            }

        #else

        _ = digestData.withUnsafeMutableBytes({ digestBytes in
            messageData.withUnsafeBytes({ messageBytes in
                CC_MD5(messageBytes, CC_LONG(messageData.count), digestBytes)
            })
        })

        #endif

        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
}
