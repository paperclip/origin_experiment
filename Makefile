
libmylib.so : mylib.c
	gcc -fPIC -shared -o $@ $<

lib/libotherlib.so : mylib.c
	mkdir -p lib
	gcc -fPIC -shared -o $@ $<

exe : exe.c libmylib.so
	gcc -fPIC exe.c -L. -lmylib -ldl -o $@ -Wl,-rpath,'$$ORIGIN'

exe2 : exe.c lib/libotherlib.so
	gcc -fPIC exe.c -Llib -lotherlib -ldl -o $@ -Wl,-rpath,'$$ORIGIN/lib'

test1 : exe
	sudo chown $$USER: $<
	getcap $<
	./$<

test2 : exe
	sudo chown $$USER: $<
	sudo setcap 'cap_net_bind_service=+ep' $<
	getcap $<
	./$<

test3 : exe
	sudo chown $$USER: $<
	sudo setcap 'cap_dac_read_search=ep' $<
	getcap $<
	./$<

test4 : exe
	sudo chown root: $<
	sudo chmod 6777 $<
	getcap $<
	ls -l $<
	ldd $< || true
	./$<

test5 : exe2
	sudo chown $$USER: $<
	getcap $<
	ls -l $<
	./$<

test6 : exe2
	sudo chown $$USER: $<
	sudo setcap 'cap_net_bind_service=+ep' $<
	getcap $<
	./$<

test7 : exe2
	sudo chown root: $<
	sudo chmod 6777 $<
	getcap $<
	ls -l $<
	ldd $< || true
	./$<

clean :
	rm -f exe exe2 libmylib.so lib


.PHONY : clean test1 test2 test3 test4 test5
