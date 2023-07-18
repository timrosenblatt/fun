// Originally from https://sysdig.com/blog/golden-signals-kubernetes/

package main

import (
	"fmt"
	"log"
	"math/rand"
	"net/http"
	"time"

	"github.com/gorilla/mux"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/prometheus/client_golang/prometheus/promhttp"
)

func main() {
	// Prometheus: Histogram to collect required metrics
	histogram := prometheus.NewHistogramVec(prometheus.HistogramOpts{
		Name:    "greeting_seconds",
		Help:    "Time take to greet someone",
		Buckets: []float64{1, 2, 5, 6, 10}, //defining small buckets as this app should not take more than 1 sec to respond
	}, []string{"code"}) // this will be partitioned by the HTTP code.

	router := mux.NewRouter()
	router.Handle("/sayhello/{name}", Sayhello(histogram))

	// I had to make a change from the original blog post.
	// I tried going back to v1.11.0 of the prometheus client
	// which is around the time that the blog post would have been written,
	// and it didn't work. Not sure how the blog post ever worked at all,
	// since it literally couldn't compile b/c prometheus.Handler() doesn't exist.
	// But this change comes from
	// https://github.com/prometheus/client_golang/blob/8184d76b3b0bd3b01ed903690431ccb6826bf3e0/examples/random/main.go
	// which seems to work and I've validated this with a few curl commands
	router.Handle("/metrics", promhttp.HandlerFor(
		prometheus.DefaultGatherer,
		promhttp.HandlerOpts{
			// Opt into OpenMetrics to support exemplars.
			EnableOpenMetrics: true,
		},
	)) //Metrics endpoint for scrapping
	router.Handle("/{anything}", Sayhello(histogram))
	router.Handle("/", Sayhello(histogram))
	//Registering the defined metric with Prometheus
	prometheus.Register(histogram)

	log.Fatal(http.ListenAndServe(":8080", router))
}

func Sayhello(histogram *prometheus.HistogramVec) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {

		//monitoring how long it takes to respond
		start := time.Now()
		defer r.Body.Close()
		code := 500
		defer func() {
			httpDuration := time.Since(start)
			histogram.WithLabelValues(fmt.Sprintf("%d", code)).Observe(httpDuration.Seconds())
		}()

		if r.Method == "GET" {
			vars := mux.Vars(r)
			code = http.StatusOK
			if _, ok := vars["anything"]; ok {
				//Sleep random seconds
				rand.Seed(time.Now().UnixNano())
				n := rand.Intn(2) // n will be between 0 and 3
				time.Sleep(time.Duration(n) * time.Second)
				code = http.StatusNotFound
				w.WriteHeader(code)
			}
			//Sleep random seconds
			rand.Seed(time.Now().UnixNano())
			n := rand.Intn(12) // n will be between 0 and 12
			time.Sleep(time.Duration(n) * time.Second)
			name := vars["name"]
			greet := fmt.Sprintf("Hello %s \n", name)
			w.Write([]byte(greet))
		} else {
			code = http.StatusBadRequest
			w.WriteHeader(code)
		}
	}
}
