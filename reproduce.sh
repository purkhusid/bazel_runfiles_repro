#! /usr/bin/env bash

# This works fine
bazel clean
bazel run //:uploader --disk_cache=~/.cache/bazel-disk-cache --noexperimental_check_output_files --remote_download_outputs=minimal

# This does not work if the build action is cached
bazel clean
bazel build //:uploader --disk_cache=~/.cache/bazel-disk-cache --noexperimental_check_output_files --remote_download_outputs=minimal
bazel run //:uploader --disk_cache=~/.cache/bazel-disk-cache --noexperimental_check_output_files --remote_download_outputs=minimal

# If we remove --noexperimental_check_output_files this works when the build action is cached and not cached
bazel clean
bazel build //:uploader --disk_cache=~/.cache/bazel-disk-cache --remote_download_outputs=minimal
bazel run //:uploader --disk_cache=~/.cache/bazel-disk-cache --remote_download_outputs=minimal

# If we remove --remote_download_outputs=minimal this works when the build action is cached and not cached
bazel clean
bazel build //:uploader --disk_cache=~/.cache/bazel-disk-cache --noexperimental_check_output_files bazel run //:uploader --disk_cache=~/.cache/bazel-disk-cache --noexperimental_check_output_files 
# If we remove --disk_cache this works
bazel clean
bazel build //:uploader --noexperimental_check_output_files --remote_download_outputs=minimal
bazel run //:uploader --noexperimental_check_output_files --remote_download_outputs=minimal
