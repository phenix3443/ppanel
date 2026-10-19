# gateway binaries

These `gateway-<os>-<arch>` binaries are the all-in-one image ENTRYPOINT
(see `../Dockerfile`): a supervisor that downloads/updates the module release
from GitHub, extracts it to `modules/<name>`, runs it as a child process, and
reverse-proxies incoming requests to it.

**Provenance (changed 2026-10-19):** these were the upstream's **closed-source**
prebuilt binaries. They are now built **from source** from the behavior-compatible
implementation in
[`phenix3443/ppanel-gateway`](https://github.com/phenix3443/ppanel-gateway).
A differential test in that repo confirms these reproduce the original binary's
boot → check-version → download → extract → spawn → serve → heartbeat behavior
and control-plane contract.

## Rebuild

```sh
./build-gateway.sh                 # clones ppanel-gateway, builds all 4
./build-gateway.sh /path/to/ppanel-gateway   # from a local checkout
```

The build is pure Go (CGO disabled), reproducible, and cross-compiles from any
host. Flags: `-trimpath -ldflags="-s -w"`.
