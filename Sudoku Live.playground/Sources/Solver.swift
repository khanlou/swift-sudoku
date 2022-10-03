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
            for (offset, cell) in board.cells.enumerated() {
                if cell.isSettled {
                    continue
                }

                let possibleValues = (1...9).filter({ value in
                    return board.canUpdate(index: offset, toValue: value)
                })

                if possibleValues.isEmpty {
                    return // something has gone really wrong
                }

                if possibleValues.count == 1 {
                    foundSomethingThisIteration = true
                }

                board.update(index: offset, values: possibleValues)
            }

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

        let (offset, cell) = board.cells
            .enumerated()
            .sorted(by: { $0.1.values.count < $1.1.values.count })
            .first(where: { !$0.1.isSettled })!

        for value in cell.values {
            var copy = board
            if board.canUpdate(index: offset, toValue: value) {
                copy.update(index: offset, values: [value])
            } else {
                continue
            }

            let solver = Solver(board: copy)
            solver.bruteForce()
            if solver.isSolved {
                self.board = solver.board
                return
            }
        }
    }

}
