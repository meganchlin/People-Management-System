//
//  ModelData.swift
//  Megan
//
//  Created by Megan Lin on 2/16/24.
//

import Foundation
import UIKit

@Observable
class ModelData {
    
    var auth = ""
 
    var DukePeople: [Int:DukePerson] = loadInitialData()
    var Group: [String: [String:String]] = loadGroup()
    
    var downloadState: Bool = false
    var downloadResult: Bool = true
    var downloadMessage: String = ""
    
    private var task: URLSessionTask?
    

    init() {

        // Add observer for UserDefaults changes
        NotificationCenter.default.addObserver(self, selector: #selector(userDefaultsDidChange), name: UserDefaults.didChangeNotification, object: nil)
    }

    // Function to handle UserDefaults changes
    
    @objc func userDefaultsDidChange() {
        // Update yourValue with the latest value from UserDefaults
        let defaults = UserDefaults.standard
        guard let authStr = defaults.object(forKey: "AuthString") as? String else {
            return
        }
        print(auth)
        
        let auth = authStr.split(separator: ":")
        self.auth = String(auth[0])
        print(auth[0])
        
        let subdirectoryURL = DocumentsDirectory.appendingPathComponent(self.auth)
        var isDirectory: ObjCBool = false
        if FileManager.default.fileExists(atPath: subdirectoryURL.path, isDirectory: &isDirectory) && isDirectory.boolValue{
            // Subdirectory exists
            print("Subdirectory exists.")
            print("reload")
            if let newData = reload(str: self.auth) {
                self.DukePeople = newData
            }
            self.Group = loadGroup(str: self.auth)
        } else {
            // Subdirectory does not exist, create it
            do {
                try FileManager.default.createDirectory(at: subdirectoryURL, withIntermediateDirectories: true, attributes: nil)
                print("Subdirectory created.")
            } catch {
                print("Error creating subdirectory: \(error)")
            }
        }

    }
    
    func download(website: String, auth: String, delegate: URLSessionDelegate?, upload: Bool) -> Bool {
        //Builds a URLRequest and Session from website and the appropriate endpoint.
        //Builds a Basic Authorization (“netid:password”) base64EncodedString from auth and then
        //executes a dataTask to download all entries in the server. Use URLSessionDataDelegate
        //methods for receiving the returned data using delegate as the View Controller which
        //has the urlSession functions.
        
        
        
        guard let url = URL(string: website) else {
            self.downloadResult = false
            self.downloadMessage = "Error: URL not exists."
            print("url not exists")
            return false
        }
        var req = URLRequest(url: url)
        let loginData = auth.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()


        req.httpMethod = "GET"
        req.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let session = URLSession.shared
        
        let decoder = JSONDecoder()
        
        let task = session.downloadTask(with: req) {
            loc, resp, err in
            if let error = err {
                self.downloadResult = false
                self.downloadMessage = "URL Session Error: An issue occurred during the URL session."
                print(error)
            }
            if let data = loc {
                print("data: ", data)
                if let downloadData = try? Data(contentsOf: data) {
                    self.downloadState = false
                    do {
                        let decoded = try decoder.decode([DukePerson].self, from: downloadData)
                        //print(decoded)
                        if !upload {
                            self.DukePeople = [:]
                        }
                        for person in decoded {
                            self.DukePeople[person.DUID] = person
                        }
                        _ = save(self.DukePeople.map{$0.value}, str: self.auth)
                    } catch let error as NSError {
                        self.downloadResult = false
                        self.downloadMessage = "JSON Decode Error: Invalid or malformed JSON data."
                        print(error)
                    }
                } else {
                    self.downloadMessage = "Read Data Error: The downloaded data is either empty or in an unexpected format."
                }
            }
        }
        print("data downloading ...")
        self.downloadState = true
        self.task = task
        task.resume()
        
        return true
    }
    
    func cancelDownload() {
        task?.cancel()
        task = nil
    }

    func upload(website: String, auth: String, person: DukePerson, update: Bool) -> Bool {
        //Builds a URLRequest and Session from website and the appropriate endpoint.
        //Builds a Basic Authorization (“netid:password”) base64EncodedString from auth and then
        //executes a dataTask to upload person information. For HW3, update is always true.
        
        var result = true
        
        let url = URL(string: website)
        var req = URLRequest(url: url!)
        let loginData = auth.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()


        req.httpMethod = "PUT"
        req.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if update {
            // update person
            let session = URLSession.shared
            
            let updateData: Data
            let encoder = JSONEncoder()
            
            
            if let encoded = try? encoder.encode(person){
                updateData = encoded
                print(updateData)
            }
            else {
                print("JSON Encode Error")
                return false
            }
            
            
            let task = session.uploadTask(with: req, from: updateData) {
                loc, resp, err in
                if let error = err {
                    print(error)
                    result = false
                }
            }
            task.resume()
            print("data uploading ...")
        }
        
        return result
    }

}

private let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
private var ArchiveURL = DocumentsDirectory.appendingPathComponent("DukePersonJSONFile")
private let GroupDataURL = DocumentsDirectory.appendingPathComponent("GroupJSONFile")


func loadInitialData() -> [Int:DukePerson] {
    if FileManager().fileExists(atPath: ArchiveURL.path) {
        print("DukePersonJSONFile AVAILABLE")
        return load(ArchiveURL)
    } else {
        var tmp = DukePerson(DUID: 123456, netid: "12345", fName: "Megan", lName: "Lin", from: "Taiwan", hobby: "music", languages: "C++; Python", moviegenre: "sci-fi", gender: "Female", role: "Student", plan: "Computer Science", program: "MS", team: "TripMaker")
        tmp.picture = stringFromImage(UIImage(named: "pic.jpg") ?? UIImage())
        //print(tmp.picture.count)
        
        var tmp2 = DukePerson(DUID: randomDUID(maximumValue: 1300000, excludedNumbers: [123456]), netid: "example", fName: "First", lName: "Last", from: "Nowhere", hobby: "Pending", languages: "Swift", moviegenre: "None", gender: "Unknown", role: "Other", plan: "NA", program: "NA", team: "None")
        tmp2.picture = stringFromImage(UIImage(named: "duke_avatar.jpg") ?? UIImage())
        _ = save([tmp, tmp2])
            
        //_ = ModelData().upload(website: urlStr, auth: authStr, person: tmp, update: true)
        
        return [tmp.DUID:tmp, tmp2.DUID: tmp2]
    }
}

func reload(str: String) -> [Int:DukePerson]? {
    let URL = DocumentsDirectory.appendingPathComponent(str).appendingPathComponent("DukePersonJSONFile")
    print(URL)
    if FileManager().fileExists(atPath: URL.path) {
        print("DukePersonJSONFile AVAILABLE")
        return load(URL)
    }
    return nil
}

func load(_ url:URL) -> [Int:DukePerson] {
    //Reads a JSON file as designated by url, decodes it, and replaces the existing
    //data model with the entries from the JSON file. Returns true if everything worked OK,
    //false if it doesn’t.
    
    let decoder = JSONDecoder()
    var people = [Int:DukePerson]()
    let tempData: Data
    
    print(url)
    do {
        tempData = try Data(contentsOf: url)
    } catch let error as NSError {
        print(error)
        return people
    }

    do {
        let decoded = try decoder.decode([DukePerson].self, from: tempData)
        for person in decoded {
            people[person.DUID] = person
        }
    } catch let error as NSError {
        print(error)
    }

    return people
}

func loadGroup(str: String? = nil) -> [String: [String: String]] {
    var groups = [String: [String: String]]()
    
    var tmpURL = GroupDataURL
    if str != nil {
        tmpURL = DocumentsDirectory.appendingPathComponent(str!).appendingPathComponent("GroupJSONFile")
    }
    
    if !FileManager().fileExists(atPath: tmpURL.path) {
        print("GroupJSONFile NOT AVAILABLE")
        return groups
    }
    
    do {
        // Read JSON data from the file
        let jsonData = try Data(contentsOf: tmpURL)
        
        // Convert JSON data to a Swift dictionary
        if let loadedGroup = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: [String: String]] {
            // Use the loadedDictionary as needed
            print("Loaded JSON data:", loadedGroup)
            groups = loadedGroup
            
        } else {
            print("Error: Unable to cast JSON data to dictionary")
        }
    } catch {
        print("Error: \(error)")
    }
    
    return groups
}

func save(_ newPeople: [DukePerson], str: String? = nil) -> Bool {
    //Converts the current data model entries to JSON and writes the JSON string to a
    //pre-determined filename. Returns true if everything works OK, false if it doesn’t.
    
    print("save data ...")
    var outputData = Data()
    let encoder = JSONEncoder()
    var tmpURL = ArchiveURL
    if str != nil {
        tmpURL = DocumentsDirectory.appendingPathComponent(str!).appendingPathComponent("DukePersonJSONFile")
    }
    print(tmpURL)
    if let encoded = try? encoder.encode(newPeople){
        outputData = encoded
        do {
            try outputData.write(to: tmpURL)
        } catch let error as NSError {
            print (error)
            return false
        }
        print("finish saving")
        return true
    } else {
        return false
    }
}

func saveGroup(_ newGroup: [String : [String:String]], str: String? = nil) -> Bool {
    //Converts the current data model entries to JSON and writes the JSON string to a
    //pre-determined filename. Returns true if everything works OK, false if it doesn’t.
    var tmpURL = GroupDataURL
    if str != nil {
        tmpURL = DocumentsDirectory.appendingPathComponent(str!).appendingPathComponent("GroupJSONFile")
    }
    do {
        let groupData = try JSONSerialization.data(withJSONObject: newGroup, options: .prettyPrinted)
        // Write JSON data to the file
        try groupData.write(to: tmpURL)
        
        print("JSON file saved successfully at: \(tmpURL.path)")
        return true
    } catch {
        print("Error: \(error)")
        return false
    }
}
