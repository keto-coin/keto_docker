#!/bin/bash

function build {
    if [ $# -ne 2 ]; then
        echo "Must provide the path to the avertem build and version $#"
        exit -1
    fi

    AVERTEM_BUILD=$1
    AVERTEM_VERSION=$2
    AVERTEM_DATE=`date`

    mkdir -p release/avertem/opt/avertem/tmp
    mkdir -p release/avertem/opt/avertem/document_root
    mkdir -p release/avertem/opt/avertem/data
    mkdir -p release/avertem/opt/avertem/bin
    mkdir -p release/avertem/opt/avertem/lib
    mkdir -p release/avertem/opt/avertem/log
    mkdir -p release/avertem/opt/avertem/keys
    mkdir -p release/avertem/opt/avertem/shared
    mkdir -p release/avertem/opt/avertem/upgrade
    mkdir -p release/avertem/opt/avertem/etc
    mkdir -p release/avertem/debian
    mkdir -p release/avertem/etc
    mkdir -p release/avertem/lib
    mkdir -p release/avertem/opt/avertem/config

    echo `pwd`
    #find ./

    sed "s/VERSION_TAG/$AVERTEM_VERSION/g" release/resources/debian/control > release/avertem/debian/control
    sed "s/VERSION_TAG/$AVERTEM_VERSION/g" release/resources/debian/changelog > release/avertem/debian/changelog
    cp release/debian/compat    release/avertem/debian/.
    cp release/debian/config    release/avertem/debian/.
    cp release/debian/rules    release/avertem/debian/.
    cp release/debian/postinst    release/avertem/debian/.
    cp release/debian/templates    release/avertem/debian/.
    cp -rf release/etc    release/avertem/etc/.

    sed -i "s/DATE_TAG/$AVERTEM_DATE/g" release/avertem/debian/changelog
    echo "$AVERTEM_VERSION" > release/avertem/opt/avertem/config/avertem_version
    echo "1" > release/avertem/opt/avertem/config/auto_upgrade

    cp release/opt/avertem/config/cli_config.ini release/avertem/opt/avertem/config/.
    cp -f $AVERTEM_BUILD/bin/* release/avertem/opt/avertem/bin/.
    find release/avertem/opt/avertem/bin/ -type f -exec grep -IL . "{}" \; | xargs strip -vsp
    cp -f $AVERTEM_BUILD/shared/* release/avertem/opt/avertem/shared/.
    find release/avertem/opt/avertem/shared/ -type f -exec grep -IL . "{}" \; | xargs strip -vsp
    cp -rf $AVERTEM_BUILD/keys/* release/avertem/opt/avertem/keys/.
    cp -rf $AVERTEM_BUILD/document_root/* release/avertem/opt/avertem/document_root/.
    cp -rf $AVERTEM_BUILD/upgrade/* release/avertem/opt/avertem/upgrade/.
    find ./

    cd release/avertem && fakeroot debian/rules binary && cd -


    cd release/avertem/opt/avertem/shared/ && tar -zcvf ../../../../avertem_shared_$AVERTEM_VERSION.tar.gz * && cd -
    #find ./
    cp -f release/avertem_${AVERTEM_VERSION}_all.deb /opt/avertem/target/
    cp -f release/avertem_shared_$AVERTEM_VERSION.tar.gz /opt/avertem/target/
    echo "$AVERTEM_VERSION" > /opt/avertem/target/latest_version.txt

    #s3cmd --acl-public --recursive put $avertem_VERSION s3://avertem-release/linux/ubuntu/
    #s3cmd --acl-public --recursive put latest_version.txt s3://avertem-release/linux/ubuntu/
    #echo "Clean up the version"
    #rm -rf $avertem_VERSION
}


function clean {
    cd avertem && debian/rules clean && cd ..
    rm -rf avertem/opt/avertem/bin
    rm -rf avertem/opt/avertem/shared
    rm -rf avertem/opt/avertem/keys
    rm -rf avertem/opt/avertem/document_root
    rm -rf avertem/opt/avertem/upgrade
}


if [ "$1" ==  "build" ]; then
    build $2 $3
elif [ "$1" ==  "clean" ]; then
    clean
else
    echo "Unrecognised parameters"
    echo "  ./build.sh build <build path> <version>"
    echo "  ./build.sh clean"
fi
