import Foundation

public class Solver {
    public var board: Board
    
    public init(board: Board) {
        self.board = board
    }
    
    public var isSolved: Bool {
        return board.isSolved
    }
    
    public func solve() {
        while !isSolved {
            var foundSomethingThisIteration = false
            
            board.cells.enumerated().forEach({ index, cell in
                if cell.isSettled { return }
                
                let possibleValues = (1...9).filter({ value in
                    return board.canUpdate(index: index, toValue: value)
                })
                
                if possibleValues.count == 0 {
                    return
                }
                
                if possibleValues.count == 1 {
                    foundSomethingThisIteration = true
                }
                
                try? board.update(index: index, values: possibleValues)
                
            })
            
            if !foundSomethingThisIteration {
                return
            }
        }
    }
    
    public func bruteForce() {
        self.solve()
        
        if isSolved {
            return
        }
        
        let (index, cell) = board.cells
            .enumerated()
            .sorted(by: { left, right in
                return left.element.values.count < right.element.values.count
            })
            .first(where: { !$0.element.isSettled })!
        
        for value in cell.values {
            
            var copy = self.board
            
            do {
                try copy.update(index: index, values: [value])
                print(copy)
            } catch let error {
                if error is ConsistencyError {
                    continue
                }
            }
            
            let solver = Solver(board: copy)
            solver.bruteForce()
            if solver.isSolved {
                self.board = solver.board
            }
        }
    }
}












