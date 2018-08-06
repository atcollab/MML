VPATH = ./src

.SUFFIXES:

SRC        = ./src
LIB        = ./lib

INC   =  -I../usr/include -I/usr/lib/g++-include \
              -I./inc \
              -I../usr/local 

CFLAGS = -c -O3 $(INC)
CXX    = g++ 

SOURCES= $(shell cd src && ls *.cpp )
#OBJS= $(SOURCES:.cpp=.o)
OBJS= $(patsubst %.cpp,lib/%.o,$(SOURCES))


$(LIB)/libZlib.a : $(OBJS)
	ar cru  $(LIB)/libZlib.a $(OBJS)
	ranlib  $(LIB)/libZlib.a

$(LIB)/%.o : $(VPATH)/%.cpp inc/%.hpp
	$(CXX) $(CFLAGS) $(INC) $< -o $@ 

$(LIB)/Eigen.o : $(VPATH)/Eigen.cpp 
	$(CXX) $(CFLAGS) $(INC) $< -o $@ 

clean:
	rm -f $(OBJS)

id:
	@echo OBJS: $(OBJS)
