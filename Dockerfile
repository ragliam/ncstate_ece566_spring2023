# ECE 466/566 container for easy use on Windows, Linux, MacOS

FROM ubuntu:22.10

LABEL maintainer="jtuck@ncsu.edu"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get clean \
  && apt-get install -y --no-install-recommends ssh \
      build-essential \
      gcc \
      g++ \
      gdb \
      cmake \
      rsync \
      tar \
      python3 \
      python3-pip \
      zlib1g-dev \
      bison \
      libbison-dev \
      flex \
   && apt-get clean

RUN apt-get clean \
    && apt-get install -y --no-install-recommends libllvm-14-ocaml-dev libllvm14 llvm-14 llvm-14-dev llvm-14-doc llvm-14-examples llvm-14-runtime \
    clang-14 clang-tools-14 clang-14-doc libclang-common-14-dev libclang-14-dev libclang1-14 clang-format-14 python3-clang-14 clangd-14 clang-tidy-14 \
    libfuzzer-14-dev \
    lldb-14 \
    lld-14 \
    libc++-14-dev libc++abi-14-dev \
    libomp-14-dev \
    libclc-14-dev \
    libunwind-14-dev \
    libmlir-14-dev mlir-14-tools \
    && apt-get clean

RUN apt-get install -y time \
    && apt-get clean

RUN pip install lit

ADD . /ece566
ADD . /build
WORKDIR /ece566

RUN ( \
    echo 'LogLevel DEBUG2'; \
    echo 'PermitRootLogin yes'; \
    echo 'PasswordAuthentication yes'; \
    echo 'Subsystem sftp /usr/lib/openssh/sftp-server'; \
  ) > /etc/ssh/sshd_config_test_clion \
  && mkdir /run/sshd

RUN useradd -s /bin/bash -m user \
  && yes password | passwd user

CMD ["/usr/sbin/sshd", "-D", "-e", "-f", "/etc/ssh/sshd_config_test_clion"]