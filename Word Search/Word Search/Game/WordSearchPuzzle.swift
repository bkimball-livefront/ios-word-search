//
//  WordSearchPuzzle.swift
//  Word Search
//

import Foundation

let gridSize = 6
let puzzleWords = ["CAT", "MOUSE", "DOG", "MOOSE"]

struct Position: Hashable {
    let row: Int
    let col: Int
}

struct PlacedWord {
    let word: String
    let positions: [Position]
}

struct WordSearchPuzzle {
    let grid: [[Character]]
    let placedWords: [PlacedWord]
}

private let directions: [(rowDelta: Int, colDelta: Int)] = [
    (0, 1), (0, -1),
    (1, 0), (-1, 0),
    (1, 1), (-1, -1),
    (1, -1), (-1, 1),
]

private let letters = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")

func generatePuzzle() -> WordSearchPuzzle {
    while true {
        var grid = Array(repeating: Array<Character?>(repeating: nil, count: gridSize), count: gridSize)
        var placedWords: [PlacedWord] = []
        var failed = false

        for word in puzzleWords.sorted(by: { $0.count > $1.count }) {
            guard let placement = findPlacement(grid: grid, word: word) else {
                failed = true
                break
            }
            let characters = Array(word)
            for (index, position) in placement.enumerated() {
                grid[position.row][position.col] = characters[index]
            }
            placedWords.append(PlacedWord(word: word, positions: placement))
        }

        if failed { continue }

        let filledGrid = grid.map { row in
            row.map { $0 ?? letters.randomElement()! }
        }
        return WordSearchPuzzle(grid: filledGrid, placedWords: placedWords)
    }
}

private func findPlacement(grid: [[Character?]], word: String) -> [Position]? {
    let characters = Array(word)
    var candidates: [[Position]] = []

    for direction in directions {
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                let positions = (0..<characters.count).map { i in
                    Position(row: row + direction.rowDelta * i, col: col + direction.colDelta * i)
                }
                let inBounds = positions.allSatisfy {
                    $0.row >= 0 && $0.row < gridSize && $0.col >= 0 && $0.col < gridSize
                }
                guard inBounds else { continue }

                let fits = positions.enumerated().allSatisfy { index, position in
                    let existing = grid[position.row][position.col]
                    return existing == nil || existing == characters[index]
                }
                if fits {
                    candidates.append(positions)
                }
            }
        }
    }

    return candidates.randomElement()
}
