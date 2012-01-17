################################################################################
# Configuration du Makefile                                                    #
################################################################################

# Dossier source
SRC_DIR         = ./src/
# Dossier objets
OBJ_DIR         = ./obj/
# Dossier dépendances
DEP_DIR         = ./dept/
# Dossier executable
BIN_DIR         = ./

# Nom de l'executable
BIN             = executable

# Libs
LIB_DIR         = ./
# Includes
INC_DIR         = ./include/

# Compilation C
CC      = gcc
# Compilation C++
CPP     = g++
# Linker
LD      = gcc

# Flags CPP
CPPFLAGS = -I$(INC_DIR) -g -Wall --std=gnu99 `pkg-config opencv --cflags` -Wno-unused
# Flags C
CFLAGS  = -I$(INC_DIR) -g -Wall -pipe `pkg-config opencv --cflags` -Wno-unused -lusb  --std=gnu99
# Flags du linker
LDFLAGS = -L$(LIB_DIR) `pkg-config opencv --libs`  -lusb

################################################################################
# NE RIEN CHANGER APRÈS CETTE LIGNE                                            #
################################################################################

SRCS_CPP        = $(wildcard $(SRC_DIR)*.cpp)
SRCS_C          = $(wildcard $(SRC_DIR)*.c)

#Liste des dépendances .cpp, .c ==> .d
DEPS    = $(SRCS_CPP:$(SRC_DIR)%.cpp=$(DEP_DIR)%.d) $(SRCS_C:$(SRC_DIR)%.c=$(DEP_DIR)%.d)

#Liste des objets : .cpp, .c, .y, .l ==> .o
OBJS    = $(SRCS_CPP:$(SRC_DIR)%.cpp=$(OBJ_DIR)%.o) $(SRCS_C:$(SRC_DIR)%.c=$(OBJ_DIR)%.o)

#Rules
all: $(BIN_DIR)/$(BIN)

#To executable
$(BIN_DIR)/$(BIN): $(OBJS)
	mkdir -p $(BIN_DIR)
	$(LD) $+ -o $@ $(LDFLAGS)
        
#To Objets
$(OBJ_DIR)%.o: $(SRC_DIR)%.c
	mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -o $@ -c $<
	
$(OBJ_DIR)%.o: $(SRC_DIR)%.cpp
	mkdir -p $(OBJ_DIR)
	$(CPP) $(CPPFLAGS) -o $@ -c $<

#Gestion des dépendances
$(DEP_DIR)%.d: $(SRC_DIR)%.c
	mkdir -p $(DEP_DIR)
	$(CC) $(CFLAGS) -MM -MD -o $@ $<

$(DEP_DIR)%.d: $(SRC_DIR)%.cpp
	mkdir -p $(DEP_DIR)
	$(CPP) $(CPPFLAGS) -MM -MD -o $@ $<

-include $(DEPS)

.PHONY: clean distclean


run: $(BIN_DIR)/$(BIN)
	$(BIN_DIR)/$(BIN)

clean:
	rm -f $(OBJ_DIR)*.o $(SRC_DIR)*~ $(DEP_DIR)*.d *~ $(BIN_DIR)/$(BIN)

distclean: clean
	rm -f $(BIN_DIR)/$(BIN)

tar: clean
	tar -cvzf ../${shell basename `pwd`}.tgz ../${shell basename `pwd`}

