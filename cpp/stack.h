#ifndef STACK_H
#define STACK_H

#include <stdexcept>
#include <string>
#include <memory>
#include <algorithm> 
#include <utility>   

#define MAX_CAPACITY 32768
#define INITIAL_CAPACITY 16

template <typename T>
class Stack {
public:
    Stack() 
        : elements(std::make_unique<T[]>(INITIAL_CAPACITY)), 
          capacity(INITIAL_CAPACITY), 
          top_index(0) {}

    Stack(const Stack&) = delete;
    Stack& operator=(const Stack&) = delete;

    Stack(Stack&&) = delete;
    Stack& operator=(Stack&&) = delete;

    ~Stack() = default;

    int size() const {
        return top_index;
    }

    bool is_empty() const {
        return top_index == 0;
    }

    bool is_full() const {
        return capacity >= MAX_CAPACITY && top_index >= capacity;
    }

    void push(const T& item) {
        if (is_full()) {
            throw std::overflow_error("Stack has reached maximum capacity");
        }

        if (top_index >= capacity) {
            reallocate(capacity * 2);
        }

        elements[top_index++] = item;
    }

    T pop() {
        if (is_empty()) {
            throw std::underflow_error("cannot pop from empty stack");
        }

        T item = std::move(elements[--top_index]);

        if (capacity > INITIAL_CAPACITY && top_index < capacity / 4) {
            int new_capacity = capacity / 2;
            if (new_capacity < INITIAL_CAPACITY) {
                new_capacity = INITIAL_CAPACITY;
            }
            reallocate(new_capacity);
        }

        return item;
    }

private:
    std::unique_ptr<T[]> elements; 
    int capacity;                  
    int top_index;                 

    void reallocate(int new_capacity) {
        if (new_capacity > MAX_CAPACITY) {
            throw std::overflow_error("Stack has reached maximum capacity");
        }

        if (new_capacity < INITIAL_CAPACITY) {
            new_capacity = INITIAL_CAPACITY;
        }

        std::unique_ptr<T[]> new_elements = std::make_unique<T[]>(new_capacity);

        for (int i = 0; i < top_index; ++i) {
            new_elements[i] = std::move(elements[i]);
        }

        elements = std::move(new_elements);
        capacity = new_capacity;
    }
};

#endif 
