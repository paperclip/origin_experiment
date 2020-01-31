
libmylib.so : mylib.c
	gcc -fPIC -shared -o $@ $<

exe : exe.c libmylib.so
	gcc -fPIC exe.c -L. -lmylib -ldl -o $@ -Wl,-rpath,'$$ORIGIN'

test1 : exe
	sudo setcap -r $< || true
	getcap $<
	./$<

test2 : exe
	sudo setcap -r $< || true
	sudo setcap 'cap_net_bind_service=+ep' $<
	getcap $<
	./$<

test3 : exe
	sudo setcap -r $< || true
	sudo setcap 'cap_dac_read_search=ep' $<
	getcap $<
	./$<

test4 : exe
	sudo setcap -r $< || true
	sudo chmod 6777 $<
	sudo chown root: $<
	getcap $<
	ls -l $<
	./$<

clean :
	rm -f exe libmylib.so


.PHONY : clean test1
