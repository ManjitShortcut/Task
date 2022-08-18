import Foundation

final class FileReader: Sequence {
    let path: String

    fileprivate let file: UnsafeMutablePointer<FILE>!

    init?(path: String) {
        self.path = path
        self.file = fopen(path, "r")
        guard file != nil
        else { return nil }
    }

    var nextLine: String? {
        var line: UnsafeMutablePointer<CChar>?
        var linecap = 0
        defer { free(line!) }

        let result = getline(&line, &linecap, file)

        if result > 0 {
            if let line = line {
                return String(cString: line)
            }
        }

        return nil
    }

    deinit {
        fclose(file)
    }

    func makeIterator() -> AnyIterator<String> {
        AnyIterator<String> { self.nextLine }
    }
}

// Array + safe
extension Collection {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

enum Regex {
    static func groups(pattern: String, in text: String) throws -> [[String]] {
        let regex = try NSRegularExpression(pattern: pattern)
        let matches = regex.matches(
            in: text,
            range: NSRange(text.startIndex..., in: text)
        )
        return matches.compactMap { match in
            (0 ..< match.numberOfRanges).compactMap {
                let rangeBounds = match.range(at: $0)
                guard let range = Range(rangeBounds, in: text) else {
                    return nil
                }
                return String(text[range])
            }
        }
    }

    static func firstMatch(pattern: String, in text: String) -> [String]? {
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }
        let matches = regex.matches(
            in: text,
            range: NSRange(text.startIndex..., in: text)
        )

        if let match = matches.first {
            return (0 ..< match.numberOfRanges).compactMap {
                let rangeBounds = match.range(at: $0)
                guard let range = Range(rangeBounds, in: text) else {
                    return nil
                }
                return String(text[range])
            }
        }

        return nil
    }

    static func matches(pattern: String, in text: String) -> Bool {
        if let matches = try? Regex.groups(pattern: pattern, in: text) {
            return matches.isEmpty == false
        }
        return false
    }
}

final class SortProjectFile {
    static let ExtensionLessFiles = [
        "create_hash_table",
        "jsc",
        "minidom",
        "testapi",
        "testjsglue"
    ]

    static let FolderExtensions = [
        "strings"
    ]

    enum Patterns {
        static let mainGroup = #"^(\s*)mainGroup = ([0-9A-F]{24}( /\* .+ \*/)?);$"#
        static let childrenFileName = #"^\s*[A-Z0-9]{24} \/\* (.+) \*\/,"#
        static let filesFileName = #"^\s*[A-Z0-9]{24} \/\* (.+) in "#
        static let fileExtension = #"(.*)\.([^.]+)$"#
        static let unifiedSource = #"^UnifiedSource(\d+)"#
        static let childrenGroup = #"^(\s*)children = \(\s*\n$"#
        static let filesGroup = #"^(\s*)files = \(\s*\n$"#
    }

    enum FileRepresentation {
        case folder(source: String, name: String, extension: String)
        case file(source: String, name: String, extension: String)

        init?(source: String?) {
            guard let source = source else { return nil }

            let groups = Regex.firstMatch(
                pattern: Patterns.fileExtension,
                in: source
            )

            guard let name = groups?[1]
            else {
                self = .folder(source: source, name: source, extension: "")
                return
            }

            let ext = groups?[2] ?? ""

            let isFile: Bool = {
                if ext.isEmpty {
                    return ExtensionLessFiles.contains(source)
                } else {
                    return FolderExtensions.contains(ext) == false
                }
            }()

            if isFile {
                self = .file(source: source, name: name, extension: ext)
            } else {
                self = .folder(source: source, name: name, extension: ext)
            }
        }
    }

    private let fm: FileManager
    private let path: String

    private let tempFilePath: String
    private var tempFileContent: [String]

    private var mainGroup: String

    public init(path: String) {
        self.fm = FileManager.default
        self.path = path
        self.tempFilePath = path + "-XXXXXXXX"
        self.tempFileContent = []
        self.mainGroup = ""
    }

    public func sort() throws {
        guard let reader = FileReader(path: path) else { return }

        try getMainGroup()

        createTempFile()

        var lastTwo = [String]()

        let linesIterator = reader.makeIterator()

        // Split the file into separate lines
        while let line = linesIterator.next() {
            if let groups = Regex.firstMatch(pattern: Patterns.filesGroup, in: line),
               let groupOne: String = groups[safe: 1] {
                addLine(line)

                var endMarker = groupOne

                var files = [String]()
                while let fileLine = linesIterator.next() {
                    if Regex.matches(pattern: #"^\#(endMarker)\);\s*\n"#, in: fileLine) {
                        endMarker = fileLine
                        break
                    }
                    files.append(fileLine)
                }

                files = sort(files: files, pattern: Patterns.filesFileName)
                files.forEach { file in
                    addLine(file)
                }
                addLine(endMarker)
            } else if let groups = Regex.firstMatch(pattern: Patterns.childrenGroup, in: line),
                      let groupOne: String = groups[safe: 1] {
                addLine(line)

                var endMarker = groupOne

                var children = [String]()
                while let childLine = linesIterator.next() {
                    if Regex.matches(pattern: #"^\#(endMarker)\);\s*\n"#, in: childLine) {
                        endMarker = childLine
                        break
                    }
                    children.append(childLine)
                }

                if let line = lastTwo.first, Regex.matches(pattern: #"^\s+\#(mainGroup) = \{\n"#, in: line) {
                    // Don't sort the children
                } else {
                    children = sort(files: children, pattern: Patterns.childrenFileName)
                }

                children.forEach { child in
                    addLine(child)
                }

                addLine(endMarker)
            } else {
                addLine(line)
            }

            lastTwo.append(line)
            if lastTwo.count > 2 {
                _ = lastTwo.removeFirst()
            }
        }

        try saveTempFile(tempFileContent)
        try overrideOriginal()
        try deleteTempFile()
    }

    private func getMainGroup() throws {
        let lines = try String(contentsOfFile: path, encoding: .utf8)
            .split { $0.isNewline }
            .map { String($0) }

        for line in lines {
            let groups = try Regex.groups(pattern: Patterns.mainGroup, in: String(line))
            if groups.isEmpty { continue }
            if let groupTwo = groups.first?[safe: 2] {
                mainGroup = groupTwo
                break
            }
        }
    }

    private func createTempFile() {
        fm.createFile(atPath: tempFilePath, contents: nil, attributes: nil)
    }

    private func saveTempFile(_ lines: [String]) throws {
        let content = lines.joined(separator: "") // \n")
        try content.write(toFile: tempFilePath, atomically: true, encoding: .utf8)
    }

    private func overrideOriginal() throws {
        let fileContent = try String(contentsOfFile: tempFilePath, encoding: .utf8)
        try fileContent.write(toFile: path, atomically: true, encoding: .utf8)
    }

    private func deleteTempFile() throws {
        try fm.removeItem(atPath: tempFilePath)
    }

    private func addLine(_ line: String) {
        tempFileContent.append(line)
    }

    private func sort(files: [String], pattern: String) -> [String] {
        files.sorted { lhsString, rhsString -> Bool in
            guard let lhs = FileRepresentation(
                source: Regex.firstMatch(pattern: pattern, in: lhsString)?[safe: 1]
            ) else { return false }

            guard let rhs = FileRepresentation(
                source: Regex.firstMatch(pattern: pattern, in: rhsString)?[safe: 1]
            ) else { return false }

            switch (lhs, rhs) {
            case (.folder, .file):
                return false

            case let (.file(lhsSource, lhsName, lhsExtension), .file(rhsSource, rhsName, rhsExtension)):
                if let comparison = compareUnifiedSources(lhs: lhsSource, rhs: rhsSource) {
                    return comparison
                }

                if lhsExtension < rhsExtension {
                    return true
                }
                if lhsExtension == rhsExtension {
                    return lhsName.lowercased() < rhsName.lowercased()
                }

                return false

            case (.file, .folder):
                return true

            case let (.folder(_, lhsName, _), .folder(_, rhsNme, _)):
                return lhsName.lowercased() < rhsNme.lowercased()
            }
        }
    }

    private func compareUnifiedSources(lhs: String, rhs: String) -> Bool? {
        guard let lhsNumberString = Regex.firstMatch(
            pattern: Patterns.unifiedSource,
            in: lhs
        )?[safe: 1]
        else { return nil }
        guard let lhsNumber = Int(lhsNumberString) else { return nil }

        guard let rhsNumberString = Regex.firstMatch(
            pattern: Patterns.unifiedSource,
            in: rhs
        )?[safe: 1]
        else { return nil }
        guard let rhsNumber = Int(rhsNumberString) else { return nil }

        return lhsNumber < rhsNumber
    }
}

// MARK: RUN

enum Error: Swift.Error, CustomStringConvertible {
    case missingFileInput
    case argumentNotProjectFile(String)
    case fileNotExists(String)

    var description: String {
        switch self {
        case .missingFileInput:
            return "Missing input, a xcode project file"

        case let .argumentNotProjectFile(path):
            return "WARNING: Not an Xcode project file: '\(path)'"

        case let .fileNotExists(path):
            return "WARNING: Not file exists at path: '\(path)'"
        }
    }
}

do {
    let args = CommandLine.arguments
    let fm = FileManager.default
    let cwdURL = URL(fileURLWithPath: fm.currentDirectoryPath)

    if args.count > 1 {
        var fileURL = URL(fileURLWithPath: args[1], relativeTo: cwdURL)

        if fileURL.pathExtension == "xcodeproj" {
            fileURL.appendPathComponent("project.pbxproj")
        }

        if fileURL.lastPathComponent == "project.pbxproj" {
            if fm.fileExists(atPath: fileURL.path) {
                let tool = SortProjectFile(path: fileURL.path)
                try tool.sort()
            } else {
                throw Error.fileNotExists(fileURL.path)
            }
        } else {
            throw Error.argumentNotProjectFile(fileURL.path)
        }
    } else {
        throw Error.missingFileInput
    }
} catch {
    print("Whoops! An error occurred: \n\(error)")
}
