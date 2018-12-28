# Docker OpenGrok

Launch [OpenGrok](https://opengrok.github.io/OpenGrok/).

## Usage

Bind a volume to use [SRC_ROOT](https://github.com/OpenGrok/OpenGrok/wiki/How-to-install-OpenGrok#step0---setting-up-the-sources-having-the-web-application-container-ready) for OpenGrok.

```bash
$ docker run -d -p 8080:8080 -v /path/to/src_root:/var/opengrok/src kobtea/opengrok
```
