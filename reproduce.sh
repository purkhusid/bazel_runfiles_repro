#! /usr/bin/env bash

# This works fine
bazel clean
bazel run //:uploader --disk_cache=~/.cache/bazel-disk-cache --noexperimental_check_output_files --nobuild_runfile_links --remote_download_outputs=minimal

# This does not work if the build action is cached
bazel clean
bazel build //:uploader --disk_cache=~/.cache/bazel-disk-cache --noexperimental_check_output_files --nobuild_runfile_links --remote_download_outputs=minimal
bazel run //:uploader --disk_cache=~/.cache/bazel-disk-cache --noexperimental_check_output_files --nobuild_runfile_links --remote_download_outputs=minimal

# If we remove --noexperimental_check_output_files this works when the build action is cached and not cached
bazel clean
bazel build //:uploader --disk_cache=~/.cache/bazel-disk-cache --nobuild_runfile_links --remote_download_outputs=minimal
bazel run //:uploader --disk_cache=~/.cache/bazel-disk-cache --nobuild_runfile_links --remote_download_outputs=minimal

# If we remove --remote_download_outputs=minimal this works when the build action is cached and not cached
bazel clean
bazel build //:uploader --disk_cache=~/.cache/bazel-disk-cache --noexperimental_check_output_files --nobuild_runfile_links
bazel run //:uploader --disk_cache=~/.cache/bazel-disk-cache --noexperimental_check_output_files --nobuild_runfile_links

# If we remove --disk_cache this works
bazel clean
bazel build //:uploader --noexperimental_check_output_files --nobuild_runfile_links --remote_download_outputs=minimal
bazel run //:uploader --noexperimental_check_output_files --nobuild_runfile_links --remote_download_outputs=minimal
