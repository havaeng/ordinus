# Ordinus backend container image

The production artifact is built with the root `Dockerfile`. It uses a
multi-stage build so Gradle and the JDK stay out of the runtime image. The
application runs on Java 21 as the non-root numeric identity `10001:10001`.

The local image seed files under `src/main/resources/seed/medals` are excluded
from the executable Spring Boot jar. They are used only by the `local` profile's
Azurite seed runner; production images are stored separately in Azure Blob
Storage.

The seed files remain tracked in the repository. Before launch, a separate,
explicitly invoked seed artifact or job can include them and idempotently
populate the production database and `published-images` container. They are
excluded only from the permanently running API image so every backend release
does not carry the same seed payload.

## Local verification

Run the same checks as the pull-request workflow:

```bash
./gradlew test --no-daemon
docker build --tag ordinus-api:local .
```

The `Run CI` workflow lints, tests, and builds the image for pull requests and
`main` without Azure access. After that workflow succeeds for a push to `main`,
the separate `Publish backend image` workflow authenticates through the
`production-images` GitHub environment and pushes:

```text
acrordinusprod696163.azurecr.io/ordinus-api:<full-git-commit-sha>
```

No `latest` tag is produced. Before building, the workflow checks whether the
commit tag already exists and never overwrites it. The job reports the registry
digest for future deployment, but does not deploy the image.
