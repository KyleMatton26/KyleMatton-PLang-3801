import java.io.BufferedReader
import java.io.FileReader
import java.io.IOException

fun change(amount: Long): Map<Int, Long> {
    require(amount >= 0) { "Amount cannot be negative" }
    val counts = mutableMapOf<Int, Long>()
    var remaining = amount
    for (denomination in listOf(25, 10, 5, 1)) {
        counts[denomination] = remaining / denomination
        remaining %= denomination
    }
    return counts
}
fun firstThenLowerCase(a: List<String>, p: (String) -> Boolean): String? {
    return a.firstOrNull { p(it) }?.lowercase()
}
class PhraseBuilder private constructor(private val words: List<String>) {
    val phrase: String
        get() = words.joinToString(" ")
    constructor(initial: String = "") : this(listOf(initial))
    fun and(word: String): PhraseBuilder {
        return PhraseBuilder(this.words + word)
    }
}

fun say(word: String = ""): PhraseBuilder {
    return PhraseBuilder(word)
}
@Throws(IOException::class)
fun meaningfulLineCount(filename: String): Long {
    BufferedReader(FileReader(filename)).use { reader ->
        return reader.lineSequence()
                .filter { line ->
                    val trimmedLine = line.trimStart()
                    trimmedLine.isNotEmpty() && trimmedLine.firstOrNull() != '#'
                }
                .count()
                .toLong()
    }
}

data class Quaternion(val a: Double, val b: Double, val c: Double, val d: Double) {
    operator fun plus(other: Quaternion): Quaternion {
        return Quaternion(
                a = this.a + other.a,
                b = this.b + other.b,
                c = this.c + other.c,
                d = this.d + other.d
        )
    }
    operator fun times(other: Quaternion): Quaternion {
        return Quaternion(
                a = this.a * other.a - this.b * other.b - this.c * other.c - this.d * other.d,
                b = this.a * other.b + this.b * other.a + this.c * other.d - this.d * other.c,
                c = this.a * other.c - this.b * other.d + this.c * other.a + this.d * other.b,
                d = this.a * other.d + this.b * other.c - this.c * other.b + this.d * other.a
        )
    }
    fun coefficients(): List<Double> {
        return listOf(a, b, c, d)
    }
    fun conjugate(): Quaternion {
        return Quaternion(a, -b, -c, -d)
    }
    override fun toString(): String {
        if (a == 0.0 && b == 0.0 && c == 0.0 && d == 0.0) {
            return "0"
        }
        val parts = mutableListOf<String>()
        if (a != 0.0) {
            parts.add(a.toString())
        }
        fun appendComponent(coef: Double, unit: String) {
            when {
                coef > 0 -> {
                    if (parts.isNotEmpty()) {
                        parts.add("+")
                    }
                    if (coef == 1.0) {
                        parts.add(unit)
                    } else {
                        parts.add("${coef}$unit")
                    }
                }
                coef < 0 -> {
                    if (coef == -1.0) {
                        parts.add("-$unit")
                    } else {
                        parts.add("${coef}$unit")
                    }
                }
                else -> {}
            }
        }
        appendComponent(b, "i")
        appendComponent(c, "j")
        appendComponent(d, "k")
        return parts.joinToString("")
    }
    companion object {
        val ZERO = Quaternion(0.0, 0.0, 0.0, 0.0)
        val I = Quaternion(0.0, 1.0, 0.0, 0.0)
        val J = Quaternion(0.0, 0.0, 1.0, 0.0)
        val K = Quaternion(0.0, 0.0, 0.0, 1.0)
    }
}
sealed interface BinarySearchTree {
    fun insert(value: String): BinarySearchTree
    fun contains(value: String): Boolean
    fun size(): Int
    override fun toString(): String
    object Empty : BinarySearchTree {
        override fun insert(value: String): BinarySearchTree = Node(Empty, value, Empty)
        override fun contains(value: String): Boolean = false
        override fun size(): Int = 0
        override fun toString(): String = "()"
    }
    data class Node(
            private val left: BinarySearchTree,
            val value: String,
            private val right: BinarySearchTree
    ) : BinarySearchTree {
        override fun insert(value: String): BinarySearchTree {
            return when {
                value < this.value -> Node(left.insert(value), this.value, right)
                value > this.value -> Node(left, this.value, right.insert(value))
                else -> this
            }
        }
        override fun contains(value: String): Boolean {
            return when {
                value < this.value -> left.contains(value)
                value > this.value -> right.contains(value)
                else -> true
            }
        }
        override fun size(): Int = 1 + left.size() + right.size()
        override fun toString(): String = when {
            left is Empty && right is Empty -> "($value)"
            left is Empty -> "($value${right.toString()})"
            right is Empty -> "(${left.toString()}$value)"
            else -> "(${left.toString()}$value${right.toString()})"
        }
    }
}

