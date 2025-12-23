# ⚠️ Handling GitHub Action Outputs (JSON)
When using the `docker/build-push-action`, the build metadata is returned as a JSON-formatted string. Handling this directly in a run step via `${{ steps.id.outputs.metadata }}` is prone to failure.

# The Problem: Macro Substitution

GitHub Actions treats `${{ ... }}` as a macro. Before the shell script even starts, GitHub performs a literal "find and replace" in your YAML.

Result: If your JSON contains double quotes (e.g., `{"image": "app"}`), the shell command becomes echo {"image": "app"}.

Failure: The shell tries to interpret the internal quotes and special characters, leading to Syntax Error: unexpected token or malformed JSON files.

# The Solution: Environment Variable Injection
Instead of using the macro directly in the script, map the output to an environment variable first.

```YAML
- name: Save Metadata
  env:
  # 1. Map to ENV (Safe: handles quotes & special chars)
  METADATA: ${{ steps.build-and-push.outputs.metadata }}
  run: |
  # 2. Reference the ENV (Safe: treated as a literal string)
  echo "$METADATA" > metadata.json
```
  Why this works: GitHub injects the environment variable directly into the process memory of the shell. This bypasses the shell's string interpolation logic entirely, ensuring that the JSON structure—including its internal quotes—remains perfectly intact.