import Foundation

public struct InvalidBoard: Error {

}

public class Solver {
    public var board: Board
    
    public init(board: Board) {
        self.board = board
    }
    
    public var isSolved: Bool {
        return board.isSolved
    }
    
    public func solve() throws {
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
                    throw InvalidBoard()
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

    public func bruteForce() throws {
        try self.solve()

        if isSolved {
            return
        }

        let (offset, cell) = board.cells
            .enumerated()
            .sorted(by: { $0.1.values.count < $1.1.values.count })
            .first(where: { !$0.1.isSettled })!

        for value in cell.values {
            var copy = board
            copy.update(index: offset, values: [value])

            do {
                let solver = Solver(board: copy)
                try solver.bruteForce()
                if solver.isSolved {
                    self.board = solver.board
                    return
                }
            } catch is InvalidBoard {

            }
        }
    }

}
