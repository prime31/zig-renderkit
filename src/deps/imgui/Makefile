TARGET :=

CP := cp
CIMGUI := cimgui
IMGUI := $(CIMGUI)/imgui
$(shell mkdir -p build)

LIBS :=

CFLAGS := -I.
CFLAGS += -DCIMGUI_DEFINE_ENUMS_AND_STRUCTS=1
CFLAGS += -DIMGUI_DISABLE_OBSOLETE_FUNCTIONS=1
CFLAGS += `sdl2-config --cflags`

## Using OpenGL loader: gl3w [default]
GL3W := $(CIMGUI)/imgui/examples/libs/gl3w
CFLAGS += -I$(GL3W)

TARGET += imgui_impl_sdl.o
TARGET += imgui_impl_opengl3.o
# TARGET += gl3w.o

##---------------------------------------------------------------------
## BUILD FLAGS PER PLATFORM
##---------------------------------------------------------------------

UNAME_S := $(shell uname -s)
LIB_FOLDER :=

ifeq ($(UNAME_S), Linux) #LINUX
	LIBS += -lGL -ldl `sdl2-config --libs`
	CFLAGS += `sdl2-config --cflags`

	SED := sed -i
	TARGET += cimgui.so # not yet supported
else ifeq ($(UNAME_S), Darwin) #APPLE
	LIBS += -framework OpenGL -framework Cocoa -framework IOKit -framework CoreVideo `sdl2-config --libs`
	LIBS += -L/usr/local/lib

	CFLAGS += `sdl2-config --cflags`
	CFLAGS += -I/usr/local/include

	SED := sed -i ''
endif

##---------------------------------------------------------------------
## BUILD RULES
##---------------------------------------------------------------------

all: $(TARGET)
	@echo build complete

# gl3w.o: $(IMGUI)/examples/libs/gl3w/GL/gl3w.c
# 	$(CXX) -fPIC -c -o build/$@ $^ -I$(GL3W) -fno-threadsafe-statics

imgui_impl_sdl.o: $(IMGUI)/examples/imgui_impl_sdl.cpp
	$(CXX) -fPIC -c -o build/$@ $^ -I$(IMGUI) `sdl2-config --cflags` -DIMGUI_IMPL_API=extern\ \"C\" -fno-threadsafe-statics

imgui_impl_opengl3.o: $(IMGUI)/examples/imgui_impl_opengl3.cpp
	$(CXX) -fPIC -c -o build/$@ $^ -I$(IMGUI) $(CFLAGS) $(LIBS) -DIMGUI_IMPL_API=extern\ \"C\" -fno-threadsafe-statics

clean:
	$(RM) *.o *.so *.h $(TARGET)

clobber: clean
	$(RM) -Rf cimgui
