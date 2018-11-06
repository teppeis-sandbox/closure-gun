UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
	OUTFILE = libNailgunTest.so
	CCFLAGS = -fPIC -I${JAVA_HOME}/include -I${JAVA_HOME}/include/linux
endif
ifeq ($(UNAME_S),Darwin)
	OUTFILE = libNailgunTest.jnilib
	CCFLAGS = -I$(shell /usr/libexec/java_home)/include -I$(shell /usr/libexec/java_home)/include/darwin
endif

install: bin/$(OUTFILE) closure-compiler nailgun

bin/$(OUTFILE):
	cd "bin" && javac "NailgunTest.java" && gcc "NailgunTest.c" -shared -o $(OUTFILE) $(CCFLAGS)

closure-compiler:
	mkdir "closure-compiler"
# Use the compiler provide by google-closure-compiler, if available
ifneq ("$(wildcard ../google-closure-compiler-java/compiler.jar)","")
	cp "../google-closure-compiler-java/compiler.jar" "./closure-compiler/compiler.jar"
# before v20181028
else ifneq ("$(wildcard ../google-closure-compiler/compiler.jar)","")
	cp "../google-closure-compiler/compiler.jar" "./closure-compiler/compiler.jar"
# Else, init bootstraping
	rm -fr "tmp"; mkdir -p "tmp/closure-compiler"
# Download latest Google Closure Compiler
	curl -L -o "./tmp/compiler-latest.tgz" "https://dl.google.com/closure-compiler/compiler-latest.tar.gz" \
		&& tar -xf "./tmp/compiler-latest.tgz" -C "./tmp/closure-compiler"
# Move compiler.jar
	mv ./tmp/closure-compiler/closure-compiler-*.jar "./closure-compiler/compiler.jar"
# Cleanup
	rm -fr "tmp"
endif

nailgunDir := tmp/nailgun-nailgun-all-0.9.3

nailgun:
# Init bootstraping
	rm -fr "tmp"; mkdir -p "tmp" "nailgun"
# Download Nailgun
	curl -L -o "tmp/nailgun-all-0.9.3.tgz" "https://github.com/facebook/nailgun/archive/nailgun-all-0.9.3.tar.gz" \
		&& tar -xf "tmp/nailgun-all-0.9.3.tgz" -C "tmp/"
# Maven building Nailgun-Server and "ng" binaries
	make ng -C $(nailgunDir) && mvn package --quiet -f $(nailgunDir)/nailgun-server/pom.xml
# Move nailgun-server-*.jar and "ng" binaries
	mv "$(nailgunDir)/nailgun-server/target/nailgun-server-0.9.3-SNAPSHOT.jar" "./nailgun/nailgun.jar"
	mv "$(nailgunDir)/ng" "./nailgun/ng"
# Cleanup
	rm -fr "tmp"

clean:
	rm -rf "bin/$(OUTFILE)" "bin/NailgunTest.class" "closure-compiler" "nailgun" "tmp"
