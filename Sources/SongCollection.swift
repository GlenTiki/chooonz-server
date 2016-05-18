/**
 SongCollection
 SongCollection defines the protocol for song lists
 Our SongCollectionDBHandler handles the management of the entire logic
*/
protocol SongCollection {

    var count: Int { get }

    func clear(oncompletion: (Void) -> Void)

    func getAll(oncompletion: ([Song]) -> Void )

    func get(_ id: String, oncompletion: (Song?) -> Void )

    func add(title: String?, name: String?, bio: String?, youtubeId: String?, image: String?, oncompletion: (Song) -> Void )

    func update(id: String, title: String?, name: String?, bio: String?, youtubeId: String?, image: String?, oncompletion: (Song?) -> Void )

    func delete(_ id: String, oncompletion: (Void) -> Void)

    static func serialize(items: [Song]) -> [JSONDictionary]
}
