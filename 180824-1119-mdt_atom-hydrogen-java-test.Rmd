---
title: "180824-1119-mdt_atom-hydrogen-java-test.Rmd"
---

Got Java kernel to work in Atom with Hydrogen and PWeave.

- Using IJava:
  - https://github.com/SpencerPark/IJava

- IJava requires Java SE >= 9, so grabbed latest Java JDK:
  - Installed Java SE Dev Kit 10.0.2:
    - Wkpt: _kaben@ares:/mnt/Work/Scratch/_
    - Download at: https://www.oracle.com/technetwork/java/javase/downloads/jdk10-downloads-4416644.html
    - http://download.oracle.com/otn-pub/java/jdk/10.0.2+13/19aef61b38124481863b1413dce1855f/jdk-10.0.2_linux-x64_bin.tar.gz?AuthParam=1535134799_ece4398f630e4248152f5b211f067a0f
    - Moved to local dir.
    - Unpack:
      ```
      tar xvfz jdk-10.0.2_linux-x64_bin.tar.gz
      ```
      Unpacked to _jdk-10.0.2_
    - Set `JAVA_HOME` in _~/.bashrc_:
      ```
      JAVA_HOME=/mnt/Work/Scratch/jdk-10.0.2
      if [ -d "$JAVA_HOME" ] ; then
        export JAVA_HOME
        export PATH="${JAVA_HOME}/bin:${PATH}"
      fi
      ```

- Obtaining IJava source:
  - Wkpt: _kaben@ares:/mnt/Work/Repos/SpencerPark/_
  - Clone:
    ```
    git clone https://github.com/SpencerPark/IJava.git
    ```
  - Install instructions: https://github.com/SpencerPark/IJava#install-from-source
  - Install commands:
    ```
    git clone https://github.com/SpencerPark/IJava.git
    cd IJava
    chmod u+x gradlew
    ./gradlew installKernel
    ```
    - This installed the kernel beneath _~/.ipython/kernels/_.
    - **Atom-Hydrogen couldn't find the kernel here**.

  - Moved kernel to expected location:
    ```
    mv ~/.ipython/kernels/java  ~/.local/share/jupyter/kernels/
    ```
    - Atom-Hydrogen can now find Java kernel, but **Atom-Hydrogen can't use the kernel yet**.
      - Error raised:
        ```
        Java
        Error: A JNI error has occurred, please check your installation and try again
        Exception in thread "main"
        ```
    - Reason: Java kernel configuration doesn't specify correct java executable.
    - Fix: set correct path in Java kernel config.
      - Edit file: _~/.local/share/jupyter/kernels/java/kernel.json_
        - In "argv", change line reading "java" to:
          ```
          "/mnt/Work/Scratch/jdk-10.0.2/bin/java"
          ```

    - Can now use IJava kernel. Examples:
      ```{java }
      System.out.println("Hi");
      ```
      ```{java }
      "Hi"
      ```
