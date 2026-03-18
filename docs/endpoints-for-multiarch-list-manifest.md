# Endpoints to Fetch Information About `list.manifest.json` (Multi-Arch Image)

**Artifact path:** `p-apitesting-docker-multiarch-local/hello-frog-multi-arch/11/list.manifest.json`

- **Repository key:** `p-apitesting-docker-multiarch-local`
- **Item path (within repo):** `hello-frog-multi-arch/11/list.manifest.json`

Base URL for Artifactory on your instance: `https://tomjfrog.jfrog.io/artifactory` (or your configured host). All paths below are relative to that base.

---

## 1. Artifactory – Storage / File Info (primary for “as much information as we can”)

**Spec:** `artifacts-and-storage-api.openapi.yaml` (Storage Info, Artifact Retrieval)

### GET Item Info (file metadata, checksums, timestamps)

```
GET /api/storage/{repoKey}/{itemPath}
```

**Example:**
```
GET https://tomjfrog.jfrog.io/artifactory/api/storage/p-apitesting-docker-multiarch-local/hello-frog-multi-arch/11/list.manifest.json
```

**Returns:** JSON with `uri`, `repo`, `path`, `created`, `createdBy`, `lastModified`, `modifiedBy`, `size`, `mimeType`, `checksums` (md5, sha1, sha256), `originalChecksums`, `downloadUri`, etc. This is the main endpoint for “as much information as we can” for this file.

#### Recorded result (Group 1)

**Config:** `jfrog_url` and `jfrog_access_token` from **rest-apis** repo `test_config.yaml`.

**Request:**
```
GET {jfrog_url}/artifactory/api/storage/p-apitesting-docker-multiarch-local/hello-frog-multi-arch/11/list.manifest.json
Authorization: Bearer <token from test_config.yaml>
```

**HTTP status:** `200`

**Response body:**
```json
{
  "repo": "p-apitesting-docker-multiarch-local",
  "path": "/hello-frog-multi-arch/11/list.manifest.json",
  "created": "2026-03-18T15:29:05.628Z",
  "createdBy": "tomj@jfrog.com",
  "lastModified": "2026-03-18T15:29:05.628Z",
  "modifiedBy": "tomj@jfrog.com",
  "lastUpdated": "2026-03-18T15:29:06.121Z",
  "downloadUri": "https://tomjfrog.jfrog.io/artifactory/p-apitesting-docker-multiarch-local/hello-frog-multi-arch/11/list.manifest.json",
  "mimeType": "application/json",
  "size": "1609",
  "checksums": {
    "sha1": "d2a79827c62961ee50f064938338f5e56f64b15c",
    "md5": "cae373df7b77c7ad36a4ca0ee0ad8c63",
    "sha256": "21a2be7d3e45134541b1d9edd62cdce91ae300999c6d8ec78690be6177d7768e"
  },
  "originalChecksums": {
    "sha256": "21a2be7d3e45134541b1d9edd62cdce91ae300999c6d8ec78690be6177d7768e"
  },
  "uri": "https://tomjfrog.jfrog.io/artifactory/api/storage/p-apitesting-docker-multiarch-local/hello-frog-multi-arch/11/list.manifest.json"
}
```

---

### GET Item Info + query parameters (same path, different “views”)

Same path with optional query params for extra or focused data:

| Purpose | Query | Example |
|--------|--------|--------|
| Item properties only | `?properties` or `?properties=prop1,prop2` | `GET .../list.manifest.json?properties` |
| Last modified | `?lastModified` | `GET .../list.manifest.json?lastModified` |
| File statistics (download count, last downloaded) | `?stats` | `GET .../list.manifest.json?stats` |
| Folder listing (for parent folder) | `?list` (optionally `&deep=1`, `&depth=N`, `&listFolders=1`, `&mdTimestamps=1`, `&includeRootPath=1`) | Use on parent path `hello-frog-multi-arch/11/` |

**Examples:**
```
GET .../api/storage/p-apitesting-docker-multiarch-local/hello-frog-multi-arch/11/list.manifest.json?properties
GET .../api/storage/p-apitesting-docker-multiarch-local/hello-frog-multi-arch/11/list.manifest.json?stats
GET .../api/storage/p-apitesting-docker-multiarch-local/hello-frog-multi-arch/11?list&deep=1
```

---

## 2. Artifactory – Download / Raw content

**Spec:** `artifacts-and-storage-api.openapi.yaml` (Artifact Retrieval)

### GET Retrieve artifact (file content)

```
GET /{repoKey}/{artifactPath}
```

**Example:**
```
GET https://tomjfrog.jfrog.io/artifactory/p-apitesting-docker-multiarch-local/hello-frog-multi-arch/11/list.manifest.json
```

**Returns:** Raw file body (the JSON content of `list.manifest.json`). Use when you need the actual manifest content (e.g. list of manifest digests for the multi-arch image).

---

### GET Artifact sync download (optional no-content / progress)

```
GET /api/download/{repoKey}/{filePath}
```

Optional: `?content=none` or `?content=progress` and `?mark=<bytes>`.

**Example:**
```
GET https://tomjfrog.jfrog.io/artifactory/api/download/p-apitesting-docker-multiarch-local/hello-frog-multi-arch/11/list.manifest.json
```

---

## 3. Artifactory – Search (AQL)

**Spec:** `artifactory-search-api.openapi.yaml`

### POST AQL – find artifact by path (and get repo/path/name/sha256/etc.)

```
POST /api/search/aql
Content-Type: text/plain
```

**Body (AQL):**
```aql
items.find({
  "repo": "p-apitesting-docker-multiarch-local",
  "path": "hello-frog-multi-arch/11",
  "name": "list.manifest.json"
}).include("name", "repo", "path", "actual_sha1", "actual_md5", "sha256", "size", "created", "modified", "updated", "created_by", "modified_by", "type")
```

**Example:**
```
POST https://tomjfrog.jfrog.io/artifactory/api/search/aql
Content-Type: text/plain

items.find({"repo":"p-apitesting-docker-multiarch-local","path":"hello-frog-multi-arch/11","name":"list.manifest.json"}).include("name","repo","path","actual_sha1","actual_md5","sha256","size","created","modified","updated","created_by","modified_by","type")
```

**Returns:** Search result set with the fields you requested. Useful when you want to query by path/name and get checksums and timestamps in one call.

---

## 4. Artifactory – File compliance (deprecated)

**Spec:** `artifacts-and-storage-api.openapi.yaml` (deprecated)

### GET Compliance info (license / vulnerabilities for path)

```
GET /api/compliance/{repoKey}/{item-path}
```

**Example:**
```
GET https://tomjfrog.jfrog.io/artifactory/api/compliance/p-apitesting-docker-multiarch-local/hello-frog-multi-arch/11/list.manifest.json
```

**Note:** Deprecated from Artifactory 5.0; prefer Xray for compliance/security.

---

## 5. Docker API (catalog / tags – image-level, not this file)

**Spec:** `artifactory-artifacts-api.openapi.yaml` (and inventory)

These apply to the Docker image (e.g. `hello-frog-multi-arch`) and its tags, not to the single file `list.manifest.json`:

- `GET /api/docker/{repo-key}/v2/_catalog` – list image names in the repo.
- `GET /api/docker/{repo-key}/v2/{image_name}/manifests/{tag}` – get manifest for a tag (OCI/Docker manifest; different from `list.manifest.json` on disk).

For your repo/image:
```
GET https://tomjfrog.jfrog.io/artifactory/api/docker/p-apitesting-docker-multiarch-local/v2/_catalog
GET https://tomjfrog.jfrog.io/artifactory/api/docker/p-apitesting-docker-multiarch-local/v2/hello-frog-multi-arch/manifests/11
```

Use these when you need **image/tag** metadata; for the **file** `list.manifest.json` use the storage and download endpoints above.

---

## 6. Xray – Artifact / component summary (if Xray is enabled)

If your platform has Xray, it often exposes an API to get summary (and sometimes scan) information for artifacts by path. The exact path may vary by version (e.g. under `/xray/` or platform router). Typical pattern:

- **Input:** Artifactory path such as `p-apitesting-docker-multiarch-local/hello-frog-multi-arch/11/list.manifest.json` (or an array of paths).
- **Returns:** Component/summary and possibly vulnerability/license data for that artifact.

Check your Xray/Platform REST docs or the “Artifacts Summary” / “Get Artifacts Summary” style endpoints for the current URL and body format.

---

## Getting detailed information for each manifest in the list

A **manifest list** (`list.manifest.json`) is an OCI image index: a JSON document with a **`manifests`** array. Each entry describes one platform-specific image manifest and includes:

- **`digest`** – e.g. `sha256:abc123...` – references the actual manifest blob
- **`mediaType`** – e.g. `application/vnd.oci.image.manifest.v1+json`
- **`platform`** (optional) – `architecture`, `os`, etc.

You do **not** need AQL to get detailed information about each of these manifests. You can use **Docker/OCI API endpoints** that work with a **digest**. AQL (or search by checksum) is useful when you want **Artifactory storage metadata** (path, size, created date) for the blob that stores each manifest.

### Option A: Docker API – manifest content by digest (no AQL)

Use the **manifest by digest** endpoint to fetch the content of each individual manifest (config, layers, etc.):

```
GET /api/docker/{repo-key}/v2/{image_name}/manifests/{digest}
```

- **`{digest}`** is the value from `manifests[].digest` in the list (e.g. `sha256:21a2be7d3e45...`).
- **Returns:** The image manifest JSON (config descriptor, layer descriptors) for that platform.
- **Header:** Use `Accept: application/vnd.oci.image.manifest.v1+json` or `application/vnd.docker.distribution.manifest.v2+json` as needed.

**Example** (once you have a digest from the list):

```
GET .../artifactory/api/docker/p-apitesting-docker-multiarch-local/v2/hello-frog-multi-arch/manifests/sha256:<digest_from_list>
Accept: application/vnd.oci.image.manifest.v1+json
```

**Workflow:**  
1. GET the manifest list (raw): `GET /{repo}/hello-frog-multi-arch/11/list.manifest.json`  
2. Parse JSON → `manifests[]`  
3. For each entry, call `GET .../v2/hello-frog-multi-arch/manifests/{manifests[i].digest}` to get that manifest’s full content.

---

### Option B: Artifactory storage metadata for each manifest blob

If you need **Artifactory-level** details (repo path, size, created, modified, checksums) for the **file** that stores each manifest:

1. **Search by checksum** (then storage API):
   - `GET /api/search/checksum?sha256={hex}`  
     Use the digest’s hash part only (no `sha256:` prefix) as `{hex}`.  
   - Response gives artifact path(s). Then:
   - `GET /api/storage/{repoKey}/{path}` for full file info.

2. **AQL** (alternative to search/checksum):
   - Find artifacts with that checksum and include path/storage fields:
   ```aql
   items.find({"repo": "p-apitesting-docker-multiarch-local", "sha256": "<hex_from_digest>"})
     .include("name", "repo", "path", "sha256", "size", "created", "modified")
   ```
   - Then use `GET /api/storage/{repoKey}/{path}` for full metadata if needed.

So:

- **Manifest content (config + layers):** use the **Docker API** with the digest from the list; **no AQL**.
- **Artifactory metadata (path, size, dates):** use **search by checksum** or **AQL** to get path (and optionally other fields), and optionally **GET /api/storage/...** for full storage info.

---

## Recorded results: Option A vs Option B

Config and source list: **rest-apis** `test_config.yaml`; manifest list at `p-apitesting-docker-multiarch-local/hello-frog-multi-arch/11/list.manifest.json`. The list contained **4** manifests:

| Index | Digest (short) | Platform |
|-------|-----------------|----------|
| 0 | sha256:f97133c3a664... | amd64 / linux |
| 1 | sha256:6b7c9eba1b9e... | arm64 / linux |
| 2 | sha256:2847d876431f... | unknown / unknown |
| 3 | sha256:93827b5641ac... | unknown / unknown |

### Option A: Docker API – manifest by digest

**Request (per digest):** `GET {base}/artifactory/api/docker/p-apitesting-docker-multiarch-local/v2/hello-frog-multi-arch/manifests/{digest}` with `Accept: application/vnd.oci.image.manifest.v1+json`.

**Result:** HTTP 200 for all four. Response is the **image manifest** (config descriptor + layer descriptors). No Artifactory path or file metadata.

**Example – index 0 (amd64/linux):**

```json
{
  "schemaVersion": 2,
  "mediaType": "application/vnd.oci.image.manifest.v1+json",
  "config": {
    "mediaType": "application/vnd.oci.image.config.v1+json",
    "digest": "sha256:dc592ff9ebfe9bf3f8ec089929e4b541ab32b5cf121f342b210279ed688c1ece",
    "size": 5071
  },
  "layers": [
    { "mediaType": "application/vnd.oci.image.layer.v1.tar+gzip", "digest": "sha256:589002ba0eaed1...", "size": 3861821 },
    { "mediaType": "application/vnd.oci.image.layer.v1.tar+gzip", "digest": "sha256:0805a1082be0e...", "size": 460948 },
    { "mediaType": "application/vnd.oci.image.layer.v1.tar+gzip", "digest": "sha256:3566efde290bd...", "size": 13370946 },
    { "mediaType": "application/vnd.oci.image.layer.v1.tar+gzip", "digest": "sha256:2800a7aef8b13...", "size": 248 },
    { "mediaType": "application/vnd.oci.image.layer.v1.tar+gzip", "digest": "sha256:8de77b33db5d6...", "size": 133 }
  ]
}
```

So **Option A** gives you **image structure** (config + layers, sizes, digests) for each platform.

---

### Option B: Search by checksum + storage API

**Step 1 – Search:** `GET {base}/artifactory/api/search/checksum?sha256={hex}` (digest without `sha256:` prefix).

**Result:** Search returns a `results` array of **URIs** pointing to artifacts with that checksum, e.g.:

- `.../api/storage/p-apitesting-docker-multiarch-local/hello-frog-multi-arch/sha256:{digest}/manifest.json`
- `.../api/storage/.../hello-frog-multi-arch/_uploads/manifest-sha256__{digest}.json`

**Step 2 – Storage:** From a result URI, derive `repo` and path and call `GET {base}/artifactory/api/storage/{repoKey}/{path}`.

**Example – storage response for index 0 (amd64 manifest blob):**

Path used: `hello-frog-multi-arch/sha256:f97133c3a664254ad6f384c80342fe0da2ad8d55bcc6d84e56634c529ac0fc74/manifest.json`

```json
{
  "repo": "p-apitesting-docker-multiarch-local",
  "path": "/hello-frog-multi-arch/sha256:f97133c3a664254ad6f384c80342fe0da2ad8d55bcc6d84e56634c529ac0fc74/manifest.json",
  "created": "2026-03-18T15:29:02.409Z",
  "createdBy": "tomj@jfrog.com",
  "lastModified": "2026-03-18T15:29:02.409Z",
  "modifiedBy": "tomj@jfrog.com",
  "lastUpdated": "2026-03-18T15:29:02.881Z",
  "downloadUri": "https://tomjfrog.jfrog.io/artifactory/.../manifest.json",
  "mimeType": "application/json",
  "size": "1241",
  "checksums": {
    "sha1": "c336379450d3bddf0f88606c6bb63cfaedc3a616",
    "md5": "d96ef1698cc785925e5230bb938618e3",
    "sha256": "f97133c3a664254ad6f384c80342fe0da2ad8d55bcc6d84e56634c529ac0fc74"
  },
  "originalChecksums": { "sha256": "f97133c3a664254ad6f384c80342fe0da2ad8d55bcc6d84e56634c529ac0fc74" },
  "uri": "https://tomjfrog.jfrog.io/artifactory/api/storage/.../manifest.json"
}
```

So **Option B** gives you **Artifactory file metadata** (path, size, created/modified, checksums, downloadUri) for the manifest **file** in storage, not the parsed config/layers.

---

### Comparison

| Aspect | Option A (Docker API) | Option B (Search + storage) |
|--------|------------------------|-----------------------------|
| **What you get** | Image manifest content: config digest + list of layer digests/sizes | Artifactory artifact record: path, size, created, modified, checksums |
| **Use when** | You need config/layers, pull simulation, or layer-level logic | You need repo path, file size, upload time, or storage/audit data |
| **Input** | Digest from list (e.g. `sha256:xxx`) | SHA256 hex (same digest, no prefix) |
| **Output shape** | OCI/Docker manifest JSON | Storage API file info JSON |

---

### Option B + AQL: additional information

Using **AQL** instead of (or after) search/checksum for the same task **does** return extra information that the storage API does not include in its default response:

1. **Properties in one response**  
   The storage API only returns properties when you call it with `?properties` (and then you get a properties-only view). AQL can return the same path/size/created/modified/checksums **and** all artifact properties in a single response by including `property.*` in the query. For Docker manifest blobs, Artifactory sets properties such as:
   - **Docker/OCI:** `docker.manifest`, `docker.manifest.digest`, `docker.manifest.type`, `docker.config.media.type`, `docker.architecture`, `docker.os`, `docker.repoName`, `oci.artifact.type`
   - **JFrog/build:** `jf.revision`, `jf.branch`, `jf.vcsUrl`
   - **Content:** `artifactory.content-type`, `sha256`

2. **Depth**  
   AQL returns a `depth` field (path depth); the storage response we used does not.

3. **All matches in one call**  
   One AQL query by `sha256` returns every artifact with that checksum (e.g. both the canonical path `.../sha256:xxx/manifest.json` and the `_uploads` copy), with paths and properties, without extra storage API calls.

**Example AQL** (one manifest, amd64 digest):

```aql
items.find(
  {"repo": "p-apitesting-docker-multiarch-local", "sha256": "f97133c3a664254ad6f384c80342fe0da2ad8d55bcc6d84e56634c529ac0fc74"}
).include("name", "repo", "path", "actual_sha1", "actual_md5", "sha256", "size", "created", "modified", "updated", "created_by", "modified_by", "type", "depth", "property.*")
```

**Recorded AQL result (first hit – canonical manifest.json):** same repo/path/name/size/created/modified/checksums as storage, plus `depth: 3` and a **properties** array, e.g.:

| Property key | Example value |
|--------------|----------------|
| docker.manifest / docker.manifest.digest | sha256:f97133c3a664... |
| docker.manifest.type | application/vnd.oci.image.manifest.v1+json |
| docker.config.media.type | application/vnd.oci.image.config.v1+json |
| docker.architecture | amd64 |
| docker.os | linux |
| docker.repoName | hello-frog-multi-arch |
| oci.artifact.type | application/vnd.oci.image.config.v1+json |
| jf.revision | 7cb76c2adff36b54cf5bb388223e74d0ab936bd2 |
| jf.branch | main |
| jf.vcsUrl | https://github.com/tomjfrog/image-lifecycle-use-cases |

So for “per-manifest” details in Artifactory: **search + storage** gives path and file metadata; **AQL with `property.*`** adds Docker/OCI and JFrog properties (and depth, and all copies in one query) without a separate `GET ...?properties` call.

---

## Summary table

| What you need | Method | Path (relative to Artifactory base) |
|---------------|--------|-------------------------------------|
| Full file metadata (recommended) | GET | `/api/storage/p-apitesting-docker-multiarch-local/hello-frog-multi-arch/11/list.manifest.json` |
| Item properties only | GET | Same + `?properties` |
| Download stats | GET | Same + `?stats` |
| Raw file content | GET | `/p-apitesting-docker-multiarch-local/hello-frog-multi-arch/11/list.manifest.json` |
| Sync download | GET | `/api/download/p-apitesting-docker-multiarch-local/hello-frog-multi-arch/11/list.manifest.json` |
| Search by path/name (AQL) | POST | `/api/search/aql` (body: AQL above) |
| Compliance (deprecated) | GET | `/api/compliance/p-apitesting-docker-multiarch-local/hello-frog-multi-arch/11/list.manifest.json` |
| Docker image/tag (not this file) | GET | `/api/docker/p-apitesting-docker-multiarch-local/v2/...` |

For “as much information as we can” for **this specific artifact** (`list.manifest.json`), use in this order:

1. **GET `/api/storage/.../list.manifest.json`** (and optionally `?properties` and `?stats`).
2. **GET `/{repoKey}/.../list.manifest.json`** if you need the JSON body (manifest list content).
3. **POST `/api/search/aql`** if you want path-based search with customizable fields.
4. Xray artifact summary if you need scan/compliance and have Xray.

All endpoint definitions above are taken from the **rest-apis** project (e.g. `artifacts-and-storage-api.openapi.yaml`, `artifactory-search-api.openapi.yaml`, `artifactory-artifacts-api.openapi.yaml`, `ENDPOINT_INVENTORY.md`).
