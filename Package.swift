
import PackageDescription

let package = Package(
	name: "TortoiseCmd",
	targets: [
		
	],
	dependencies: [
		.Package(url:"https://github.com/PerfectlySoft/PerfectLib.git", majorVersion: 2, minor: 0),
		.Package(url:"https://github.com/PerfectlySoft/Perfect-Thread.git", majorVersion: 2, minor: 0),
		.Package(url:"https://github.com/PerfectlySoft/Perfect-MySQL.git", majorVersion: 2, minor: 0),
		.Package(url:"https://github.com/PerfectlySoft/Perfect-SMTP.git", majorVersion: 1, minor: 0)
	]
)
