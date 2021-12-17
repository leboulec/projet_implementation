CC=gcc
CCFLAGS= -Wall -Werror
LIBFLAGS= -lm
SRC= $(wildcard *.c)
OBJ= $(SRC:.c=.o)
TST= $(wildcard *.c)
OBJ_TEST = $(filter-out ../main.o, $(OBJ)) $(TST:.c=.o)
EXEC = image_formatter	

image_formatter : $(OBJ_TEST) 
	$(CC) $^ -o $@ $(LIBFLAGS)

%.o: %.cpp
	$(CC) $(CCFLAGS) -I../ -o $@ -c $<

clean :
	rm -f $(OBJ_TEST) $(EXEC)
