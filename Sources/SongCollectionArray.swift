import KituraSys
import SwiftyJSON

import Foundation

// MARK: SongCollectionArray
class SongCollectionArray: SongCollection {
    ///
    /// Ensure in order writes to the collection
    ///
    let writingQueue = Queue(type: .serial, label: "Writing Queue")

    ///
    /// Incrementing variable used for new index values
    ///
    var idCounter: Int = 0

    ///
    /// Internal storage of Songs as a Dictionary
    ///
    private var _collection = [String: Song]()

    var count: Int {
        return _collection.keys.count
    }

    func clear( oncompletion: (Void) -> Void) {
        writingQueue.queueAsync() {
            self._collection.removeAll()
            oncompletion()
        }
    }

    func getAll( oncompletion: ([Song]) -> Void ) {
        writingQueue.queueAsync() {
            oncompletion( [Song](self._collection.values) )
        }
    }

    func get(_ id: String, oncompletion: (Song?) -> Void ) {
        writingQueue.queueAsync() {
            oncompletion(self._collection[id])
        }
    }

    static func serialize(items: [Song]) -> [JSONDictionary] {
        return items.map { $0.serialize() }
    }


    func add(title: String?, name: String?, bio: String?, youtubeId: String?, image: String?, oncompletion: (Song) -> Void ) {
        var original: String
        original = String(self.idCounter)

        let newItem = Song( id: original,
                              title: title!,
                              name: name!,
                              bio: bio!,
                              youtubeId: youtubeId!,
                              image: image!)

        writingQueue.queueAsync() {
            self.idCounter+=1

            self._collection[original] = newItem

            // Log.info("Added \(title)")

            oncompletion(newItem)
        }
    }

    ///
    /// Update an element by id
    ///
    /// - Parameter id: id for the element
    /// -
    func update(id: String, title: String?, name: String?, bio: String?, youtubeId: String?, image: String?, oncompletion: (Song?) -> Void ) {
        // search for element
        let oldValue = _collection[id]

        if let oldValue = oldValue {
            // use nil coalescing operator
            let newValue = Song( id: id,
                                  title: title ?? oldValue.title,
                                  name: name ?? oldValue.name,
                                  bio: bio ?? oldValue.bio,
                                  youtubeId: youtubeId ?? oldValue.youtubeId,
                                  image: image ?? oldValue.image)

            writingQueue.queueAsync() {
                self._collection.updateValue(newValue, forKey: id)
                oncompletion( newValue )
            }

            // Log.warning("Could not find item in database with ID: \(id)")
        }
    }

    func delete(_ id: String, oncompletion: (Void) -> Void) {
        writingQueue.queueAsync() {
            self._collection.removeValue(forKey: id)
            oncompletion()
        }
    }
}
