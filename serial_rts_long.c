//this code this generated by copilot of bing..

#include <stdio.h>
#include <stdlib.h> // For atoi function
#include <unistd.h> // For usleep function
#include <fcntl.h> // For file control options
#include <termios.h> // For terminal I/O

int main(int argc, char* argv[]) {
    if (argc != 3) {
        printf("Usage: %s <RS232_port> <delay_in_ms>\n", argv[0]);
        return 1;
    }

    const char* portName = argv[1];
    float delayMs = atof(argv[2]); // Convert argument to integer
    if (delayMs <= 0) {
        printf("Invalid delay time. Please provide a positive integer.\n");
        return 1;
    }

   

    int fd = open(portName, O_RDWR | O_NOCTTY);
    if (fd == -1) {
        perror("Error opening serial port");
        return 1;
    }

    struct termios tty;
    if (tcgetattr(fd, &tty) != 0) {
        perror("Error getting serial port attributes");
        close(fd);
        return 1;
    }

    // Set RTS signal
    tty.c_cflag |= CRTSCTS; // Enable RTS
    if (tcsetattr(fd, TCSANOW, &tty) != 0) {
        perror("Error setting RTS signal");
        close(fd);
        return 1;
    }

    // Wait for the specified delay time
    usleep(delayMs * 1000); // usleep takes microseconds

    // Clear RTS signal
    tty.c_cflag &= ~CRTSCTS; // Disable RTS
    if (tcsetattr(fd, TCSANOW, &tty) != 0) {
        perror("Error clearing RTS signal");
        close(fd);
        return 1;
    }

    close(fd);

    //printf("RTS signal set for %d milliseconds on port %s.\n", delayMs, portName);
    return 0;
}
