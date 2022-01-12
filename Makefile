object := oled-saver
prefix := .rb

t1 := install
t2 := uninstall

.PHONY: all $(t1) $(t2)

all: ; 	printf "Tasks:\n$(t1)\n$(t2)\n"

$(t1):
	cp $(object)$(prefix) /bin/$(object)

$(t2):
	rm /bin/$(object)
