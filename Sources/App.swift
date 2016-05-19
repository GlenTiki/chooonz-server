import Kitura
import KituraNet

import SwiftyJSON

/**
 Sets up all the routes for the Song List application
*/
func setupRoutes(router: Router, songs: SongCollection) {
  router.all("/*", middleware: BodyParser())

  // router.all("/*", middleware: AllRemoteOriginMiddleware())

  // redirect to /songs
  router.get("/") {
    request, response, next in

    do {
      try response.redirect(config.firstPathSegment)
    } catch {
      print("problem with redirection")
    }

    next()
  }

  // Get all the songs
  router.get(config.firstPathSegment) {
    request, response, next in

    songs.getAll() {
      songs in

      let json = JSON(SongCollectionArray.serialize(items: songs))
      do {
        try response.status(.OK).send(json: json).end()
      } catch {
        print("Song collection could not be serialized")
      }
    }
  }

  // Get information about a Song item by ID
  router.get(config.firstPathSegment + "/:id") {
    request, response, next in

    // A guard let is similar to an if let, but it allows you to check for
    // bad conditions and return if these bad conditions are met. It allows
    // for cleaner code as code doesn't need to be nested in uneccessary if
    // let statements.
    guard let id = request.params["id"] else {
      response.status(.badRequest)
      print("Request does not contain ID")
      return
    }

    songs.get(id) {
      item in

      if let item = item {
        let result = JSON(item.serialize())
        do {
          try response.status(.OK).send(json: result).end()
        } catch {
          print("Error sending response")
        }
      } else {
        print("Could not find the item", id)
        response.status(.notFound)
        return
      }
    }
  }

  // Get a Song image by ID
  router.get(config.firstPathSegment + "/:id/image") {
    request, response, next in

    // A guard let is similar to an if let, but it allows you to check for
    // bad conditions and return if these bad conditions are met. It allows
    // for cleaner code as code doesn't need to be nested in uneccessary if
    // let statements.
    guard let id = request.params["id"] else {
      response.status(.badRequest)
      print("Request does not contain ID")
      return
    }

    songs.get(id) {
      item in

      if let item = item {
        do {
          try response.send(fileName: "Images/" + item.image).end()
        } catch {
          print("Error sending response")
        }
      } else {
        print("Could not find the item", id)
        response.status(.notFound)
        return
      }
    }
  }

  // Handle options
  router.options("/*") {
    request, response, next in

    // response.setHeader("Access-Control-Allow-Headers", value: "accept, content-type")
    // response.setHeader("Access-Control-Allow-Methods", value: "GET,HEAD,POST,DELETE,OPTIONS,PUT,PATCH")

    response.status(.OK)

    next()
  }

  // Add a Song list item
  router.post(config.firstPathSegment + "/") {
    request, response, next in

    guard let body = request.body else {
      response.status(.badRequest)
      print("No body found in request")
      return
    }

    guard case let .json(json) = body else {
      response.status(.badRequest)
      print("Body is invalid JSON")
      return
    }

    let title = json["title"].stringValue
    let name = json["name"].stringValue
    let bio = json["bio"].stringValue
    let youtubeId = json["youtubeId"].stringValue
    let image = json["image"].stringValue

    print("Received \(title)")

    songs.add(title: title, name: name, bio: bio, youtubeId: youtubeId, image: image) {
      newItem in

      let result = JSON(newItem.serialize())
      do {
        try response.status(.OK).send(json: result).end()
      } catch {
        print("Error sending response")
      }
    }
  }

  // update some song
  router.post(config.firstPathSegment + "/:id") {
    request, response, next in

    guard let id = request.params["id"] else {
      response.status(.badRequest)
      print("id parameter not found in request")
      return
    }

    guard let body = request.body else {
      response.status(.badRequest)
      print("No body found in request")
      return
    }

    guard case let .json(json) = body else {
      response.status(.badRequest)
      print("Body is invalid JSON")
      return
    }

    let title = json["title"].stringValue
    let name = json["name"].stringValue
    let bio = json["bio"].stringValue
    let youtubeId = json["youtubeId"].stringValue
    let image = json["image"].stringValue

    songs.update(id: id, title: title, name: name, bio: bio, youtubeId: youtubeId, image: image) {
      newItem in

      let result = JSON(newItem!.serialize())
      response.status(.OK).send(json: result)
    }
  }

  // Patch or update an existing Song item
  router.patch(config.firstPathSegment + "/:id") {
    request, response, next in

    guard let id = request.params["id"] else {
      response.status(.badRequest)
      print("id parameter not found in request")
      return
    }

    guard let body = request.body else {
      response.status(.badRequest)
      print("No body found in request")
      return
    }

    guard case let .json(json) = body else {
      response.status(.badRequest)
      print("Body is invalid JSON")
      return
    }

    let title = json["title"].stringValue
    let name = json["name"].stringValue
    let bio = json["bio"].stringValue
    let youtubeId = json["youtubeId"].stringValue
    let image = json["image"].stringValue

    songs.update(id: id, title: title, name: name, bio: bio, youtubeId: youtubeId, image: image) {
      newItem in

      if let newItem = newItem {
        let result = JSON(newItem.serialize())

        do {
            try response.status(.OK).send(json: result).end()
        } catch {
            print("Error sending response")
        }
      }
    }
  }

  // Delete an individual Song item
  router.delete(config.firstPathSegment + "/:id") {
    request, response, next in

    print("Requesting a delete")

    guard let id = request.params["id"] else {
      print("Could not parse ID")
      response.status(.badRequest)
      return
    }

    songs.delete(id) {
      do {
        try response.status(.OK).end()
      } catch {
        print("Could not produce response")
      }
    }
  }

  // Delete all the Song items
  router.delete("/") {
    request, response, next in

    print("Requested clearing the entire list")

    songs.clear() {
      do {
        try response.status(.OK).end()
      } catch {
        print("Could not produce response")
      }
    }
  }
} // end of SetupRoutes()
