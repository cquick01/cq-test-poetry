# Poetry 1.5.0 Dependnecy Test

### Directory setup (this repo)

    ➜  ~/test ls
    cq_test_poetry-0.1.0-py3-none-any.whl  Dockerfile  pyproject.toml

### Build docker image

    ➜  ~/test docker build -t poetry-docker .
    [+] Building 0.6s (10/10) FINISHED
     => [internal] load build definition from Dockerfile                                                                                                  0.0s
     => => transferring dockerfile: 180B                                                                                                                  0.0s
     => [internal] load .dockerignore                                                                                                                     0.0s
     => => transferring context: 2B                                                                                                                       0.0s
     => [internal] load metadata for docker.io/library/python:buster                                                                                      0.4s
     => [internal] load build context                                                                                                                     0.0s
     => => transferring context: 622B                                                                                                                     0.0s
     => [1/5] FROM docker.io/library/python:buster@sha256:90709c9316532d91bf537dcb4bac8b1b97407ff77f189bcd8e07d8edcbfe7705                                0.0s
     => CACHED [2/5] RUN apt-get update && apt-get install -y vim                                                                                         0.0s
     => CACHED [3/5] RUN pip install -U pip poetry                                                                                                        0.0s
     => CACHED [4/5] WORKDIR /opt                                                                                                                         0.0s
     => [5/5] COPY . .                                                                                                                                    0.0s
     => exporting to image                                                                                                                                0.1s
     => => exporting layers                                                                                                                               0.0s
     => => writing image sha256:1605c744e14db30b2ad4081832e75b5268d7416ec21865165f4c570da614c7a7                                                          0.0s
     => => naming to docker.io/library/poetry-docker                                                                                                      0.0s

### Run docker image, enters bash shell
    ➜  ~/test docker run -it poetry-docker

### In container
    root@cfffdf28fedb:/opt# ls
    Dockerfile  cq_test_poetry-0.1.0-py3-none-any.whl  pyproject.toml

    root@cfffdf28fedb:/opt# poetry shell
    Creating virtualenv opt-y8366zdl-py3.11 in /root/.cache/pypoetry/virtualenvs
    Spawning shell within /root/.cache/pypoetry/virtualenvs/opt-y8366zdl-py3.11
    root@cfffdf28fedb:/opt# . /root/.cache/pypoetry/virtualenvs/opt-y8366zdl-py3.11/bin/activate

    (opt-py3.11) root@cfffdf28fedb:/opt# pip freeze

### cq-test-poetry available on pypi.domain.tld
    (opt-py3.11) root@cfffdf28fedb:/opt# curl https://pypi.domain.tld/simple/cq-test-poetry/
    <html>
    <head><title>Index of /simple/cq-test-poetry/</title></head>
    <body>
    <h1>Index of /simple/cq-test-poetry/</h1><hr><pre><a href="../">../</a>
    <a href="cq_test_poetry-0.1.0-py3-none-any.whl">cq_test_poetry-0.1.0-py3-none-any.whl</a>              19-May-2023 17:13                1108
    </pre><hr></body>
    </html>

# Adding from pypi server does not include dependencies
    (opt-py3.11) root@cfffdf28fedb:/opt# poetry add cq-test-poetry
    Using version ^0.1.0 for cq-test-poetry

    Updating dependencies
    Resolving dependencies... (0.2s)

    Package operations: 1 install, 0 updates, 0 removals

      • Installing cq-test-poetry (0.1.0)

    Writing lock file

    (opt-py3.11) root@cfffdf28fedb:/opt# pip freeze
    cq-test-poetry==0.1.0

    (opt-py3.11) root@cfffdf28fedb:/opt# exit
    exit

# Reset poetry env to test installing .whl directly
    root@cfffdf28fedb:/opt# poetry env list
    opt-y8366zdl-py3.11 (Activated)
    root@cfffdf28fedb:/opt# poetry env remove opt-y8366zdl-py3.11
    Deleted virtualenv: /root/.cache/pypoetry/virtualenvs/opt-y8366zdl-py3.11
    root@cfffdf28fedb:/opt# poetry shell
    Creating virtualenv opt-y8366zdl-py3.11 in /root/.cache/pypoetry/virtualenvs
    Spawning shell within /root/.cache/pypoetry/virtualenvs/opt-y8366zdl-py3.11
    root@cfffdf28fedb:/opt# . /root/.cache/pypoetry/virtualenvs/opt-y8366zdl-py3.11/bin/activate
    (opt-py3.11) root@cfffdf28fedb:/opt# pip freeze

# Install from .whl, dependencies found
    (opt-py3.11) root@cfffdf28fedb:/opt# poetry add ./cq_test_poetry-0.1.0-py3-none-any.whl

    Updating dependencies
    Resolving dependencies... (0.7s)

    Package operations: 6 installs, 0 updates, 0 removals

      • Installing certifi (2023.5.7)
      • Installing charset-normalizer (3.1.0)
      • Installing idna (3.4)
      • Installing urllib3 (2.0.2)
      • Installing requests (2.31.0)
      • Installing cq-test-poetry (0.1.0 /opt/cq_test_poetry-0.1.0-py3-none-any.whl)

    Writing lock file
    (opt-py3.11) root@cfffdf28fedb:/opt# pip freeze
    certifi==2023.5.7
    charset-normalizer==3.1.0
    cq-test-poetry @ file:///opt/cq_test_poetry-0.1.0-py3-none-any.whl
    idna==3.4
    requests==2.31.0
    urllib3==2.0.2
    (opt-py3.11) root@cfffdf28fedb:/opt#

