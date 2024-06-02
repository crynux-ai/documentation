#!/bin/bash

release_version=$1
mac_link=$2
windows_download_link=$3
windows_preview_link=$4
linux_download_link=$5
linux_preview_link=$6

if [ -z "${release_version}" ]; then
  echo "Please specify the release version"
  exit 0
fi

if [ -z "${mac_link}" ]; then
  echo "Please specify the mac link"
  exit 0
fi

if [ -z "${windows_download_link}" ]; then
  echo "Please specify the windows link"
  exit 0
fi

if [ -z "${windows_preview_link}" ]; then
  echo "Please specify the linux link"
  exit 0
fi

if [ -z "${linux_download_link}" ]; then
  echo "Please specify the windows link"
  exit 0
fi

if [ -z "${linux_preview_link}" ]; then
  echo "Please specify the linux link"
  exit 0
fi

windows_download_link_escaped=$(printf '%s\n' "$windows_download_link" | sed -e 's/[\/&]/\\&/g')
windows_preview_link_escaped=$(printf '%s\n' "$windows_preview_link" | sed -e 's/[\/&]/\\&/g')
mac_link_escaped=$(printf '%s\n' "$mac_link" | sed -e 's/[\/&]/\\&/g')
linux_download_link_escaped=$(printf '%s\n' "$linux_download_link" | sed -e 's/[\/&]/\\&/g')
linux_preview_link_escaped=$(printf '%s\n' "$linux_preview_link" | sed -e 's/[\/&]/\\&/g')


files=(
  "README.md"
  "node-hosting/start-a-node/README.md"
  "node-hosting/start-a-node/start-a-node-windows.md"
  "node-hosting/start-a-node/start-a-node-mac.md"
  "node-hosting/start-a-node/start-a-node-linux.md"
)

for file in "${files[@]}"
do
	echo "processing file: $file"

	cp "templates/$file" "gitbook/$file"

	# replace file links
	sed -i "s/RELEASE_VERSION/$release_version/g" "gitbook/$file"
	sed -i "s/WINDOWS_DOWNLOAD_LINK/$windows_download_link_escaped/g" "gitbook/$file"
	sed -i "s/WINDOWS_PREVIEW_LINK/$windows_preview_link_escaped/g" "gitbook/$file"
	sed -i "s/MAC_LINK/$mac_link_escaped/g" "gitbook/$file"
	sed -i "s/LINUX_DOWNLOAD_LINK/$linux_download_link_escaped/g" "gitbook/$file"
	sed -i "s/LINUX_PREVIEW_LINK/$linux_preview_link_escaped/g" "gitbook/$file"
done
