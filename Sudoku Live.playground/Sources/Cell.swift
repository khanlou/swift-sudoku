import Foundation

public struct Cell: Equatable, CustomStringConvertible {
    
    public let values: [Int]
    
    public var isSettled: Bool {
        return values.count == 1
    }
    
    public static func == (lhs: Cell, rhs: Cell) -> Bool {
        return lhs.values == rhs.values
    }
    
    public var description: String {
        if isSettled, let first = values.first {
            return String(first)
        }
        return "_"
    }
    
    public static func settled(_ value: Int) -> Cell {
        return Cell(values: [value])
    }
    
    public static func anything() -> Cell {
        return Cell(values: Array(1...9))
    }
}
