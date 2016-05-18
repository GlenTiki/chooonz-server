struct Song {
    /// ID
    var id: String = ""

    /// Text to display
    var title: String = ""
    var name: String = ""
    var bio: String = ""
    var youtubeId: String = ""
    var image: String = ""

    /// Full path URL to the resource
    /// ex. http://localhost:8090/todos/508
    ///
    var url: String {
        if let url = config.url {
            return url + "/" + config.firstPathSegment + "/" + id
        } else {
            return ""
        }
    }

    ///
    /// Transform the structure to a Dictionary
    ///
    /// Returns: a Dictionary populated with fields.
    ///
    func serialize() -> JSONDictionary {
        var result = JSONDictionary()
        result["id"] = id

        result["title"] = title
        result["name"] = name
        result["bio"] = bio
        result["youtubeId"] = youtubeId
        result["image"] = image

        result["url"] = url
        return result
    }
}
