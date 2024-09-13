from dataclasses import dataclass
from collections.abc import Callable


def change(amount: int) -> dict[int, int]:
    if not isinstance(amount, int):
        raise TypeError('Amount must be an integer')
    if amount < 0:
        raise ValueError('Amount cannot be negative')
    counts, remaining = {}, amount
    for denomination in (25, 10, 5, 1):
        counts[denomination], remaining = divmod(remaining, denomination)
    return counts


# Write your first then lower case function here

def first_then_lower_case(a, p):
    for s in a:
        if p(s):
            return s.lower()
    return None


# Write your powers generator here

def powers_generator(base, limit):
    power = 1 
    while power <= limit:
        yield power
        power *= base


# Write your say function here

def say(word=None, accumulated=""):
    if word is None:
        return accumulated.strip()
    
    if accumulated:
        if word:
            accumulated += " " + word
        else:
            accumulated += " "
    else:
        accumulated = word

    return lambda next_word=None: say(next_word, accumulated)


# Write your line count function here

def meaningful_line_count(filename):
    try:
        file = open(filename, 'r')
        count = 0
        for line in file:
            line = line.strip()
            if line and not line.startswith('#'):
                count += 1

        file.close() 
        return count
    
    except FileNotFoundError:
        raise FileNotFoundError("No such file") 



# Write your Quaternion class here
@dataclass(frozen=True)
class Quaternion:
    a: float
    b: float
    c: float
    d: float

    @property
    def coefficients(self):
        return (self.a, self.b, self.c, self.d)

    @property
    def conjugate(self):
        return Quaternion(self.a, -self.b, -self.c, -self.d)

    def __add__(self, other):
        if isinstance(other, Quaternion):
            return Quaternion(
                self.a + other.a,
                self.b + other.b,
                self.c + other.c,
                self.d + other.d
            )
        return NotImplemented

    def __mul__(self, other):
        if isinstance(other, Quaternion):
            a = self.a * other.a - self.b * other.b - self.c * other.c - self.d * other.d
            b = self.a * other.b + self.b * other.a + self.c * other.d - self.d * other.c
            c = self.a * other.c - self.b * other.d + self.c * other.a + self.d * other.b
            d = self.a * other.d + self.b * other.c - self.c * other.b + self.d * other.a
            return Quaternion(a, b, c, d)
        return NotImplemented

    def __eq__(self, other):
        if isinstance(other, Quaternion):
            return (self.a, self.b, self.c, self.d) == (other.a, other.b, other.c, other.d)
        return False

    def __str__(self):
        terms = []
        if self.a != 0 or not any([self.b, self.c, self.d]):
            terms.append(f"{self.a}")
        if self.b != 0:
            if self.b == 1:
                terms.append("i")
            elif self.b == -1:
                terms.append("-i")
            else:
                terms.append(f"{self.b}i")
        
        if self.c != 0:
            if self.c == 1:
                terms.append("j")
            elif self.c == -1:
                terms.append("-j")
            else:
                terms.append(f"{self.c}j")
        
        if self.d != 0:
            if self.d == 1:
                terms.append("k")
            elif self.d == -1:
                terms.append("-k")
            else:
                terms.append(f"{self.d}k")
        
        result = "".join(terms)
        result = result.replace('+-', '-').lstrip('+')
        return result if result else "0"