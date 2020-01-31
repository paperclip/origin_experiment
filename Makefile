
libmylib.so : mylib.c
	gcc -fPIC -shared -o $@ $<

lib/libotherlib.so : mylib.c
	mkdir -p lib
	gcc -fPIC -shared -o $@ $<

exe : exe.c libmylib.so
	gcc -fPIC exe.c -L. -lmylib -ldl -o $@ -Wl,-rpath,'$$ORIGIN'

exe2 : exe.c lib/libotherlib.so
	gcc -fPIC exe.c -Llib -lotherlib -ldl -o $@ -Wl,-rpath,'$$ORIGIN/lib'

hack/libmylib.so : hacklib.c
	mkdir -p hack
	gcc -fPIC -shared -o $@ $<

hack/lnexe : exe hack/libmylib.so
	mkdir -p hack
	ln -snf ../exe $@

hack/hardexe : exe hack/libmylib.so
	mkdir -p hack
	ln -nf exe $@

hack/cpexe : exe hack/libmylib.so
	mkdir -p hack
	cp -f exe $@

## Test targets
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

test8 : hack/lnexe hack/libmylib.so
	getcap $<
	ls -l $< exe
	ldd $< || true
	LD_DEBUG=libs ./$<

test9 : hack/cpexe hack/libmylib.so
	getcap $<
	ls -l $< exe
	ldd $< || true
	LD_DEBUG=libs ./$<

test10 : hack/hardexe hack/libmylib.so
	getcap $<
	ls -l $< exe
	ldd $< || true
	LD_DEBUG=libs ./$<

clean :
	rm -f exe exe2 libmylib.so lib


.PHONY : clean test1 test2 test3 test4 test5 test6 test7 test8 test9 test10
