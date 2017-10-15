    //
    //  FlickrAPIController.swift
    //
    //  Created by VICTOR ASSELTA on 2/27/17.
    //  Written for VirtualTourist adapted for Nomenclature on 9/12/17
    //  Copyright © 2017 TomTheToad. All rights reserved.
    //

import Foundation
import CoreData
import CoreLocation

class FlickrAPIController {
        
    // Fields
    let responseCheck = URLResponseCheck()
    let managedObjectContext: NSManagedObjectContext = {
        return AppDelegate().persistentContainer.viewContext
    }()
    
    // Flickr application key
    private let key = "1ce9f305e66a4ac8c886a811b7cc2c9b"
    private let method = "flickr.photos.search"
    private let session = URLSession(configuration: .ephemeral)
    private let baseURLString = "api.flickr.com"
    private let path = "/services/rest/"
    
    // Custom errors for this API
    enum FlickrErrors: Error {
        case ApplicationError(msg: String)
        case NetworkRequestError(returnError: Error)
        case URLResponse(response: URLResponse)
        case JSONParseError
    }
    
    
    /* bbox (Optional)
     A comma-delimited list of 4 values defining the Bounding Box of the area that will be searched.
     
     The 4 values represent the bottom-left corner of the box and the top-right corner, minimum_longitude, minimum_latitude, maximum_longitude, maximum_latitude
     */
    
    // flickr.photos.search
    // lat, lon, radius, accuracy, safe_search, unit, radius_units, page, per_page
    // return a dictionary
    
    func getImageArray(textToSearch: String, completionHander: @escaping (Error?, [NSDictionary]?) -> Void) throws {
        
        let urlQueryItems: [URLQueryItem] = [
            URLQueryItem(name: "tags", value: textToSearch),
            URLQueryItem(name: "method", value: method),
            URLQueryItem(name: "api_key", value: key),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1"),
            URLQueryItem(name: "safe_search", value: "2"),
            URLQueryItem(name: "per_page", value: "20")
            
        ]
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = baseURLString
        urlComponents.path = path
        urlComponents.queryItems = urlQueryItems
        print("URL: \(urlComponents.url!)")
        
        let request = URLRequest(url: urlComponents.url!)
        
        let task = session.dataTask(with: request, completionHandler: {
            (data, response, error) in
            
            if let thisResponse = response {
                let responseCheck = self.responseCheck.checkReponse(thisResponse)
                if responseCheck.isSuccess != true {
                    completionHander(FlickrErrors.URLResponse(response: thisResponse), nil)
                    print("NETWORK ERROR: \(responseCheck.message)")
                    return
                }
            }
            
            if let thisError = error {
                completionHander(thisError, nil)
                print("ERROR: \(thisError)")
            }
            
            guard let thisData = data else {
                if let error = error  {
                    completionHander(FlickrErrors.NetworkRequestError(returnError: error), nil)
                    return
                } else {
                    guard let thisResponse = response else {
                        completionHander(FlickrErrors.ApplicationError(msg: "Unknown Error"), nil)
                        return
                    }
                    completionHander(FlickrErrors.URLResponse(response: thisResponse), nil)
                    return
                }
            }
            
            do {
                let photosDict = try self.ParseJSONToNSDict(JSONData: thisData)
                completionHander(nil, photosDict)
            } catch {
                completionHander(FlickrErrors.JSONParseError, nil)
            }
            
        })
        
        task.resume()
        
    }
    
    // Parse from JSON to NSDict
    func ParseJSONToNSDict(JSONData: Data) throws -> [NSDictionary] {
        var parsedResults: NSDictionary?
        
        do {
            parsedResults = try JSONSerialization.jsonObject(with: JSONData, options: .allowFragments) as? NSDictionary
        } catch {
            throw FlickrErrors.JSONParseError
        }
        
        if let photos = parsedResults?.value(forKeyPath: "photos.photo") as! [NSDictionary]? {
            return photos
        } else {
            throw FlickrErrors.JSONParseError
        }
        
    }
    
    // Flikr image download function
    func downloadImageFromFlickrURL(url: URL, completionHandler: @escaping (_ data: Data?,_ repsonse: URLResponse?,_ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url, completionHandler: {
            (data, response, error) in
            completionHandler(data, response, error)
        }).resume()
    }
    
    func convertNSDictToPhoto(dictionary: NSDictionary) -> Photo {
        var photo = Photo()
        if let farmID = dictionary.value(forKey: "farm"),
            let serverID = dictionary.value(forKey: "server"),
            let secret = dictionary.value(forKey: "secret"),
            let id = dictionary.value(forKey: "id") as? String {
            
            // TODO: urlComponents?
            let urlString = "https://farm\(farmID).staticflickr.com/\(serverID)/\(id)_\(secret).jpg"
            let thumbURLString = "https://farm\(farmID).staticflickr.com/\(serverID)/\(id)_\(secret)_t.jpg"

            photo.urlString = urlString
            photo.thumbURLString = thumbURLString
            return photo
        }
        return photo
    }
    
    func convertNSDictArraytoPhotoArray(dictionaryArray: [NSDictionary]) -> [Photo] {
        var photoArray = [Photo]()
        for dict in dictionaryArray {
            let photo = convertNSDictToPhoto(dictionary: dict)
            if photo.urlString != "" {
                photoArray.append(photo)
            }

        }
        return photoArray
    }

}
