//
//  Utilities.swift
//  Megan
//
//  Created by Megan Lin on 2/16/24.
//

import Foundation
import UIKit
import SwiftUI


let suggestedKeywords = ["ne", "fn", "ln", "fr", "ge", "ro", "ho", "la", "mo", "pl", "pr", "te"]
let avatar = UIImage(named: "duke_avatar.jpg")

let programmingLanguages: [String: String] = [
    "Swift": "🚀",
    "JavaScript": "💻",
    "Python": "🐍",
    "Java": "☕️",
    "C++": "🧰",
    "Ruby": "💎",
    "C#": "🔢",
    "TypeScript": "📄",
    "PHP": "🐘",
    "HTML": "🔤",
    "CSS": "🎨",
    "Kotlin": "🔥",
    "Objective-C": "📱",
    "Go": "🐹",
    "Rust": "🦀",
    "SwiftUI": "🎨",
    "Shell": "🐚",
    "SQL": "🗃️",
    "C": "🅒"
]

func parseParams(_ s: String) -> [String: String] {
    var dict: [String: String] = [:]
    let data = s.split(separator: ",")
    for param in data {
        let tmp = param.trimmingCharacters(in: .whitespaces).split(separator: "=")
        if tmp.count >= 1 && suggestedKeywords.contains(String(tmp[0])){
            if tmp.count == 1 {
                dict[String(tmp[0])] = ""
            } else {
                dict[String(tmp[0])] = String(tmp[1])
            }
        }
    }
    print(dict)
    return dict
}

func randomDUID(maximumValue: Int, excludedNumbers: [Int]) -> Int {
    var random: Int
    repeat {
        random = Int(arc4random_uniform(UInt32(maximumValue)))
    } while excludedNumbers.contains(random)
    return random
}

func imageFromString(_ strPic: String) -> Image {
    var picImage: UIImage?
    if let picImageData = Data(base64Encoded: strPic, options: .ignoreUnknownCharacters) {
        picImage = UIImage(data: picImageData) ?? avatar
    } else {
        picImage = avatar
    }
    // return picImage!
    let swiftUIImage = Image(uiImage: picImage!)
    return swiftUIImage
}

func stringFromImage(_ imagePic: UIImage) -> String {
    let picImageData: Data = imagePic.jpegData(compressionQuality: 0.6)!
    let picBase64 = picImageData.base64EncodedString()
    return picBase64
}

func constructFilterText(filter: [String: String]) -> String {
    let keyValueStrings = filter.map { key, value in
        "\(key)=\(value)"
    }

    let result = keyValueStrings.joined(separator: ", ")

    print(result)
    return result
}

func filterDukePerson(all: [DukePerson], params: [String: String]) -> [DukePerson] {
    var people = all
    
    for param in params {
        if param.key == "la" {
            let tmp = param.value.split(separator: ";")
            var langs: [String] = []
            for language in tmp {
                langs.append(language.trimmingCharacters(in: .whitespaces))
            }
            print(langs)
            people = people.filter { person in
                param.value.isEmpty ||
                   langs.allSatisfy { language in
                       person.languages.contains {
                           personLanguage in
                                return language.caseInsensitiveCompare(personLanguage) == .orderedSame
                       }
                   }
            }
        } else {
            people = people.filter { person in
                param.value.isEmpty || {
                    if let val = (Mirror(reflecting: person).children.first { prop in
                        prop.label!.lowercased().hasPrefix(param.key) == true
                    })?.value {
                        if let check = val as? String {
                            return check.range(of: param.value, options: .caseInsensitive) != nil
                        } else if let enumValue = val as? (any EnumWithRawValue), let rawValue = enumValue.rawValue as? String {
                            return rawValue.range(of: param.value, options: .caseInsensitive) != nil
                        } else {
                            return false
                        }
                    } else {
                        return false
                    }
                }()
            }
        }
    }
    return people
}
