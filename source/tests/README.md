## Enabling Tests based on googletest

cmake-init will not ship with the sources required to build the tests.
Instead, any developer is asked to install a source release of googletest on their machine.

### Official Sources

### Ubuntu Package

On ubuntu, a compatible release of googletest can be installed using the package `libgmock-dev`:

```bash
> sudo apt install libgmock-dev
```