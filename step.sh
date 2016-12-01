#!/usr/bin/env bash

function debug_echo {
	local msg="$1"
	if [[ "${is_debug}" == "yes" ]] ; then
		echo "${msg}"
	fi
}

debug_echo
debug_echo "==> Start"

command -v cordova >/dev/null 2>&1 || {
    echo "===> Cordova is not installed, installing now..."
     npm install -g cordova

     if [ $? -ge 1 ]; then
        echo "Failed to install cordova using npm"
        exit 1;
     fi
}

if [ ! -z "$cordova_dir" ] ; then
  debug_echo "==> Switching to working directory: $cordova_dir"
  cd "$cordova_dir"
  if [ $? -ne 0 ] ; then
    echo " [!] Failed to switch to working directory: $cordova_dir"
    exit 1
  fi
fi

debug_echo "is_debug: $is_debug"
debug_echo "cordova_dir: $cordova_dir"
debug_echo "cordova command: $cordova_command"
debug_echo "platform_name: $platform_name"
debug_echo "build_options: $build_options"

if [[ "$cordova_command" == *"add" ]]
then
    if [ ! -z "$(cordova platform ls | awk '/platforms:$/,/^Available/ { print }' | grep "$platform_name")" ]; then
        echo "===> $platform_name is aready installed"
    fi
    exit 0
fi

if [ "$cordova_command" == "build" ] ; then
    echo "===> Running 'cordova $cordova_command $platform_name $build_options'"
    cordova $cordova_command $platform_name $build_options
fi


