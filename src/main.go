package main


import (
	. "utilities"
	. "server"
	. "configuration"
	"os/exec"
	"bufio"
	"io"
	"os"
)


func main() {
	println("♥")
	go runWebpack(true)
	NewApplication(Settings[DEVELOPMENT], ApplicationRouter).Run()
}


func runWebpack(suppress bool) {
	cmd := exec.Command("webpack", "--watch")
	cmd.Dir = Root + "/src/clients"

	if !suppress {
		stdoutPipe, _ := cmd.StdoutPipe()
		output := bufio.NewReader(stdoutPipe)

		cmd.Start()

		var buf = make([]byte, 2048, 2048)
		count, err := output.Read(buf)

		for count > 0 && err != io.EOF {
			os.Stdout.Write(buf)
			count, err = output.Read(buf)
		}
	} else {
		cmd.Run()
	}

}