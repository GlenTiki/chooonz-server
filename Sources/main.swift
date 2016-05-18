#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

import Kitura
import KituraNet
import KituraSys
import CFEnvironment

import Foundation
import SwiftyJSON

///
/// Because bridging is not complete in Linux, we must use Any objects for dictionaries
/// instead of AnyObject.
///
#if os(OSX)
    typealias JSONDictionary = [String: AnyObject]
#else
    typealias JSONDictionary = [String: Any]
#endif

let config = Config()

let router = Router()

///
/// Setup the database
///
let songs: SongCollection = SongCollectionArray()

let jsonData = NSData(contentsOfFile: "data.json")
// Convert NSData to JSON object
let x = JSON(data: jsonData!)["songs"]
for (_, song):(String, JSON) in x {
  let title = song["title"].stringValue
  let name = song["name"].stringValue
  let bio = song["bio"].stringValue
  let youtubeId = song["youtubeId"].stringValue
  let image = song["image"].stringValue

  songs.add(title: title, name: name, bio: bio, youtubeId: youtubeId, image: image) {
    song in
  }
}

setupRoutes(router: router, songs: songs)

let server = HTTPServer.listen(port: config.port!, delegate: router)
Server.run()
print("Server is started on \(config.url).")
