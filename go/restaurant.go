// restaurant.go
package main

import (
	"log"
	"math/rand"
	"sync"
	"sync/atomic"
	"time"
)

var nextOrderID atomic.Uint64

type Order struct {
	id         uint64
	customer   string
	reply      chan *Order
	preparedBy string
}

// A little utility that simulates performing a task for a random duration.
// For example, calling do(10, "Remy", "is cooking") will compute a random
// number of milliseconds between 5000 and 10000, log "Remy is cooking",
// and sleep the current goroutine for that much time.
func do(seconds int, action ...any) {
	log.Println(action...)
	randomMillis := 500*seconds + rand.Intn(500*seconds)
	time.Sleep(time.Duration(randomMillis) * time.Millisecond)
}

var waiter chan *Order

func cook(name string) {
	log.Println(name, "starting work")
	for {
		order, ok := <-waiter
		if !ok {
			log.Println(name, "closing work")
			return
		}
		do(10, name, "cooking order", order.id, "for", order.customer)
		order.preparedBy = name
		order.reply <- order
	}
}

func customer(name string, wg *sync.WaitGroup) {
	defer wg.Done()
	mealsEaten := 0
	for mealsEaten < 5 {
		order := &Order{
			id:       nextOrderID.Add(1),
			customer: name,
			reply:    make(chan *Order),
		}
		log.Println(name, "placed order", order.id)

		select {
		case waiter <- order:
			meal := <-order.reply
			do(2, name, "eating cooked order", meal.id, "prepared by", meal.preparedBy)
			mealsEaten++
		case <-time.After(7 * time.Second):
			log.Println(name, "waiting too long, abandoning order", order.id)
			do(5, name, "waiting too long, abandoning order", order.id)
			time.Sleep(time.Duration(2500+rand.Intn(2500)) * time.Millisecond)
		}
	}
	log.Println(name, "going home")
}

func main() {
	rand.Seed(time.Now().UnixNano())

	customers := []string{
		"Ani", "Bai", "Cat", "Dao", "Eve", "Fay", "Gus", "Hua", "Iza", "Jai",
	}
	cooks := []string{"Remy", "Colette", "Linguini"}

	log.Println("Welcome to the Restaurant!")

	waiter = make(chan *Order, 3)

	var wg sync.WaitGroup
	wg.Add(len(customers))

	for _, cookName := range cooks {
		go cook(cookName)
	}

	for _, customerName := range customers {
		go customer(customerName, &wg)
	}

	wg.Wait()

	close(waiter)

	time.Sleep(1 * time.Second)

	log.Println("Restaurant closing")
}
