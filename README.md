# Ping Pong NASM Project 🏓

This project contains assembly code for a simple program written in NASM (Netwide Assembler). The program is designed to run in a 16-bit real mode environment and demonstrates basic graphics programming by drawing a square on the screen.

## Table of Contents 📑

- [Getting Started](#getting-started-🚀)
- [Files](#files-📂)
- [Usage](#usage-⚙️)
- [Assembly Files](#assembly-files-🗃️)

## Getting Started 🚀

To get started with this project, you will need to have NASM and QEMU installed on your system. These tools are used to assemble and run the assembly code.

### Prerequisites 📋

- NASM (Netwide Assembler)
- QEMU (Quick Emulator)

### Installation 💻

You can install NASM and QEMU using the following commands:

#### On Ubuntu/Debian 🐧

```sh
sudo apt-get update
sudo apt-get install nasm qemu
```

#### On Windows 🪟

Download and install NASM and QEMU from their official websites:

- [NASM](https://www.nasm.us/)
- [QEMU](https://www.qemu.org/)

## Files 📂

- `.gitignore`: Specifies files and directories to be ignored by Git.
- `cmd.txt`: Contains commands to assemble and run the example assembly code.
- `x86ASM/buildSingleASM.bat`: A batch script to assemble and run a specified assembly file.
- `x86ASM/example.asm`: The main assembly file containing the code to draw a square on the screen.

## Usage ⚙️

To assemble and run the example assembly code, you can use the provided batch script or the commands in `cmd.txt`.

### Using the Batch Script 📜

Navigate to the `x86ASM` directory and run the batch script with the name of the assembly file (without the extension) as an argument:

```sh
cd x86ASM
.\buildSingleASM.bat example
```

### Using the Commands in `cmd.txt` 📝

Alternatively, you can manually run the commands listed in `cmd.txt`:

```sh
nasm -f bin example.asm -o example.bin
qemu-system-x86_64 -fda example.bin
```

## Assembly Files 🗃️

<details>
<summary>
<code>x86ASM/example.asm</code></summary>

### Description 📝

This assembly file contains code to set the video mode to 320x200 with 256 colors and draw a red square on the screen.

### Functionality ⚙️

- **Initialization**: Sets up the data segment, stack segment, and video mode.
- **Drawing the Square**: Calculates the starting position and dimensions of the square, then draws it pixel by pixel.
- **Infinite Loop**: Keeps the program running indefinitely.

</details>
