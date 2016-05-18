import Foundation
import CFEnvironment

public struct Config {
    let port: Int?
    let url: String?
    let firstPathSegment = "songs"
    init() {
        do {
            let appEnv = try CFEnvironment.getAppEnv()
            port = appEnv.port
            url = appEnv.url
        }
        catch _ {
            port = 0
            url = ""
        }
    }
}
