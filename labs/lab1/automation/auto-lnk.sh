#! /bin/bash

rm ds7002*
cd lnk
python mylnk.py
mv ds7002.lnk ..
cd ..
zip ds7002.zip ds7002.lnk