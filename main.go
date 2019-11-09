package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"os/exec"
)

var fileName = "boot"
var outputFormat = "bin"
var assembledFormat = "main.bin"

var runQemu = false
var runExec = false

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

	if runQemu {
		fmt.Printf("running qemu\n")
		err = startQemu()
		if err != nil {
			log.Fatal(err.Error())
		}
	}

	if !runExec {
		return
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

func startQemu() error {
	cmd := exec.Command("qemu-system-x86_64", fmt.Sprintf("./assemble/%s", assembledFormat), "-nographic", )
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
	cmd := exec.Command("ld", "-macosx_version_min", "10.7.0", "-lSystem", "-no_pie", "-o", "./bin/out", fmt.Sprintf("./assemble/%s", assembledFormat))
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

func assemble() error {
	cmd := exec.Command("nasm", "-f", outputFormat, fmt.Sprintf("asm/%s.asm", fileName), "-o", fmt.Sprintf("./assemble/%s", assembledFormat))

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
