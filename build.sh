#!/bin/bash
########################################################
# make pvbrowser                                       #
# if you want to use VTK uncommet CONFIG += USE_VTK in #
# pvrowser/pvbrowser.pro                               #
########################################################

# detect real OS on different linux distries
export PVB_OSTYPE="unknown"
if [ "$OSTYPE" == "linux" ]; then
  export PVB_OSTYPE="linux"
fi
if [ "$OSTYPE" == "gnu-linux" ]; then
  export PVB_OSTYPE="linux"
fi
if [ "$OSTYPE" == "linux-gnu" ]; then
  export PVB_OSTYPE="linux"
fi

if [ "$2"    != "buildservice" ]; then
if [ "$HOME" != "/root"        ]; then
if [ "$HOME" != "/home/lehrig" ]; then
if [ "$HOME" != "/home/rainer" ]; then
  echo "############################################################################"
  echo "We are not at home. Please edit this file.                                  "
  echo "You have to define QTDIR, QMAKESPEC and perhaps TCLLIBPATH (if you want VTK)"
  # echo "If you want VTK you have to uncomment USE_VTK in pvb/pvbrowser/pvbrowser.pro"
  # echo "If you want VTK you need Tcl/Tk                                             "
  # echo "If you want VTK install from http://www.kitware.com/vtk and configure with: "
  # echo "  build shared libraries: ON                                                "
  # echo "  wrap Tcl: ON                                                              "
  # echo "You need to install the openGL development package (mesa) !!!               "
  echo "please adjust the following:                                                "
  echo "Or leave it as it is, when your distribution has Qt4 preinstalled           "
  echo "############################################################################"
  #
  # OS-X
  # this export we use under OS-X with xcode_2.4.1_8m1910_6936315.dmg and Qt
  # export QMAKESPEC=/usr/local/Qt4.6/mkspecs/macx-g++
  #
  echo "######################################"
  echo "# then remove the exit command below #"
  echo "######################################"
  exit
fi
fi
fi
if [ "$HOME" == "/home/lehrig" ]; then
  echo "We are at home"
  export QTDIR=/usr/share/qt4
  export QMAKESPEC=/usr/share/qt4/mkspecs/linux-g++
  #export QTDIR=/usr/local/Trolltech/Qt-4.2.1
  #export QMAKESPEC=/usr/local/Trolltech/Qt-4.2.1/mkspecs/linux-g++
  #export PATH=/usr/local/Trolltech/Qt-4.2.1/bin:$PATH
  export TCLLIBPATH=/home/lehrig/temp/VTK5/VTK/Wrapping/Tcl
fi
fi

export LIBPTHREAD='-pthread'
cd qwt
cd src
../../qmake.sh src.pro
make $1
cd ..
cd designer
../../qmake.sh designer.pro
make $1
cd ..
cd textengines
../../qmake.sh textengines.pro
make $1
cd ..
../qmake.sh qwt.pro 
make $1
cd ..
cp qwt/designer/plugins/designer/libqwt_designer_plugin.so designer/plugins/
cd pvbrowser
../qmake.sh pvbrowser.pro
make $1
cd ..
cd browserplugin
../qmake.sh pvpluginmain.pro
make $1
cd ..
cd pvdevelop
../qmake.sh pvdevelop.pro
make $1
cd ..
cd designer/src
./build.sh
cd ../..
cd pvserver
rm util.o glencode.o
../qmake.sh pvsid.pro -o pvsid.mak
make -f pvsid.mak
rm util.o glencode.o
../qmake.sh pvsmt.pro -o pvsmt.mak
make -f pvsmt.mak

if [ "$PVB_OSTYPE" == "linux" ]; then
  rm util.o glencode.o
  ../qmake.sh processviewserver.pro
  make
fi

cd ..
cd rllib/lib
../../qmake.sh lib.pro
make
cd ../..
cd rllib/rlsvg
../../qmake.sh rlsvgcat.pro
make
cd ../..
cd rllib/rlhistory
../../qmake.sh rlhistory.pro
make
cd ../..
cd start_pvbapp
../qmake.sh start_pvbapp.pro
make
cd ..
cd pvsexample
../qmake.sh pvsexample.pro
cd ..
if [ "$PVB_OSTYPE" == "linux" ]; then
cd language_bindings
#  ./build_python_interface.sh noswig
./build_lua_interface.sh
cd ..
fi
echo '################################################################'
echo '# finished !!!                                                 #'
echo '# verify that no errors occured by running me again            #'
echo '# now run:                                                     #'
echo '#   su                                                         #'
echo '#   ./install.sh                                               #'
echo '#   exit                                                       #'
echo '# if you want to use Qt Designer for designing your masks,     #'
echo '#   copy the plugins to Qt Designer (read designer/README.txt) #'
echo '# Have a lot of fun (Yours pvbrowser community)                #'
echo '################################################################'
