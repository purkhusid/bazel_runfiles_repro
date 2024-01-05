load("@bazel_skylib//lib:shell.bzl", "shell")

_CONTENT_PREFIX = """\
#!/bin/bash

# --- begin runfiles.bash initialization v3 ---
# Copy-pasted from the Bazel Bash runfiles library v3.
set -uo pipefail; set +e; f=bazel_tools/tools/bash/runfiles/runfiles.bash
source "${RUNFILES_DIR:-/dev/null}/$f" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "${RUNFILES_MANIFEST_FILE:-/dev/null}" | cut -f2- -d' ')" 2>/dev/null || \
  source "$0.runfiles/$f" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "$0.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
  source "$(grep -sm1 "^$f " "$0.exe.runfiles_manifest" | cut -f2- -d' ')" 2>/dev/null || \
  { echo>&2 "ERROR: cannot find $f"; exit 1; }; f=; set -e
# --- end runfiles.bash initialization v3 ---

# Export RUNFILES_* envvars (and a couple more) for subprocesses.
runfiles_export_envvars

set -eou pipefail

"""

def _to_rlocation_path(ctx, file):
    if file.short_path.startswith("../"):
        return file.short_path[3:]
    else:
        return ctx.workspace_name + "/" + file.short_path

def _echoer_impl(ctx):
    content = [_CONTENT_PREFIX]
    runfiles = [ctx.file._bash_runfiles]
    echoer_executable = ctx.attr._echoer[DefaultInfo].files_to_run.executable

    command = "%s this_should_be_printed_to_stdout" % (
        "$(rlocation {})".format(_to_rlocation_path(ctx, echoer_executable)),
    )
    content.append(command)

    script = ctx.actions.declare_file(ctx.label.name + ".script")
    ctx.actions.write(
        output = script,
        content = "".join(content),
        is_executable = True,
    )
    runfiles.append(script)

    runfiles_depset = ctx.runfiles(
        files = runfiles,
    ).merge(ctx.attr._echoer[DefaultInfo].default_runfiles)
    return [
        DefaultInfo(executable = script, runfiles = runfiles_depset),
    ]

echoer = rule(
    implementation = _echoer_impl,
    attrs = {
        "_echoer": attr.label(
            allow_single_file = True,
            executable = True,
            default = "//rules/echoer:echoer",
            cfg = "exec",
        ),
        "_bash_runfiles": attr.label(
            default = "@bazel_tools//tools/bash/runfiles",
            allow_single_file = True,
        ),
    },
    executable = True,
)
