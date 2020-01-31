

testfile :
	echo "THIS IS A SECRET" >$@
	chmod 600 $@
	sudo chown root: $@

libreadfile.so : readfile.c
	gcc -fPIC -shared -o $@ $<

exe : exe.c libreadfile.so
	gcc -fPIC $< -L. -lreadfile -ldl -lcap -o $@ -Wl,-rpath,'$$ORIGIN'

exe_cap : exe
	cat $< >$@
	chmod 700 $@
	sudo setcap 'cap_dac_read_search=ep' $@

exe_static_cap : exe.c readfile.c
	gcc -fPIC $^ -lcap -o $@
	chmod 700 $@
	sudo setcap 'cap_dac_read_search=ep' $@

exe_sudo : exe
	cat $< >$@
	sudo chown root: $@
	sudo chmod 6777 $@

launcher_cap : launcher.c
	gcc -fPIC $^ -lcap -o $@
	chmod 700 $@
	sudo setcap 'cap_dac_read_search=eip' $@

test1 : exe testfile
	./$<

test2 : exe_cap testfile
	./$<

test3 : exe_static_cap testfile
	./$<

test4 : launcher_cap exe testfile
	getcap $< exe
	./$<

clean :
	rm -rf launcher_cap exe_sudo exe_static_cap exe_cap libreadfile.so testfile
