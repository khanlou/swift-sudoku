import Foundation


public struct Board: CustomStringConvertible {
    
    public var rows: [[Cell]]
    
    public init(boardString: String) {
        let characters = Array(boardString).filter({ !$0.isNewline })
        self.rows = (0..<9)
            .map({ rowIndex in
                return characters[rowIndex*9..<rowIndex*9+9]
            })
            .map({ rawRow in
                return rawRow.compactMap({ character in
                    if character == "." {
                        return Cell.anything()
                    } else if let value = Int(String(character)) {
                        return Cell.settled(value)
                    } else {
                        return nil
                    }
                })
            })
    }
    
    public var cells: some Collection<Cell> {
        return rows.joined()
    }
    
    public var description: String {
        return self.rows
            .map({ row in
                return "[" + row.map({ $0.description }).joined(separator: " ") + "]\n"
            })
            .joined()
    }
    
    public var isSolved: Bool {
        return self.cells.allSatisfy({ $0.isSettled })
    }
    
    public func row(forIndex index: Int) -> some Collection<Cell> {
        let rowIndex = index / 9
        return rows[rowIndex]
    }
    
    public func column(forIndex index: Int) -> some Collection<Cell> {
        let columnIndex = index % 9
        return self.rows.lazy.map({ row in
            return row[columnIndex]
        })
    }
    
    public func box(forIndex index: Int) -> some Collection<Cell> {
        let rowIndex = index / 9
        let columnIndex = index % 9
        let boxColumnIndex = columnIndex / 3
        let boxRowIndex = rowIndex / 3
        return (0..<3).lazy.flatMap({ rowOffset in
            return self.rows[boxRowIndex*3+rowOffset][boxColumnIndex*3..<boxColumnIndex*3+3]
        })
    }
    
    public func canUpdate(index: Int, toValue value: Int) -> Bool {
        return !self.row(forIndex: index).contains(.settled(value))
            && !self.column(forIndex: index).contains(.settled(value))
            && !self.box(forIndex: index).contains(.settled(value))
    }
    
    public mutating func update(index: Int, values: [Int]) {
        let newCell = Cell(values: values)
        let rowIndex = index / 9
        let columnIndex = index % 9
        self.rows[rowIndex][columnIndex] = newCell
    }
}
