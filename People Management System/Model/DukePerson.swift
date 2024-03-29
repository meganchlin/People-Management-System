//
//  DukePerson.swift
//  Megan
//
//  Created by Megan Lin on 2/16/24.
//

import Foundation

protocol EnumWithRawValue {
    associatedtype RawValueType
    var rawValue: RawValueType { get }
}

enum Role : String, Codable, CaseIterable, EnumWithRawValue {
    typealias RawValueType = String
    
    case Unknown = "Unknown" // has not been specified
    case Professor = "Professor"
    case TA = "TA"
    case Student = "Student"
    case Other = "Other" // has been specified, but is not Professor, TA, or Student
}

enum Gender : String, Codable, CaseIterable, EnumWithRawValue {
    typealias RawValueType = String
    
    case Unknown = "Unknown" // has not been specified
    case Male = "Male"
    case Female = "Female"
    case Other = "Other" // has been specified, but is not “Male” or “Female”
}

enum Program : String, Codable, CaseIterable, EnumWithRawValue {
    typealias RawValueType = String
    
    case NotApplicable = "NA"
    case MENG = "MENG"
    case BA = "BA"
    case BS = "BS"
    case MS = "MS"
    case PHD = "PhD"
    case Other = "Other"
}

enum Plan: String, Codable, CaseIterable, EnumWithRawValue {
    typealias RawValueType = String
    
    case NotApplicable = "NA"
    case CS = "Computer Science"
    case ECE = "ECE"
    case FinTech = "FinTech"
    case Other = "Other"
}


struct DukePerson: Codable, CustomStringConvertible, Identifiable, Equatable {
    let DUID: Int
    var netID: String
    var fName: String
    var lName: String
    var from: String // Where are you from
    var hobby: String // Your favorite pastime / hobby
    var languages: [String] // Up to 3 PROGRAMMING languages that you know.
    var moviegenre: String // Your favorite movie genre (Thriller, Horror, RomCom, etc)
    var gender: Gender
    var role: Role
    var program: Program
    var plan: Plan
    var team: String
    var picture: String
    
    var id: Int {
        return self.DUID
    }
    
    var email: String {
        if netID == "" {
            return "netID@duke.edu"
        } else {
            return "\(netID)@duke.edu"
        }
    }
    
    var description: String {
        return formDescrip()
    }
    
    static func == (lhs: DukePerson, rhs: DukePerson) -> Bool {
        
        // Use Mirror to get the properties of the struct
        let mirror = Mirror(reflecting: lhs)

        // Iterate over the properties
        for (label, lhsValue) in mirror.children {
            // Ensure the property is not nil (Optional check)
            guard let label = label else { continue }

            // Use optional chaining to safely access the property from rhs
            if let rhsValue = Mirror(reflecting: rhs).children.first(where: { $0.label == label })?.value{
                if let lv = lhsValue as? String, let rv = rhsValue as? String {
                    if lv != rv {return false}
                } else if let lv = lhsValue as? (any EnumWithRawValue), let rv = rhsValue as? (any EnumWithRawValue) {
                    if (lv.rawValue as? String) != (rv.rawValue as? String) {return false}
                } else {
                    return false
                }
            }
        }

        // If all properties match, return true
        return true
    }
    
    init(DUID: Int) {
        self.DUID = DUID
        self.netID = ""
        self.fName = "firstname"
        self.lName = "lastname"
        self.from = "unknown"
        self.hobby = "unknown"
        self.languages = ["unknown"]
        self.moviegenre = "unknown"
        self.gender = Gender.Unknown
        self.role = Role.Unknown
        self.plan = Plan.NotApplicable
        self.program = Program.NotApplicable
        self.team = "unknown"
        self.picture = ""
    }
    
    init(DUID: Int, netid: String?, fName: String?, lName: String?, from: String?, hobby: String?,  languages: String?, moviegenre: String?, gender: String?, role: String?, plan: String?, program: String?, team: String?, picture: String? = "") {
        self.DUID = DUID
        self.netID = netid ?? ""
        self.fName = fName ?? "firstname"
        self.lName = lName ?? "lastname"
        self.from = from ?? "unknown"
        self.hobby = hobby ?? "unknown"
        if languages != nil {
            let tmp = languages!.split(separator: ";")
            var langs: [String] = []
            for language in tmp {
                // if langs.count >= 3 { break}
                langs.append(language.trimmingCharacters(in: .whitespaces))
            }
            self.languages = langs
        } else {
            self.languages = ["unknown"]
        }
        self.moviegenre = moviegenre ?? "unknown"
        self.gender = Gender(rawValue: gender ?? "Unknown") ?? Gender.Other
        self.role = Role(rawValue: role ?? "Unknown") ?? Role.Other
        self.plan = Plan(rawValue: plan ?? "NA") ?? Plan.Other
        self.program = Program(rawValue: program ?? "NA") ?? Program.Other
        self.team = team ?? "unknown"
        self.picture = picture ?? ""
        
    }
    
    
    func formDescrip() -> String {
        var s = "\(fName) \(lName) is a \(role). "
        switch gender {
        case .Unknown:
            s += "They are"
        case .Male:
            s += "He is"
        case .Female:
            s += "She is"
        case .Other:
            s += "They are"
        }
        s += " from \(from) and enjoys \(hobby). \(fName) likes to watch \(moviegenre) movies and is proficient in"
        for (i, lang) in languages.enumerated(){
            //if i > 2 {
            //    break
            //}
            switch i {
            case 0:
                s += " "
            case languages.count - 1:
                s += " and "
            //case 1:
            //    s += ", "
            //case 2:
            //    s += " and "
            default:
                s += ", "
            }
            s += lang
        }
        s += ". You can reach "
        switch gender {
        case .Unknown:
            s += "them"
        case .Male:
            s += "him"
        case .Female:
            s += "her"
        case .Other:
            s += "them"
        }
        
        s += " at \(email).\n"
        
        if role == .Student || role == .TA {
            s += extendedDescription()
        }
        return s
    }
    
    func extendedDescription() -> String{
        return "\(fName) is in the \(program) program studying \(plan).\n"
    }
}
