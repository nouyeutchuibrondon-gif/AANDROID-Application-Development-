fun main() {

    val words = listOf("apple", "cat", "banana", "dog", "elephant")

    words
        .associateWith { it.length }     // Create map: word -> length
        .filter { it.value > 4 }         // Keep only length > 4
        .forEach { (word, length) ->
            println("$word has length $length")
        }
}