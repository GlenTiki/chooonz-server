import Kitura
import KituraNet
import KituraSys

let router = Router()
let port = 8090

router.get("/") { request, response, next in
    print("got a request")
    response.send("Hello, World!")
    next()
}

router.get("/api/song") { req, res, next in

}

router.get("/api/song/:id") { req, res, next in

}

router.get("/api/song/:id/") { req, res, next in

}

let server = HttpServer.listen(port, delegate: router)
Server.run()
