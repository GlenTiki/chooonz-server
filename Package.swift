import PackageDescription

let package = Package(
    name: "chooonz-server",
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 0, minor: 7)
    ]
)
