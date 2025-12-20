#!/usr/bin/env bash
set -euo pipefail

# extract-image-ref.sh
#
# Purpose:
#   Read Buildx build result metadata (JSON) and output an "immutable image reference":
#     <registry>/<image>:<tag>@<digest>
#
# Your special rule:
#   - Keep the registry host from image.name (e.g., tomjfrog.jfrog.io)
#   - Omit the repository segment (e.g., imagelifecycle-docker-local)
#   - Keep the final image:tag (e.g., hello-frog:13)
#   - Append containerimage.digest (e.g., @sha256:...)
#
# Input:
#   JSON on STDIN (this matches docker/build-push-action's `metadata` output).
#
# Output:
#   Prints a single line: "<registry>/<image>:<tag>@<digest>"
#
# Example:
#   echo "$METADATA_JSON" | ./extract-image-ref.sh
# Note: This is incredibly cumbersome and should be handled in a much more elegant way by the JFrog CLI in the future.

if ! command -v jq >/dev/null 2>&1; then
  echo "ERROR: jq is required but not installed." >&2
  exit 2
fi

jq -r '
  ."image.name" as $image
  | ."containerimage.digest" as $digest
  | ($image | split("/")) as $parts
  | if ($parts | length) < 3 then
      halt_error(2; "image.name must look like <registry>/<repo>/<image>:<tag>")
    else
      "\($parts[0])/\($parts[2])@\($digest)"
    end
'
