#!/bin/bash

release_version=$1
mac_link=$2
windows_link=$3
linux_link=$4

if [ -z "${release_version}" ]; then
  echo "Please specify the release version"
  exit 0
fi

if [ -z "${mac_link}" ]; then
  echo "Please specify the mac link"
  exit 0
fi

if [ -z "${windows_link}" ]; then
  echo "Please specify the windows link"
  exit 0
fi

if [ -z "${linux_link}" ]; then
  echo "Please specify the linux link"
  exit 0
fi

windows_link_escaped=$(printf '%s\n' "$windows_link" | sed -e 's/[\/&]/\\&/g')
mac_link_escaped=$(printf '%s\n' "$mac_link" | sed -e 's/[\/&]/\\&/g')
linux_link_escaped=$(printf '%s\n' "$linux_link" | sed -e 's/[\/&]/\\&/g')


files=(
  "README.md"
  "node-hosting/start-a-node-windows.md"
  "node-hosting/start-a-node-mac.md"
  "node-hosting/start-a-node-linux.md"
)

for file in "${files[@]}"
do
	echo "processing file: $file"

	cp "templates/$file" "gitbook/$file"

	# replace file links
	sed -i "s/RELEASE_VERSION/$release_version/g" "gitbook/$file"
	sed -i "s/WINDOWS_LINK/$windows_link_escaped/g" "gitbook/$file"
	sed -i "s/MAC_LINK/$mac_link_escaped/g" "gitbook/$file"
	sed -i "s/LINUX_LINK/$linux_link_escaped/g" "gitbook/$file"
done
