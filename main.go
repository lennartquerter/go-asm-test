package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"os/exec"
)

func main() {

	if _, err := os.Stat("./assemble"); os.IsNotExist(err) {
		os.Mkdir("./assemble", os.ModePerm)
	}

	if _, err := os.Stat("./bin"); os.IsNotExist(err) {
		os.Mkdir("./bin", os.ModePerm)
	}

	fmt.Printf("Assembling program\n")
	err := assemble()
	if err != nil {
		log.Fatal(err.Error())
	}

	fmt.Printf("Linking program\n")
	err = link()
	if err != nil {
		log.Fatal(err.Error())
	}

	fmt.Printf("Executing program\n\n")
	err = executeProc()
	if err != nil {
		log.Fatal(err.Error())
	}
}

func executeProc() error {
	cmd := exec.Command("./bin/out")
	stderr, err := cmd.StderrPipe()
	stdout, err := cmd.StdoutPipe()
	if err != nil {
		log.Fatal(err)
	}

	if err := cmd.Start(); err != nil {
		log.Fatal(err)
	}

	slurpOut, _ := ioutil.ReadAll(stdout)
	fmt.Printf("out: %s\n", slurpOut)

	slurpErr, _ := ioutil.ReadAll(stderr)
	fmt.Printf("err: %s\n", slurpErr)

	if err := cmd.Wait(); err != nil {
		log.Fatal(err)
	}
	return err
}

func link() error {
	cmd := exec.Command("ld", "-macosx_version_min", "10.7.0", "-lSystem", "-no_pie", "-o", "./bin/out", "./assemble/main.o")
	return cmd.Run()
}

func assemble() error {
	cmd := exec.Command("nasm", "-f", "macho64", "src/main.asm", "-o", "./assemble/main.o")

	stderr, err := cmd.StderrPipe()
	stdout, err := cmd.StdoutPipe()
	if err != nil {
		log.Fatal(err)
	}

	if err := cmd.Start(); err != nil {
		log.Fatal(err)
	}

	slurpOut, _ := ioutil.ReadAll(stdout)
	fmt.Printf("out: %s\n", slurpOut)

	slurpErr, _ := ioutil.ReadAll(stderr)
	fmt.Printf("err: %s\n", slurpErr)

	if err := cmd.Wait(); err != nil {
		log.Fatal(err)
	}
	return err
}
