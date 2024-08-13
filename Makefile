deactivate:
	dart pub global deactivate injil_cli

install:
	dart pub global activate --source=path .

reinstall:
	make deactivate
	make install

run:
	dart run bin/inj.dart