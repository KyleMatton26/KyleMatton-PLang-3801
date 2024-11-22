#include "string_stack.h"
#include <stdlib.h>
#include <string.h>


struct _Stack {
    char **data;       
    int capacity;      
    int top;           
};


static response_code resize_stack(stack s, int new_capacity) {
    if (new_capacity > MAX_CAPACITY) {
        return stack_full;
    }

    char **new_data = realloc(s->data, new_capacity * sizeof(char *));
    if (new_data == NULL) {
        return out_of_memory;
    }

    s->data = new_data;
    s->capacity = new_capacity;
    return success;
}


stack_response create() {
    stack_response response;
    response.code = success;
    response.stack = NULL;

    stack s = malloc(sizeof(struct _Stack));
    if (s == NULL) {
        response.code = out_of_memory;
        return response;
    }

    s->capacity = 16;
    s->top = 0;
    s->data = malloc(s->capacity * sizeof(char *));
    if (s->data == NULL) {
        free(s);
        response.code = out_of_memory;
        return response;
    }

    response.stack = s;
    return response;
}

int size(const stack s) {
    if (s == NULL) return 0;
    return s->top;
}

bool is_empty(const stack s) {
    if (s == NULL) return true;
    return s->top == 0;
}

bool is_full(const stack s) {
    if (s == NULL) return false;
    return s->capacity >= MAX_CAPACITY && s->top >= s->capacity;
}

response_code push(stack s, char* item) {
    if (s == NULL || item == NULL) {
        return out_of_memory;
    }

    if (strlen(item) >= MAX_ELEMENT_BYTE_SIZE) {
        return stack_element_too_large;
    }

    if (s->top >= s->capacity) {
        if (s->capacity == MAX_CAPACITY) {
            return stack_full;
        }

        int new_capacity = s->capacity * 2;
        if (new_capacity > MAX_CAPACITY) {
            new_capacity = MAX_CAPACITY;
        }
        response_code res = resize_stack(s, new_capacity);
        if (res != success) {
            return res;
        }
    }
    char *copy = malloc((strlen(item) + 1) * sizeof(char));
    if (copy == NULL) {
        return out_of_memory;
    }
    strcpy(copy, item);

    s->data[s->top++] = copy;
    return success;
}

string_response pop(stack s) {
    string_response response;
    response.code = success;
    response.string = NULL;

    if (s == NULL || s->top == 0) {
        response.code = stack_empty;
        return response;
    }

    char *top_str = s->data[--s->top];
    response.string = top_str; 

    if (s->capacity > 16 && s->top < s->capacity / 4) {
        int new_capacity = s->capacity / 2;
        if (new_capacity < 16) {
            new_capacity = 16;
        }
        
        if (new_capacity != s->capacity) {
            response_code res = resize_stack(s, new_capacity);
            if (res != success && res != stack_full) {

            }
        }
    }

    return response;
}

void destroy(stack* s_ptr) {
    if (s_ptr == NULL || *s_ptr == NULL) return;

    stack s = *s_ptr;

    for (int i = 0; i < s->top; i++) {
        free(s->data[i]);
    }

    free(s->data);
    free(s);

    *s_ptr = NULL;
}
