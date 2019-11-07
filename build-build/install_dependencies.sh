#!/usr/bin/env bash
# Install dependencies script

# install dev toolkit
ulimit -u

# setup environmental variables
OPENSSL_ROOT_DIR=/usr/local/opt/openssl
OPENSSL_LIBRARIES=/usr/local/opt/openssl/lib
HOME=/
TEMP_DIR=/tmp/
VERSION=1.0
BUILD_FORKS="-j$(nproc)"

BOOST_ROOT=${HOME}/opt/boost_1_69_0
BINARYEN_BIN=${HOME}/opt/binaryen/bin
OPENSSL_ROOT_DIR=/usr/local/opt/openssl
OPENSSL_LIBRARIES=/usr/local/opt/openssl/lib
WASM_LLVM_CONFIG=${HOME}/opt/wasm/bin/llvm-config
WASM_LLVM=${HOME}/opt/wasm/
ROCKSDB_ROOT=${HOME}/opt/rocksdb
BEAST_ROOT=${HOME}/opt/beast
BEAST_INCLUDE=${BEAST_ROOT}/include
export BOOST_ROOT BINARYEN_BIN OPENSSL_ROOT_DIR OPENSSL_LIBRARIES WASM_LLVM_CONFIG ROCKSDB_ROOT BEAST_ROOT BEAST_INCLUDE WASM_LLVM

PROTOBUF_SRC_ROOT_FOLDER=${HOME}/opt/protobuf/
PROTOBUF_LIBRARY=${PROTOBUF_SRC_ROOT_FOLDER}/lib/
PROTOBUF_IMPORT_DIRS=${PROTOBUF_SRC_ROOT_FOLDER}/include/
export PROTOBUF_SRC_ROOT_FOLDER PROTOBUF_LIBRARY PROTOBUF_IMPORT_DIRS

ASN1_ROOT_FOLDER=${HOME}/opt/asn1c/
export ASN1_ROOT_FOLDER

BOTAN_ROOT=${HOME}/opt/botan/
export BOTAN_ROOT

ROCKSDB_ROOT=${HOME}/opt/rocksdb/
export ROCKSDB_ROOT

LIBRDF_ROOT=${HOME}/opt/librdf/
export LIBRDF_ROOT

JSON_ROOT=${HOME}/opt/nlohmann/
export JSON_ROOT

CHAI_SCRIPT_ROOT=${HOME}/opt/ChaiScript/
export CHAI_SCRIPT_ROOT

LIBWAVM_ROOT=${HOME}/opt/wavm/
export LIBWAVM_ROOT

LIBWALLY_ROOT=${HOME}/opt/libwally-core/
export LIBWALLY_ROOT

# Debug flags
COMPILE_KETO=1
COMPILE_CONTRACTS=1

# Define default arguments.
CMAKE_BUILD_TYPE=RelWithDebugInfo

# remove cmake
#echo "Reinstall cmake from source"
#apt remove --purge --auto-remove cmake
#CMAKE_VERSION=3.15
#CMAKE_BUILD=4
#cd ${TEMP_DIR}
#wget https://cmake.org/files/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}.${CMAKE_BUILD}.tar.gz
#tar -xzvf cmake-${CMAKE_VERSION}.${CMAKE_BUILD}.tar.gz
#cd cmake-${CMAKE_VERSION}.${CMAKE_BUILD}/
#./bootstrap
#make -j$(nproc)
#make install

# install boost
echo "Build boost"
cd ${TEMP_DIR}
export BOOST_ROOT=${HOME}/opt/boost_1_71_0
curl -L https://dl.bintray.com/boostorg/release/1.71.0/source/boost_1_71_0.tar.bz2 > boost_1.71.0.tar.bz2
tar xvf boost_1.71.0.tar.bz2
cd boost_1_71_0/
./bootstrap.sh "--prefix=$BOOST_ROOT"
./b2 link=static cxxflags="-fPIC" cflags="-fPIC" visibility=global install
rm -rf ${TEMP_DIR}/boost_1_71_0/

# install secp256k1-zkp (Cryptonomex branch)
#cd ${TEMP_DIR}
#git clone https://github.com/cryptonomex/secp256k1-zkp.git
#cd secp256k1-zkp
#./autogen.sh
#./configure
#make
#sudo make install
#rm -rf cd ${TEMP_DIR}/secp256k1-zkp

# install binaryen
cd ${TEMP_DIR}
git clone https://github.com/WebAssembly/binaryen
cd binaryen
git checkout tags/1.37.14
cmake . && make
mkdir -p ${HOME}/opt/binaryen/
cp -rf ${TEMP_DIR}/binaryen/bin ${HOME}/opt/binaryen/.
rm -rf ${TEMP_DIR}/binaryen
BINARYEN_BIN=${HOME}/opt/binaryen/bin

# install rocksdb
cd ${TEMP_DIR}
git clone https://github.com/facebook/rocksdb.git
cd rocksdb
mkdir -p ${HOME}/opt/rocksdb/
#EXTRA_CFLAGS=-fPIC EXTRA_CXXFLAGS=-fPIC PORTABLE=1 make static_lib
INSTALL_PATH=${HOME}/opt/rocksdb/ EXTRA_CFLAGS=-fPIC EXTRA_CXXFLAGS=-fPIC PORTABLE=1 make static_lib
INSTALL_PATH=${HOME}/opt/rocksdb/ EXTRA_CFLAGS=-fPIC EXTRA_CXXFLAGS=-fPIC PORTABLE=1 make install
#mkdir -p ${HOME}/opt/rocksdb/
#mkdir -p ${HOME}/opt/rocksdb/lib
#mkdir -p ${HOME}/opt/rocksdb/lib
#mv ${TEMP_DIR}/rocksdb/librocksdb.a ${HOME}/opt/rocksdb/lib/
#cp -rf ${TEMP_DIR}/rocksdb/include ${HOME}/opt/rocksdb/include
cd ${HOME}
rm -rf ${TEMP_DIR}/rocksdb

# install beast
cd ${HOME}/opt
git clone https://github.com/boostorg/beast.git

# install protobuf
PROTOBUF_VERSION=3.5.1
cd ${TEMP_DIR}
wget https://github.com/google/protobuf/releases/download/v3.5.1/protobuf-all-${PROTOBUF_VERSION}.tar.gz
tar -zxvf protobuf-all-${PROTOBUF_VERSION}.tar.gz
mkdir -p ${HOME}/opt/protobuf
cd ${TEMP_DIR}/protobuf-${PROTOBUF_VERSION}/
./configure "CFLAGS=-fPIC" "CXXFLAGS=-fPIC" --prefix ${HOME}/opt/protobuf --enable-shared=no 
make
make install
cd ${HOME}
rm -rf ${TEMP_DIR}/protobuf-${PROTOBUF_VERSION}

# asn1 required for serialization of transaction and blockchain formats
cd ${TEMP_DIR}
git clone https://github.com/vlm/asn1c.git
mkdir -p ${HOME}/opt/asn1c
cd ${TEMP_DIR}/asn1c
test -f configure || autoreconf -iv
./configure --prefix ${HOME}/opt/asn1c
make
make install
cd ${HOME}
rm -rf ${TEMP_DIR}/asn1c

# botan required for encryption, hashing and 
cd ${TEMP_DIR}
git clone https://github.com/randombit/botan.git
mkdir -p ${HOME}/opt/botan
cd ${TEMP_DIR}/botan
git checkout "2.12.1"
./configure.py --cxxflags=-fPIC --prefix=${HOME}/opt/botan --with-openssl --disable-shared-library
make
make install
cd ${HOME}
rm -rf ${TEMP_DIR}/botan

# rdf libraries 
mkdir -p ${HOME}/opt/librdf
cd ${TEMP_DIR}
git clone git://github.com/dajobe/raptor.git
cd ${TEMP_DIR}/raptor
sed -i "/\$1\${prefix}cleanup(yyscanner)\;/d" scripts/fix-flex.pl
sed -i "/-Werror-implicit-function-declaration/d" configure.ac
CFLAGS=-fPIC CPPFLAGS=-fPIC ./autogen.sh --prefix=${HOME}/opt/librdf --enable-shared=no
make
make install
cd ${HOME}
rm -rf ${TEMP_DIR}/raptor

cd ${TEMP_DIR}
git clone git://github.com/dajobe/rasqal.git
cd ${TEMP_DIR}/rasqal
sed -i "/\$1\${prefix}cleanup(yyscanner)\;/d" scripts/fix-flex.pl
sed -i "/-Werror-implicit-function-declaration/d" configure.ac
CFLAGS=-fPIC CPPFLAGS=-fPIC PKG_CONFIG_PATH=${HOME}/opt/librdf/lib/pkgconfig ./autogen.sh --prefix=${HOME}/opt/librdf --enable-shared=no
make
make install
cd ${HOME}
rm -rf ${TEMP_DIR}/rasqal

cd ${TEMP_DIR}
git clone https://github.com/keto-coin/librdf.git
cd ${TEMP_DIR}/librdf
sed -i "/-Werror-implicit-function-declaration/d" configure.ac
CFLAGS=-fPIC CPPFLAGS=-fPIC PKG_CONFIG_PATH=${HOME}/opt/librdf/lib/pkgconfig ./autogen.sh --prefix=${HOME}/opt/librdf --enable-shared=no --with-bdb --with-threads
make
make install
cd ${HOME}
rm -rf ${TEMP_DIR}/librdf

# json parsing
cd ${TEMP_DIR}
git clone https://github.com/nlohmann/json.git
cd ${TEMP_DIR}/json
mkdir -p ${HOME}/opt/nlohmann/include
cp -rf single_include/nlohmann ${HOME}/opt/nlohmann/include
cd ${HOME}
rm -rf ${TEMP_DIR}/json

# build llvm with wasm build target:
cd ${TEMP_DIR}
mkdir wasm-compiler
cd wasm-compiler
git clone --depth 1 --single-branch --branch release_60 https://github.com/llvm-mirror/llvm.git
cd llvm/tools
git clone --depth 1 --single-branch --branch release_60 https://github.com/llvm-mirror/clang.git
cd ..
mkdir build
cd build
cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=${HOME}/opt/wasm \
    -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=WebAssembly -DCMAKE_BUILD_TYPE=Release ../
make ${BUILD_FORKS} install
rm -rf ${TEMP_DIR}/wasm-compiler
WASM_LLVM_CONFIG=${HOME}/opt/wasm/bin/llvm-config
WASM_LLVM=${HOME}/opt/wasm/

# build wavm
cd ${TEMP_DIR}
git clone https://github.com/WAVM/WAVM.git
#cd WAVM && git checkout nightly/2019-10-25 && cd -
cd WAVM && find ./ -name "CMakeLists.txt" | xargs sed -i.old "s/find_package(LLVM REQUIRED CONFIG)/find_package(LLVM 6.0 REQUIRED CONFIG PATHS \${LLVM_DIR})/g" && cd -
mkdir -p ${TEMP_DIR}/WAVM/cmake
cd ${TEMP_DIR}/WAVM/cmake
cmake .. -DCMAKE_BUILD_TYPE=RELEASE -DLLVM_DIR=${WASM_LLVM} -DWAVM_ENABLE_STATIC_LINKING=ON
make
mkdir -p ${HOME}/opt/wavm/lib
mkdir -p ${HOME}/opt/wavm/include
find ${TEMP_DIR}/WAVM/cmake  -name "*.a*" -exec cp {} ${HOME}/opt/wavm/lib/. \;
cp -rvf ${TEMP_DIR}/WAVM/cmake/lib/* ${HOME}/opt/wavm/lib/.
cp -rvf ${TEMP_DIR}/WAVM/Include/* ${HOME}/opt/wavm/include/.
cp -rvf ${TEMP_DIR}/WAVM/cmake/Include/* ${HOME}/opt/wavm/include/.
cd ${HOME}
#rm -rf ${TEMP_DIR}/WAVM

# temp directory
cd ${TEMP_DIR}
git clone https://github.com/ElementsProject/libwally-core.git
cd ${TEMP_DIR}/libwally-core
./tools/autogen.sh
./configure "CFLAGS=-fPIC" "CXXFLAGS=-fPIC" --disable-shared --prefix=${HOME}/opt/libwally-core/
make
make install

# install beast
cd ${HOME}/opt
git clone https://github.com/ChaiScript/ChaiScript.git
cd ${HOME}/opt/ChaiScript && git checkout v6.1.0



cd ${HOME}

