import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Optional;
import java.util.function.Predicate;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

public class Exercises {
    static Map<Integer, Long> change(long amount) {
        if (amount < 0) {
            throw new IllegalArgumentException("Amount cannot be negative");
        }
        var counts = new HashMap<Integer, Long>();
        for (var denomination : List.of(25, 10, 5, 1)) {
            counts.put(denomination, amount / denomination);
            amount %= denomination;
        }
        return counts;
    }

    public static Optional<String> firstThenLowerCase(List<String> a, Predicate<String> p) {
        return a.stream()
            .filter(p)
            .map(String::toLowerCase)
            .findFirst();
    }

    public static PhraseBuilder say() {
        return new PhraseBuilder();
    }

    public static PhraseBuilder say(String word) {
        return new PhraseBuilder(word);
    }

    public static class PhraseBuilder {
        private final List<String> words;

        public PhraseBuilder() {
            this.words = new ArrayList<>();
        }

        public PhraseBuilder(String word) {
            this.words = new ArrayList<>();
            this.words.add(word);
        }

        private PhraseBuilder(List<String> words) {
            this.words = words;
        }

        public PhraseBuilder and(String word) {
            List<String> newWords = new ArrayList<>(this.words);
            newWords.add(word);
            return new PhraseBuilder(newWords);
        }

        public String phrase() {
            return String.join(" ", words);
        }
    }

    public static int meaningfulLineCount(String filename) throws IOException {
        try (BufferedReader reader = new BufferedReader(new FileReader(filename))) {
            return (int) reader.lines()
                    .filter(line -> {
                        String trimmed = line.trim();
                        return !trimmed.isEmpty() && trimmed.charAt(0) != '#';
                    })
                    .count();
        }
    }
}

record Quaternion(double a, double b, double c, double d) {

    public Quaternion {
        if (Double.isNaN(a) || Double.isNaN(b) || Double.isNaN(c) || Double.isNaN(d)) {
            throw new IllegalArgumentException("Coefficients cannot be NaN");
        }
    }

    public Quaternion plus(Quaternion other) {
        return new Quaternion(
            this.a + other.a,
            this.b + other.b,
            this.c + other.c,
            this.d + other.d
        );
    }

    public Quaternion times(Quaternion other) {
        double a1 = this.a, b1 = this.b, c1 = this.c, d1 = this.d;
        double a2 = other.a, b2 = other.b, c2 = other.c, d2 = other.d;
        double newA = a1 * a2 - b1 * b2 - c1 * c2 - d1 * d2;
        double newB = a1 * b2 + b1 * a2 + c1 * d2 - d1 * c2;
        double newC = a1 * c2 - b1 * d2 + c1 * a2 + d1 * b2;
        double newD = a1 * d2 + b1 * c2 - c1 * b2 + d1 * a2;

        return new Quaternion(newA, newB, newC, newD);
    }

    public Quaternion conjugate() {
        return new Quaternion(a, -b, -c, -d);
    }

    public List<Double> coefficients() {
        return List.of(a, b, c, d);
    }

    public static final Quaternion ZERO = new Quaternion(0.0, 0.0, 0.0, 0.0);
    public static final Quaternion I = new Quaternion(0.0, 1.0, 0.0, 0.0);
    public static final Quaternion J = new Quaternion(0.0, 0.0, 1.0, 0.0);
    public static final Quaternion K = new Quaternion(0.0, 0.0, 0.0, 1.0);

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();

        if (a != 0) {
            sb.append(a);
        }

        sb.append(formatComponent(b, 'i', sb.length()));
        sb.append(formatComponent(c, 'j', sb.length()));
        sb.append(formatComponent(d, 'k', sb.length()));

        if (sb.length() == 0) {
            return "0";
        }

        return sb.toString();
    }

    private String formatComponent(double value, char symbol, int currentLength) {
        if (value == 0) {
            return "";
        }

        StringBuilder component = new StringBuilder();

        if (currentLength > 0 && value > 0) {
            component.append('+');
        } else if (value < 0 && currentLength > 0) {
            component.append('-');
        } else if (value < 0 && currentLength == 0) {
            component.append('-');
        }

        double absValue = Math.abs(value);
        if (absValue != 1) {
            component.append(absValue);
        } else if (value == -1 && currentLength > 0) {
        }

        component.append(symbol);
        return component.toString();
    }
}

sealed interface BinarySearchTree permits Empty, Node {
    int size();
    boolean contains(String key);
    BinarySearchTree insert(String key);
    String toString();
}

final class Empty implements BinarySearchTree {

    @Override
    public int size() {
        return 0;
    }

    @Override
    public boolean contains(String key) {
        return false;
    }

    @Override
    public BinarySearchTree insert(String key) {
        return new Node(key, this, this);
    }

    @Override
    public String toString() {
        return "()";
    }
}

final class Node implements BinarySearchTree {
    private final String key;
    private final BinarySearchTree left;
    private final BinarySearchTree right;

    public Node(String key, BinarySearchTree left, BinarySearchTree right) {
        this.key = key;
        this.left = left;
        this.right = right;
    }

    @Override
    public int size() {
        return 1 + left.size() + right.size();
    }

    @Override
    public boolean contains(String key) {
        int cmp = key.compareTo(this.key);
        if (cmp == 0) {
            return true;
        } else if (cmp < 0) {
            return left.contains(key);
        } else {
            return right.contains(key);
        }
    }

    @Override
    public BinarySearchTree insert(String key) {
        int cmp = key.compareTo(this.key);
        if (cmp == 0) {
            return this; 
        } else if (cmp < 0) {
            return new Node(this.key, left.insert(key), right);
        } else {
            return new Node(this.key, left, right.insert(key));
        }
    }

    @Override
    public String toString() {
        String leftStr = left instanceof Empty ? "" : left.toString();
        String rightStr = right instanceof Empty ? "" : right.toString();
        return "(" + leftStr + key + rightStr + ")";
    }
}

