python3 build.py clean
python3 build.py build -t release 2>&1 | tee logs.log 
python3 build.py install
python3 build.py install --prefix $PWD/../../cangjie_compiler/output

