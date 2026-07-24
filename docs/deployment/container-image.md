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

This increment builds the image but does not push it. A separate GitHub OIDC
identity with registry-scoped push access will be added before images are
published to Azure Container Registry.
