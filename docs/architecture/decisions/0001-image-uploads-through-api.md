# ADR 0001: Route image uploads through the Ordinus API

- Status: Accepted
- Date: 2026-07-24

## Context

Authenticated community members will be able to submit images for moderation.
The files belong in the private `image-submissions` container and must never
become published merely because an upload succeeded.

The browser could either send each file to the Ordinus API or upload directly
to Azure Blob Storage with a short-lived shared access signature (SAS). Direct
upload reduces backend data transfer, but introduces SAS generation, Storage
CORS, post-upload validation, abandoned-blob cleanup, and another
authorization boundary. The initial service is a low-traffic hobby project,
and uploads are expected to be bounded image files rather than large media.

## Decision

The first upload flow goes through the authenticated Ordinus API:

1. The API authorizes the user and checks their upload quota.
2. The API assigns an opaque blob name; clients cannot choose storage paths.
3. The API validates a configurable size limit, allowed image formats, file
   signatures, and decoded image dimensions.
4. The API streams an accepted file to `image-submissions` and records its
   owner, metadata, and moderation state in PostgreSQL.
5. Only an authorized moderation operation can promote an image to
   `published-images`.

The initial target limit is 10 MiB per image and will be reviewed when the
upload feature is implemented. Rate limits, per-user quotas, and limits on
pending submissions are required before uploads are enabled.

The Azure-hosted API will access Blob Storage with its managed identity and
narrowly scoped data-plane RBAC. Production will not use Storage Account keys
or connection strings.

No Blob Storage CORS rule or upload SAS is added for the initial flow. Delivery
of approved images is a separate concern and does not change this upload
decision.

## Consequences

- Authentication, validation, quotas, moderation state, and audit data remain
  in one application boundary.
- Invalid requests can be rejected before they consume persistent Blob
  Storage.
- The browser never receives direct write access to a container.
- Upload traffic consumes API ingress, compute, and memory or temporary
  storage. Implementations must stream bounded files rather than buffer entire
  uploads in memory.
- This approach is appropriate for the expected initial traffic, but is less
  efficient than direct-to-Blob upload at high volume.

## Revisit criteria

Reconsider direct upload when measurements show that upload traffic materially
affects API scaling or when supported file sizes outgrow the API request path.
If introduced, direct upload must use a user delegation SAS created with the
runtime managed identity, scoped to one server-generated blob name, limited to
the minimum permissions, HTTPS, and a short lifetime. It must also include
exact-origin CORS, pre-issuance quotas, post-upload validation, and cleanup of
abandoned or rejected blobs.

Microsoft recommends user delegation SAS over signatures based on Storage
Account keys:

- <https://learn.microsoft.com/azure/storage/blobs/authorize-access-azure-active-directory>
- <https://learn.microsoft.com/azure/storage/blobs/storage-blob-user-delegation-sas-create-java>
