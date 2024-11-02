import { open } from "node:fs/promises"
import { createReadStream, ReadStream } from 'fs';
import { createInterface, Interface } from 'readline';

export function change(amount: bigint): Map<bigint, bigint> {
  if (amount < 0) {
    throw new RangeError("Amount cannot be negative")
  }
  let counts: Map<bigint, bigint> = new Map()
  let remaining = amount
  for (const denomination of [25n, 10n, 5n, 1n]) {
    counts.set(denomination, remaining / denomination)
    remaining %= denomination
  }
  return counts
}

export function firstThenApply<A, B>(
  a: A[],
  p: (x: A) => boolean,
  f: (x: A) => B
): B | undefined {
  for (let i = 0; i < a.length; i++) {
    const element: A = a[i];
    if (p(element)) {
      return f(element);
    }
  }
  return undefined;
}

export function* powersGenerator(b: bigint): Generator<bigint, never, unknown> {
  let exponent: number = 0;
  let currentPower: bigint = 1n; 

  while (true) {
    yield currentPower;
    currentPower *= b; 
    exponent += 1;
  }
}

export async function meaningfulLineCount(filePath: string): Promise<number> {
  return new Promise<number>((resolve, reject) => {
    let count: number = 0;

    let readStream: ReadStream;
    try {
      readStream = createReadStream(filePath, { encoding: 'utf8' });
    } catch (error: unknown) {
      reject(error);
      return;
    }

    const rl: Interface = createInterface({
      input: readStream,
      crlfDelay: Infinity,
    });

    rl.on('line', (line: string) => {
      const trimmedLine: string = line.trim();

      if (trimmedLine.length === 0 || trimmedLine.startsWith('#')) {
        return;
      }

      count += 1;
    });

    rl.on('error', (error: Error) => {
      reject(error);
    });

    rl.on('close', () => {
      resolve(count);
    });
  });
}

export type Shape = Sphere | Box;

export interface Sphere {
  readonly kind: "Sphere";
  readonly radius: number;
}

export interface Box {
  readonly kind: "Box";
  readonly width: number;
  readonly length: number;
  readonly depth: number;
}

export function volume(shape: Shape): number {
  switch (shape.kind) {
    case "Sphere":
      return (4 / 3) * Math.PI * Number(shape.radius ** 3);
    case "Box":
      return Number(shape.width) * Number(shape.length) * Number(shape.depth);
    default:
      throw new Error(`Unknown shape kind: ${(shape as any).kind}`);
  }
}

export function surfaceArea(shape: Shape): number {
  switch (shape.kind) {
    case "Sphere":
      return 4 * Math.PI * Number(shape.radius ** 2);
    case "Box":
      const { width, length, depth } = shape;
      return 2 * (Number(width * length) + Number(width * depth) + Number(length * depth));
    default:
      throw new Error(`Unknown shape kind: ${(shape as any).kind}`);
  }
}

export function toStringShape(shape: Shape): string {
  switch (shape.kind) {
    case "Sphere":
      return `Sphere(radius=${shape.radius})`;
    case "Box":
      return `Box(width=${shape.width}, length=${shape.length}, depth=${shape.depth})`;
    default:
      throw new Error(`Unknown shape kind: ${(shape as any).kind}`);
  }
}

export function equals(shape1: Shape, shape2: Shape): boolean {
  if (shape1.kind !== shape2.kind) {
    return false;
  }

  switch (shape1.kind) {
    case "Sphere":
      return shape1.radius === (shape2 as Sphere).radius;
    case "Box":
      return (
        shape1.width ===(shape2 as Box).width &&
        shape1.length === (shape2 as Box).length &&
        shape1.depth === (shape2 as Box).depth
      );
    default:
      return false;
  }
}


export type BinarySearchTree<T extends Comparable> = Empty<T> | Node<T>;

type Comparable = number | string | boolean;

export class Empty<T extends Comparable> {
  constructor() {}

  insert(value: T): BinarySearchTree<T> {
    return new Node<T>(value, new Empty<T>(), new Empty<T>());
  }

  contains(value: T): boolean {
    return false;
  }

  size(): number {
    return 0;
  }

  *inorder(): Generator<T, void, unknown> {
    return;
  }

  toString(): string {
    return "()";
  }
}

class Node<T extends Comparable> {
  public readonly value: T;
  public readonly left: BinarySearchTree<T>;
  public readonly right: BinarySearchTree<T>;

  constructor(value: T, left: BinarySearchTree<T>, right: BinarySearchTree<T>) {
    this.value = value;
    this.left = left;
    this.right = right;
  }

  insert(value: T): BinarySearchTree<T> {
    if (value < this.value) {
      return new Node<T>(this.value, this.left.insert(value), this.right);
    } else if (value > this.value) {
      return new Node<T>(this.value, this.left, this.right.insert(value));
    } else {
      return this;
    }
  }

  contains(value: T): boolean {
    if (value === this.value) {
      return true;
    } else if (value < this.value) {
      return this.left.contains(value);
    } else {
      return this.right.contains(value);
    }
  }

  size(): number {
    return 1 + this.left.size() + this.right.size();
  }

  *inorder(): Generator<T, void, unknown> {
    yield* this.left.inorder();
    yield this.value;
    yield* this.right.inorder();
  }

  toString(): string {
    const leftEmpty = this.left instanceof Empty;
    const rightEmpty = this.right instanceof Empty;

    const leftStr = leftEmpty ? '' : this.left.toString();
    const rightStr = rightEmpty ? '' : this.right.toString();

    return `(${leftStr}${this.value}${rightStr})`;
  }
}
