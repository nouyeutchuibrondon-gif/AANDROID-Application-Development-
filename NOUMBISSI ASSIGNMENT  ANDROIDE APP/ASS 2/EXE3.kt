// Step 0: Define the data class
data class Person(val name: String, val age: Int)

fun main() {

    // Step 1: Sample data
    val people = listOf(
        Person("Alice", 25),
        Person("Bob", 30),
        Person("Charlie", 35),
        Person("Anna", 22),
        Person("Ben", 28)
    )

    // Step 2: Filter people whose names start with 'A' or 'B'
    val filtered = people.filter { it.name.startsWith("A") || it.name.startsWith("B") }

    // Step 3: Extract ages
    val ages = filtered.map { it.age }

    // Step 4: Calculate average
    val averageAge = ages.average()

    // Step 5: Print rounded to 1 decimal place
    println("Average age: %.1f".format(averageAge))
}