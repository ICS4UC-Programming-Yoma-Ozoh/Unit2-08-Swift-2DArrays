import Foundation

/**
 * Generates an array of random sorted numbers and performs
 * a linear search based on user input.
 *
 * @author  Yoma Ozoh
 * @version 1.0
 * @since   2026-10-28
 */
/// Main function to execute file reading and mark generation.
func main() {
    let studentFileName = "Unit2-08-students.txt"
    let assignmentFileName = "Unit2-08-assignments.txt"
    let csvFileName = "Unit2-08-marks.csv"

    // Read student names from text file into an array
    guard let studentContent = try? String(contentsOfFile: studentFileName, encoding: .utf8) else {
        print("Error: Could not read \(studentFileName)")
        return
    }
    let studentArray = studentContent
        .components(separatedBy: .newlines)
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        .filter { !$0.isEmpty }

    // Read assignment names from text file into an array
    guard let assignmentContent = try? String(contentsOfFile: assignmentFileName, encoding: .utf8) else {
        print("Error: Could not read \(assignmentFileName)")
        return
    }
    let assignmentsArray = assignmentContent
        .components(separatedBy: .newlines)
        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        .filter { !$0.isEmpty }

    // Call generateMarks function
    let marksArray = generateMarks(studentArray: studentArray, assignmentsArray: assignmentsArray)

    // Output results to marks.csv file
    var csvText = ""
    for row in marksArray {
        csvText += row.joined(separator: ",") + "\n"
    }

    do {
        try csvText.write(toFile: csvFileName, atomically: true, encoding: .utf8)
        print("File marks.csv generated successfully!")
    } catch {
        print("Error writing to \(csvFileName): \(error.localizedDescription)")
    }
}

/// Generates random marks for each student and assignment.
///
/// - Parameters:
///   - studentArray: Array of student names
///   - assignmentsArray: Array of assignment names
/// - Returns: 2D array containing student names and marks
func generateMarks(studentArray: [String], assignmentsArray: [String]) -> [[String]] {
    let rowCount = studentArray.count + 1
    let colCount = assignmentsArray.count + 1

    // Initialize 2D array filled with empty strings
    var marksArray = Array(repeating: Array(repeating: "", count: colCount), count: rowCount)

    // Top-left corner
    marksArray[0][0] = "Student"

    // Header row: populate assignment titles
    for i in 0..<assignmentsArray.count {
        marksArray[0][i + 1] = assignmentsArray[i]
    }

    // Student rows: populate student name & random marks
    for j in 0..<studentArray.count {
        marksArray[j + 1][0] = studentArray[j]

        for i in 0..<assignmentsArray.count {
            // Box-Muller transform to generate Gaussian distributed numbers
            let u1 = Double.random(in: 0.0001...1.0)
            let u2 = Double.random(in: 0.0001...1.0)
            let normalRandom = sqrt(-2.0 * log(u1)) * cos(2.0 * .pi * u2)

            // Generate mark with mean = 75, std dev = 10
            let rawMark = normalRandom * 10.0 + 75.0
            let mark = Int(round(rawMark))

            // Save integer mark as string in 2D array
            marksArray[j + 1][i + 1] = String(mark)
        }
    }

    return marksArray
}

// Run the main program
main()