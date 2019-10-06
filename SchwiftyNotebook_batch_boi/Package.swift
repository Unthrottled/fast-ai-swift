// swift-tools-version:4.2
import PackageDescription

let package = Package(
name: "SchwiftyNotebook_batch_boi",
products: [
.library(name: "SchwiftyNotebook_batch_boi", targets: ["SchwiftyNotebook_batch_boi"]),

],
dependencies: [
.package(path: "../SchwiftyNotebook_auto_diffy")
],
targets: [
.target(name: "SchwiftyNotebook_batch_boi", dependencies: ["SchwiftyNotebook_auto_diffy"]),

]
)