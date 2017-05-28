import Foundation


public struct Board: CustomStringConvertible {
    
    public var rows: [[Cell]]
    
    public init(boardString: String) {
        let characters = Array(boardString.characters)
        self.rows = (0..<9)
            .map({ rowIndex in
                return characters[rowIndex*9..<rowIndex*9+9]
            })
            .map({ rawRow in
                return rawRow.map({ character in
                    if character == "." {
                        return Cell.anything()
                    } else if let value = Int(String(character)) {
                        return Cell.settled(value)
                    } else {
                        fatalError()
                    }
                })
            })
    }
    
    public var cells: [Cell] {
        return Array(rows.joined())
    }
    
    public var description: String {
        return self.rows
            .map({ row in
                return "[" + row.map({ $0.description }).joined(separator: " ") + "]\n"
            })
            .joined()
    }
    
    public var isSolved: Bool {
        return self.cells.all({ $0.isSettled })
    }
    
    public func row(forIndex index: Int) -> [Cell] {
        let rowIndex = index / 9
        return rows[rowIndex]
    }
    
    public func column(forIndex index: Int) -> [Cell] {
        let columnIndex = index % 9
        return self.rows.map({ row in
            return row[columnIndex]
        })
    }
    
    public func minigrid(forIndex index: Int) -> [Cell] {
        let rowIndex = index / 9
        let columnIndex = index % 9
        let minigridColumnIndex = columnIndex / 3
        let minigridRowIndex = rowIndex / 3
        return (0..<3).flatMap({ rowOffset in
            return self.rows[minigridRowIndex*3+rowOffset][minigridColumnIndex*3..<minigridColumnIndex*3+3]
        })
    }
    
    public func canUpdate(index: Int, toValue value: Int) -> Bool {
        return !self.row(forIndex: index).contains(.settled(value))
            && !self.column(forIndex: index).contains(.settled(value))
            && !self.minigrid(forIndex: index).contains(.settled(value))
    }
    
    public mutating func update(index: Int, values: [Int]) throws {
        if values.count == 1,
            let value = values.first,
            !self.canUpdate(index: index, toValue: value) {
            throw ConsistencyError()
        }
        let newCell = Cell(values: values)
        let rowIndex = index / 9
        let columnIndex = index % 9
        self.rows[rowIndex][columnIndex] = newCell
    }
}

public struct ConsistencyError: Error {
    
}




