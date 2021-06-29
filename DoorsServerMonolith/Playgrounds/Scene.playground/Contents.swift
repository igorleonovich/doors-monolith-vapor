import Foundation

let file = "scene.md" //this is the file. we will write to and read from it

struct MarkdownPoint {
    let text: String
    
    var markdownRepresentation: String {
        return "* \(text)"
    }
}

let markdownPointScene = MarkdownPoint(text: "Scene")
let markdownPointCurrentScene = MarkdownPoint(text: "Current Scene")

if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

    let fileURL = dir.appendingPathComponent(file)

    //writing
    do {
        try text.write(to: fileURL, atomically: false, encoding: .utf8)
    }
    catch {/* error handling here */}

    //reading
    do {
        let text2 = try String(contentsOf: fileURL, encoding: .utf8)
    }
    catch {/* error handling here */}
}
