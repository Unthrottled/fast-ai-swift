// swift-tools-version:4.2
import PackageDescription

let package = Package(
name: "SchwiftyNotebook_initial_setup",
products: [
.library(name: "SchwiftyNotebook_initial_setup", targets: ["SchwiftyNotebook_initial_setup"]),

],
dependencies: [
.package(url: "https://github.com/mxcl/Path.swift", from: "0.16.1"),
    .package(url: "https://github.com/saeta/Just", from: "0.7.2"),
    .package(url: "https://github.com/latenitesoft/NotebookExport", from: "0.5.0")
],
targets: [
.target(name: "SchwiftyNotebook_initial_setup", dependencies: ["Path", "Just", "NotebookExport"]),

]
)