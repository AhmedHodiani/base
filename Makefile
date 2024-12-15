SRCS			= src/main.c
OBJS			= $(SRCS:src/%.c=${BUILD_DIR}/obj/%.o)

NAME			= out
CC				= cc
CFLAGS			= -Wall -Wextra -Werror
BUILD_DIR		= build

LIBS			= libtrue libft libftprintf
LIBS_FLAGS		= $(foreach lib,$(patsubst lib%,%, $(LIBS)),-l$(lib))

all: ${NAME}

${NAME}: $(OBJS) $(foreach lib,$(LIBS),$(BUILD_DIR)/$(lib).a)
	@$(CC) $(CFLAGS) $(OBJS) -L${BUILD_DIR} ${LIBS_FLAGS} -o ${NAME}
	@mv ${NAME} ${BUILD_DIR}/${NAME}

$(BUILD_DIR)/%.a:
	@mkdir -p $(BUILD_DIR)
	@$(MAKE) -C libs/$* all
	@rm -rf $(BUILD_DIR)/$*_obj
	@mv libs/$*/obj $(BUILD_DIR)/$*_obj
	@mv libs/$*/*.a $(BUILD_DIR)/$*.a

$(BUILD_DIR)/obj/%.o: src/%.c
	@mkdir -p build/obj
	@$(CC) $(CFLAGS) -L${BUILD_DIR} ${LIBS_FLAGS} -c $< -o $@

clean:
	@rm -rf ${BUILD_DIR}/obj
	@rm -rf ${BUILD_DIR}/*_obj

copy_include:
	@for lib in ${LIBS}; do \
		rm -rf include/$${lib}; \
		mkdir -p include/$${lib}; \
		cp libs/$${lib}/include/* include/$${lib}/; \
		echo "#include \"$${lib}/*.h\"" >> include/header.h; \
	done

fclean: clean
	@rm -rf ${BUILD_DIR}

re: fclean all

.PHONY: all clean re fclean copy_include
