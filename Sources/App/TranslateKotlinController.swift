import Vapor
import Transform
import SwiftKotlinFramework
import Cocoa

/// Here we have a controller that helps facilitate
/// creating typical REST patterns
final class TranslateKotlinController {
    /// POST /translate
    func store(_ req: Request)  throws -> Future<View> {
        let x = req.http.body.description.removingPercentEncoding?.replacingOccurrences(of: "+", with: " ", options: .literal, range: nil).replacingOccurrences(of: "swift=", with: "", options: .literal, range: nil)
        
        let swift = x ?? "var jsonHeaderLogString = \"JSON Header: responseCode = \\(String(describing: responseCode)); \""
        let translation = translate(swift: swift)
        return try req.view().render("translate", [
            "output": translation
            ])
    }
    
    func translate(swift:String) -> String{
        let kotlinTokenizer = KotlinTokenizer(tokenTransformPlugins: [
            XCTTestToJUnitTokenTransformPlugin(),
            FoundationMethodsTransformPlugin()])
        
        let result = kotlinTokenizer.translate(content: swift)
        guard let kotlinTokens = result.tokens else {
            return ""
        }
        return attributedStringFromTokens(tokens: kotlinTokens).string
        
    }
    
    func attributedStringFromTokens(tokens: [Token]) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString()
        tokens.forEach {
            attributedString.append(NSAttributedString(string: $0.value, attributes: attributes(token:$0)))
        }
        return attributedString
    }
    
    func attributes(token:Token) -> [NSAttributedStringKey : Any] {
        switch token.kind {
        case .keyword:
            return [NSAttributedStringKey.foregroundColor: NSColor(red: 170.0/255.0, green: 13.0/255.0, blue: 145.0/255.0, alpha: 1)]
        case .number, .string:
            return [NSAttributedStringKey.foregroundColor: NSColor(red: 0, green: 116.0/255.0, blue: 0, alpha: 1)]
        case .comment:
            return [NSAttributedStringKey.foregroundColor: NSColor(red: 196.0/255.0, green: 26.0/255.0, blue: 22.0/255.0, alpha: 1)]
        default:
            return [:]
        }
    }
}


