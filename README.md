# MacOS Bootstrap Scripts

Fastrack for dev configuration.

## Phase 0
- go through mac installation process, set up as new mac
- restore `.gnupg`, `.ssh` and keychain from backup
- `xcode-select --install`
- install brew

## Bootstrap new mac
```
make all  # defaults to hostname=mac
```
or
```
make all HOST_NAME=my-new-mac
```

