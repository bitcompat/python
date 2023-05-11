# Python

## What is Python?

> Python is a programming language that lets you work quickly and integrate systems more effectively.

[Overview of Python](https://www.python.org/)

Trademarks: The respective trademarks mentioned in the offering are owned by the respective companies, and use of them does not imply any affiliation or endorsement.

## Get this image

The recommended way to get the Python Docker Image is to pull the prebuilt image from the [AWS Public ECR Gallery](https://gallery.ecr.aws/bitcompat/python) or from the [GitHub Container Registry](https://github.com/bitcompat/python/pkgs/container/python).

```console
$ docker pull ghcr.io/bitcompat/python:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://github.com/bitcompat/python/pkgs/container/python/versions) in the GitHub Registry or the [available tags](https://gallery.ecr.aws/bitcompat/python) in the public ECR gallery.

```console
$ docker pull ghcr.io/bitcompat/python:[TAG]
```

## Entering the REPL

By default, running this image will drop you into the Python REPL, where you can interactively test and try things out in Python.

```console
$ docker run -it --name python ghcr.io/bitcompat/python
```

## Configuration

### Running your Python script

The default work directory for the Python image is `/app`. You can mount a folder from your host here that includes your Python script, and run it normally using the `python` command.

```console
$ docker run -it --name python -v /path/to/app:/app ghcr.io/bitcompat/python \
  python script.py
```

### Running a Python app with package dependencies

If your Python app has a `requirements.txt` defining your app's dependencies, you can install the dependencies before running your app.

```console
$ docker run --rm -v /path/to/app:/app ghcr.io/bitcompat/python pip install -r requirements.txt
$ docker run -it --name python -v /path/to/app:/app ghcr.io/bitcompat/python python script.py
```

**Further Reading:**

- [python documentation](https://www.python.org/doc/)
- [pip documentation](https://pip.pypa.io/en/stable/)

## Maintenance

### Upgrade this image

Up-to-date versions of Python, including security patches, soon after they are made upstream. We recommend that you follow these steps to upgrade your container.

#### Step 1: Get the updated image

```console
$ docker pull ghcr.io/bitcompat/python:latest
```

#### Step 2: Remove the currently running container

```console
$ docker rm -v python
```

#### Step 3: Run the new image

Re-create your container from the new image.

```console
$ docker run --name python ghcr.io/bitcompat/python:latest
```

## Contributing

We'd love for you to contribute to this container. You can request new features by creating an [issue](https://github.com/bitcompat/python/issues), or submit a [pull request](https://github.com/bitcompat/python/pulls) with your contribution.

## Issues

If you encountered a problem running this container, you can file an [issue](https://github.com/bitcompat/python/issues/new).

## License

This package is released under MIT license.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
