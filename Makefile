
libmylib.so : mylib.c
	gcc -fPIC -shared -o $@ $<

lib/libotherlib.so : mylib.c
	mkdir -p lib
	gcc -fPIC -shared -o $@ $<

exe : exe.c libmylib.so
	gcc -fPIC exe.c -L. -lmylib -ldl -o $@ -Wl,-rpath,'$$ORIGIN'

exe_sub_dir : exe.c lib/libotherlib.so
	gcc -fPIC exe.c -Llib -lotherlib -ldl -o $@ -Wl,-rpath,'$$ORIGIN/lib'

exe_bind : exe
	cat $< >$@
	chmod 700 $@
	sudo chown $$USER: $@
	sudo setcap 'cap_net_bind_service=+ep' $@

exe_dac : exe
	cat $< >$@
	chmod 700 $@
	sudo chown $$USER: $@
	sudo setcap 'cap_dac_read_search=ep' $@

exe_suid : exe
	cat $< >$@
	chmod 700 $@
	sudo chown root: $@
	sudo chmod 6777 $@

exe_sub_dir_bind : exe_sub_dir
	cat $< >$@
	chmod 700 $@
	sudo chown $$USER: $@
	sudo setcap 'cap_net_bind_service=+ep' $@

exe_sub_dir_suid : exe_sub_dir
	cat $< >$@
	sudo chown root: $@
	sudo chmod 6777 $@

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

clean :
	rm -rf exe exe2 exe_sub_dir libmylib.so lib exe_bind exe_dac exe_suid hack exe_sub_dir_suid exe_sub_dir_bind

## Test targets
test1 : exe
	getcap $<
	./$<

test2 : exe_bind
	getcap $<
	./$<

test3 : exe_dac
	getcap $<
	./$<

test4 : exe_suid
	getcap $<
	ls -l $<
	ldd $< || true
	./$<

test5 : exe_sub_dir
	getcap $<
	ls -l $<
	./$<

test6 : exe_sub_dir_bind
	getcap $<
	./$<

test7 : exe_sub_dir_suid
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


.PHONY : clean test1 test2 test3 test4 test5 test6 test7 test8 test9 test10
