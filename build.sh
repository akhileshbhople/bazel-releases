
lftp -c "open -u  $USER,$PASS ftp://oplab9.parqtec.unicamp.br; mkdir /ppc64el/bazel/ubuntu_16.04/latest" 
lftp -c "open -u  $USER,$PASS ftp://oplab9.parqtec.unicamp.br; mkdir /ppc64el/bazel/ubuntu_14.04/latest"
python3 bazel-version.py
if [ $(cat current_version.txt) != $(cat ftp_version.txt) ]
then
    version=$(cat current_version.txt)
    del_version=$(cat delete_version.txt)
    old_version=$(cat ftp_version.txt)
    sudo mkdir build
    cd build
    sudo wget https://github.com/bazelbuild/bazel/releases/download/$version/bazel-$version-dist.zip
    sudo unzip bazel-$version-dist.zip
    sudo EXTRA_BAZEL_ARGS=--host_javabase=@local_jdk//:jdk ./compile.sh
    sudo mv output/bazel output/bazel_bin_ppc64le_$version
    if [ $version > old_version ]
    then
        lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O /ppc64el/bazel/$OS/latest /home/travis/build/Unicamp-OpenPower/bazel-releases/build/output/bazel_bin_ppc64le_$version" 
        lftp -c "open -u $USER,$PASS ftp://oplab9.parqtec.unicamp.br; rm /ppc64el/bazel/$OS/latest/bazel_bin_ppc64le_$old_version" 
    fi
    lftp -c "open -u  $USER,$PASS ftp://oplab9.parqtec.unicamp.br; put -O /ppc64el/bazel/$OS /home/travis/build/Unicamp-OpenPower/bazel-releases/build/output/bazel_bin_ppc64le_$version" 
    lftp -c "open -u  $USER,$PASS ftp://oplab9.parqtec.unicamp.br; rm /ppc64el/bazel/$OS/bazel_bin_ppc64le_$del_version" 
fi
