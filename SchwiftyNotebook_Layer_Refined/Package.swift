// swift-tools-version:4.2
import PackageDescription

let package = Package(
name: "SchwiftyNotebook_Layer_Refined",
products: [
.library(name: "SchwiftyNotebook_Layer_Refined", targets: ["SchwiftyNotebook_Layer_Refined"]),

],
dependencies: [
.package(path: "../SchwiftyNotebook_batch_boi")
],
targets: [
.target(name: "SchwiftyNotebook_Layer_Refined", dependencies: ["SchwiftyNotebook_batch_boi"]),

]
)