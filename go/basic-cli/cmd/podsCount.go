/*
https://kubernetes.io/docs/tasks/administer-cluster/access-cluster-api/#programmatic-access-to-the-api
*/
package cmd

import (
	"context"
	"fmt"
	"log"
	"os"

	"github.com/spf13/cobra"
	v1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/client-go/kubernetes"
	"k8s.io/client-go/tools/clientcmd"
)

// podsCountCmd represents the podsCount command
var podsCountCmd = &cobra.Command{
	Use:   "podsCount",
	Short: "Count the pods",
	Long: `More words used to describe the functionality
of quantifying the quantity of pod units`,
	Run: func(cmd *cobra.Command, args []string) {
		homeDir, err := os.UserHomeDir()
		if err != nil {
			log.Fatal("Oh no, you are homeless")
		}
		config, _ := clientcmd.BuildConfigFromFlags("", homeDir+"/.kube/config")
		clientset, _ := kubernetes.NewForConfig(config)
		pods, _ := clientset.CoreV1().Pods("").List(context.TODO(), v1.ListOptions{})
		fmt.Printf("There are %d pods in the cluster\n", len(pods.Items))
	},
}

func init() {
	rootCmd.AddCommand(podsCountCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// podsCountCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// podsCountCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}
