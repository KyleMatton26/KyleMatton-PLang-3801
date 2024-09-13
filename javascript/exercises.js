import { open } from "node:fs/promises"
import readFile from "readline/promises"

export function change(amount) {
  if (!Number.isInteger(amount)) {
    throw new TypeError("Amount must be an integer")
  }
  if (amount < 0) {
    throw new RangeError("Amount cannot be negative")
  }
  let [counts, remaining] = [{}, amount]
  for (const denomination of [25, 10, 5, 1]) {
    counts[denomination] = Math.floor(remaining / denomination)
    remaining %= denomination
  }
  return counts
}

// Write your first then lower case function here
export function firstThenLowerCase(array, predicate) {
  const foundElement = array.find(predicate);
  return foundElement?.toLowerCase();
}

// Write your powers generator here
export function* powersGenerator({ ofBase: base, upTo: limit }) {
  let power = 1;
  while (power <= limit) {
    yield power;
    power *= base;
  }
}

// Write your say function here
export function say(word) {
  const collectWords = (function () {
    let words = [];
    return function (nextWord) {
      if (nextWord === undefined) {
        return words.join(' ');
      } else {
        words.push(nextWord);
        return collectWords;
      }
    };
  })();

  return word === undefined ? collectWords() : collectWords(word);
}

// Write your line count function here
import { promises as fs } from 'fs';

export async function meaningfulLineCount(filename) {
  try {
    const data = await fs.readFile(filename, 'utf8');
    const lines = data.split('\n');

    const count = lines.filter(line => {
      const trimmed = line.trim();
      return trimmed !== '' && !trimmed.startsWith('#');
    }).length;

    return count;
  } catch (error) {
    throw new Error(`Error reading file: ${error.message}`);
  }
}
// Write your Quaternion class here

class Quaternion {
  constructor(a, b, c, d) {
    Object.defineProperties(this, {
      a: { value: a, writable: false },
      b: { value: b, writable: false },
      c: { value: c, writable: false },
      d: { value: d, writable: false }
    });
    Object.freeze(this);
  }

  get coefficients() {
    return [this.a, this.b, this.c, this.d];
  }

  get conjugate() {
    return new Quaternion(this.a, -this.b, -this.c, -this.d);
  }

  plus(other) {
    return new Quaternion(
      this.a + other.a,
      this.b + other.b,
      this.c + other.c,
      this.d + other.d
    );
  }

  times(other) {
    return new Quaternion(
      this.a * other.a - this.b * other.b - this.c * other.c - this.d * other.d,
      this.a * other.b + this.b * other.a + this.c * other.d - this.d * other.c,
      this.a * other.c - this.b * other.d + this.c * other.a + this.d * other.b,
      this.a * other.d + this.b * other.c - this.c * other.b + this.d * other.a
    );
  }

  toString() {
    const terms = [];
    if (this.a !== 0) terms.push(`${this.a}`);
    if (this.b !== 0) terms.push(`${this.b === 1 ? '' : this.b === -1 ? '-' : this.b}i`);
    if (this.c !== 0) terms.push(`${this.c === 1 ? '' : this.c === -1 ? '-' : this.c}j`);
    if (this.d !== 0) terms.push(`${this.d === 1 ? '' : this.d === -1 ? '-' : this.d}k`);
    return terms.length ? terms.join('+').replace(/\+-/g, '-') : '0';
  }
}

export { Quaternion };

