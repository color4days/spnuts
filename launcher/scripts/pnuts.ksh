#!/bin/ksh -p

PNUTS_HOME=$(dirname $(whence -p $0))/..

integer i=0 j=0

if [ "x${HTTP_PROXY_HOST}" != "x" ] && [ "x${HTTP_PROXY_PORT}" != "x" ]; then
   flags[i]="-Dhttp.proxyHost=${HTTP_PROXY_HOST}"
   i=i+1
   flags[i]="-Dhttp.proxyPort=${HTTP_PROXY_PORT}"
   i=i+1
fi

for a in "$@"
do
    case "$a" in
    -J*)
	  flags[i]=${a#-J}
	  i=i+1 ;;
    -v|-vd|-d)
          export JAVA_COMPILER=NONE
          args[j]=$a
	  j=j+1 ;;
    *)
          args[j]=$a
	  j=j+1 ;;
    esac
done

sysname=$(uname -s)
case $sysname in
    CYGWIN*)
      PNUTS_HOME=$(cygpath -m ${PNUTS_HOME})
      PATHSEP=";"
      ;;
    Darwin*)
      export DYN_LIBRARY_PATH=${DYN_LIBRARY_PATH}:${PNUTS_HOME}/lib
      PATHSEP=":"
      ;;
    *)
      export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${PNUTS_HOME}/lib
      PATHSEP=":"
      ;;
esac

if [ "${PNUTS_JDK11_COMPATIBLE}" = "true" ]; then
  CLASSPATH=${PNUTS_HOME}/lib/pnuts.jar${PATHSEP}${CLASSPATH}
  export CLASSPATH
else
  flags[i]=-Xbootclasspath/a:${PNUTS_HOME}/lib/pnuts.jar
fi

MODULE_DIR=${PNUTS_HOME}/modules

if [ "x${PNUTS_MODULE}" = "x" ]; then
  module=pnuts.tools
else
  module=${PNUTS_MODULE}
fi

if [ "x${PNUTS_JAVA_COMMAND}" = "x" ]; then
   java="java"
else
   java=${PNUTS_JAVA_COMMAND}
fi
exec ${java} "${flags[@]}" "-Dpnuts.home=${PNUTS_HOME}" "-Djava.endorsed.dirs=${MODULE_DIR}" pnuts.tools.Main -m "${module}" "${args[@]}"

