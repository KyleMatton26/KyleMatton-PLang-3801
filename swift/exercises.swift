import Foundation

struct NegativeAmountError: Error {}
struct NoSuchFileError: Error {}

func change(_ amount: Int) -> Result<[Int:Int], NegativeAmountError> {
    if amount < 0 {
        return .failure(NegativeAmountError())
    }
    var (counts, remaining) = ([Int:Int](), amount)
    for denomination in [25, 10, 5, 1] {
        (counts[denomination], remaining) = 
            remaining.quotientAndRemainder(dividingBy: denomination)
    }
    return .success(counts)
}

func firstThenLowerCase(of array: [String], satisfying predicate: (String) -> Bool) -> String? {
    return array.first(where: predicate)?.lowercased()
}

class PhraseBuilder {
    private let words: [String]
    var phrase: String {
        return words.joined(separator: " ")
    }

    init(initial: String = "") {
        self.words = [initial]
    }
    
    func and(_ word: String) -> PhraseBuilder {
        var newWords = self.words
        newWords.append(word)
        return PhraseBuilder(words: newWords)
    }
    
    private init(words: [String]) {
        self.words = words
    }
}

func say(_ word: String = "") -> PhraseBuilder {
    return PhraseBuilder(initial: word)
}

func meaningfulLineCount(_ filename: String) async -> Result<Int, Error> {
    do {
        let fileURL = URL(fileURLWithPath: filename)
        let fileHandle = try FileHandle(forReadingFrom: fileURL)
        defer {
            try? fileHandle.close()
        }
        
        var count = 0
        for try await line in fileHandle.bytes.lines {
            let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmed.isEmpty && trimmed.first != "#" {
                count += 1
            }
        }
        return .success(count)
    } catch {
        return .failure(error)
    }
}

struct Quaternion: Equatable, CustomStringConvertible {

    let a: Double
    let b: Double
    let c: Double
    let d: Double

    static let ZERO = Quaternion()
    static let I = Quaternion(b: 1.0)
    static let J = Quaternion(c: 1.0)
    static let K = Quaternion(d: 1.0)
    
    init(a: Double = 0.0, b: Double = 0.0, c: Double = 0.0, d: Double = 0.0) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }

    func plus(_ other: Quaternion) -> Quaternion {
        return Quaternion(a: self.a + other.a,
                          b: self.b + other.b,
                          c: self.c + other.c,
                          d: self.d + other.d)
    }
    
    func times(_ other: Quaternion) -> Quaternion {
        let newA = self.a * other.a - self.b * other.b - self.c * other.c - self.d * other.d
        let newB = self.a * other.b + self.b * other.a + self.c * other.d - self.d * other.c
        let newC = self.a * other.c - self.b * other.d + self.c * other.a + self.d * other.b
        let newD = self.a * other.d + self.b * other.c - self.c * other.b + self.d * other.a
        return Quaternion(a: newA, b: newB, c: newC, d: newD)
    }
    
    var conjugate: Quaternion {
        return Quaternion(a: self.a, b: -self.b, c: -self.c, d: -self.d)
    }
    
    var coefficients: [Double] {
        return [a, b, c, d]
    }
    
    static func + (lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        return lhs.plus(rhs)
    }
    
    static func * (lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        return lhs.times(rhs)
    }
    
    var description: String {
        var components: [String] = []
        
        if a != 0 {
            components.append("\(a)")
        }
        
        if b != 0 {
            if b > 0 && !components.isEmpty {
                components.append("+")
            } else if b < 0 && !components.isEmpty {
                components.append("-")
            } else if b < 0 && components.isEmpty {
                components.append("-")
            }
            
            let absB = abs(b)
            if absB != 1 {
                components.append("\(absB)")
            } else if absB == 1 && b < 0 && components.last == "-" {
            }
            
            components.append("i")
        }
        
        if c != 0 {
            if c > 0 && !components.isEmpty {
                components.append("+")
            } else if c < 0 && !components.isEmpty {
                components.append("-")
            } else if c < 0 && components.isEmpty {
                components.append("-")
            }
            
            let absC = abs(c)
            if absC != 1 {
                components.append("\(absC)")
            } else if absC == 1 && c < 0 && components.last == "-" {
            }
            
            components.append("j")
        }
        
        if d != 0 {
            if d > 0 && !components.isEmpty {
                components.append("+")
            } else if d < 0 && !components.isEmpty {
                components.append("-")
            } else if d < 0 && components.isEmpty {
                components.append("-")
            }
            
            let absD = abs(d)
            if absD != 1 {
                components.append("\(absD)")
            } else if absD == 1 && d < 0 && components.last == "-" {
            }
            
            components.append("k")
        }
        
        let result = components.joined()
        return result.isEmpty ? "0" : result
    }
}


indirect enum BinarySearchTree: Equatable, CustomStringConvertible {
    case empty
    case node(left: BinarySearchTree, value: String, right: BinarySearchTree)
    
    func insert(_ newValue: String) -> BinarySearchTree {
        switch self {
        case .empty:
            return .node(left: .empty, value: newValue, right: .empty)
            
        case .node(let left, let value, let right):
            if newValue < value {
                let newLeft = left.insert(newValue)
                return .node(left: newLeft, value: value, right: right)
            } else if newValue > value {
                let newRight = right.insert(newValue)
                return .node(left: left, value: value, right: newRight)
            } else {
                return self
            }
        }
    }
    
    func contains(_ target: String) -> Bool {
        switch self {
        case .empty:
            return false
        case .node(let left, let value, let right):
            if target == value {
                return true
            } else if target < value {
                return left.contains(target)
            } else {
                return right.contains(target)
            }
        }
    }
    
    var size: Int {
        switch self {
        case .empty:
            return 0
        case .node(let left, _, let right):
            return left.size + 1 + right.size
        }
    }
    
    var description: String {
        switch self {
        case .empty:
            return "()"
        case .node(let left, let value, let right):
            switch (left, right) {
            case (.empty, .empty):
                return "(\(value))"
            case (.empty, _):
                return "(\(value)\(right.description))"
            case (_, .empty):
                return "(\(left.description)\(value))"
            default:
                return "(\(left.description)\(value)\(right.description))"
            }
        }
    }
}
