---
title: "181107-1328-mst_nixos-scif-demo.Rmd"
---

# Thoughts:

Create a NixOS Docker image. Install SCIF. Create hello-world SCIF recipe. Run recipe. Then look into steps to replicate some of my projects. Take note of hiccups and how addressed. Include steps to reproduce final result. Encapsulate in Dockerfile and GitHub repository.

# Plan:

- Create NixOS Docker image.
  - Start by installing existing NixOS Docker image, then experimenting.
  - https://hub.docker.com/r/nixos/nix/.
  - List channels. Add latest stable version.
- Install SCIF.
  - Install SCIF from package if available.
  - If not, try installing specific version via pip install.
- Create and run hello-world SCIF recipe.
  - https://sci-f.github.io/tutorial-quick-start
  - https://sci-f.github.io/tutorial-preview-install#install-scif-in-docker-using-recipe
- Get running in Docker image.
  - Take notes, as this will go wrong. When this happens, analyze; brainstorm next steps.
- Try to encapsulate in Dockerfile.
  - Take notes, as this will go wrong. When this happens, analyze; brainstorm next steps.
- As much as possible, simplify steps to reproduce. Take notes.
- Post on GitHub. Shadow process to verify.


##### 1328: Start. Thoughts/plans.

##### 1418: NixOS in Docker.

- Wkpt: _kaben@ares:/mnt/Work/Repos/irrealis/nixos-scif-demo_181107-1327-mst_
  ```{python }
  %pushd /mnt/Work/Repos/irrealis/nixos-scif-demo_181107-1327-mst
  ```

- Get NixOS Docker image.
  ```{python }
  ! docker pull nixos/nix
  ```

  ```
  Using default tag: latest
  latest: Pulling from nixos/nix

  ade4980c: Pulling fs layer
  d5162ce6: Pulling fs layer
  Digest: sha256:1b97dc98b599779d80271d4203275627c0749d8bd5e9b9c868154249395cbc1b
  Status: Downloaded newer image for nixos/nix:latest
  ```

- Start container.
  ```{python }
  ! docker run -itd --name nixsfx nixos/nix
  ```

  ```
  bec5ded8292143a1aaba33994917f6ae68ade48d9b773bd3a74a4732ecdb5857
  ```

- Add NixOS channel 18.09.
  ```{python }
  ! docker exec nixsfx nix-channel --add https://nixos.org/channels/nixos-18.09
  ! docker exec nixsfx nix-channel --update
  ! docker exec nixsfx nix-channel --list
  ```

  ```
  unpacking channels...
  created 5 symlinks in user environment
  nixos-18.09 https://nixos.org/channels/nixos-18.09
  nixpkgs https://nixos.org/channels/nixpkgs-unstable```
  ```

  ```{python }
  ! docker exec nixsfx nix-env -qa
  ```


- Stop container.
  ```{python }
  ! docker stop nixsfx
  ! docker rm nixsfx
  ```


##### 1626: No traction on Nix.

- Possible reason: https://push.cx/2018/nixos

  ...

  I then turned to the Nix manual to learn more about working with and creating packages and failed, even with help from the nixos IRC channel and issue tracker. I think the fundamental cause is that it wasn’t written for newbies to learn nix from; there’s a man-page like approach where it only makes sense if you already understand it.

  Ultimately I was stopped because I needed to create a package for bitlbee-mastodon and weeslack. As is normal for a small distro, it hasn’t packaged these kind of uncommon things (or complex desktop stuff like Chrome) but I got the impression the selection grows daily. I didn’t want to install them manually (which I doubt would really work on NixOS), I wanted an exercise to learn packaging so I could package my own software and run NixOS on servers (the recent issues/PRs/commits on lobsters-ansible tell the tale of my escalating frustration at its design limitations).

  The manual’s instructions to build and package GNU’s “hello world” binary don’t actually work (gory details there). I got the strong impression that no one has ever sat down to watch a newbie work through this doc and see where they get confused; not only do fundamentals go unexplained and the samples not work, there’s no discussion of common errors. Frustratingly, it also conflates building a package with contributing to nixpkgs, the official NixOS package repository.

  Either this is a fundamental confusion in nix documentation or there’s some undocumented assumption about what tools go where that I never understood. As an example, I tried to run nix-shell (which I think is the standard tool for debugging builds but it has expert-only docs) and it was described over in the Nixpkgs Manual even though it’s for all packaging issues. To use the shell I have to understand “phases”, but some of the ones listed simply don’t exist in the shell environment. I can’t guess if this a bug, out-dated docs, or incomplete docs. And that’s before I got to confusing “you just have to know it” issues like the src attribute becoming unpackPhase rather than srcPhase, or “learn from bitter experience” issues like nix-shell polluting the working directory and carrying state between build attempts. (This is where I gave up.)

  I don’t know how the NixOS Manual turned out so well; the rest of the docs have this fractal issue where, at every level of detail, every part of the system is incompletely or incorrectly described somewhere other than expected. I backed up and reread the homepages and about pages to make sure I didn’t miss a tutorial or other introduction that might have helped make sense of this, but found nothing besides these manuals. If I sound bewildered and frustrated, then I’ve accurately conveyed the experience. I gave up trying to learn nix, even though it still looks like the only packaging/deployment system with the right perspective on the problems.

  I’d chalk it up to nix being young, but there’s some oddities that look like legacy issues. For example, commands vary: it’s nix-env -i to install a package, but nix-channel only has long options like --add, and nix-rebuild switch uses the more modern “subcommand” style. With no coherent style, you have to memorize which commands use which syntax – again, one of those things newbies stumble on but experts don’t notice and may not even recognize as a problem.

  Finally, there’s two closely-related issues in nix that look like misdesigns, or at least badly-missed opportunities. I don’t have a lot of confidence in these because, as recounted, I was unable to learn to use nix. Mostly these are based on my 20 years of administrating Linux systems, especially the provisioning and devops work I’ve done with Chef, Puppet, Ansible, Capistrano, and scripting that I’ve done in the last 10. Experience has led me to think that the hard parts of deployment and provisioning boil down to a running system being like a running program making heavy use of mutable global variables (eg. the filesystem): the pain comes from unmanaged changes and surprisingly complex moving parts.

  The first issue is that Nix templatizes config files. There’s an example in my configuration.nix notes above: rather than editing the grub config file, the system lifts copies from this config file to paste into a template of of grub’s config file that must be hidden away somewhere. So now instead of just knowing grub’s config, you have to know it plus what interface the packager decided to design on top of it by reading the package source (and I had to google to find that). There’s warts like extraConfig that throw up their hands at the inevitable uncaptured complexity and offer a interface to inject arbitrary text into the config. I hope “inject” puts you in a better frame of mind than “interface”: this is stringly-typed text interpolation and a typo in the value means an error from grub rather than nix. This whole thing must be a ton of extra work for packagers, and if there’s a benefit over vi /etc/default/grub it’s not apparent (maybe in provisioning, though I never got to nixops).

  This whole system is both complex and incomplete, and it would evaporate if nix configured packages by providing a default config file in a package with a command to pull it into /etc/nix or /etc/nixos for you to edit and nix to copy back into the running system when you upgrade or switch. This would lend itself very well to keeping the system config under version control, which is never suggested in the manual and doesn’t seem to be integrated at any level of the tooling – itself a puzzling omission, given the emphasis on repeatability.

  Second, to support this complexity, they developed their own programming language. (My best guess – I don’t actually know which is the chicken and which is the egg.) A nix config file isn’t data, it’s a turning-complete language with conditionals, loops, closures, scoping, etc. Again, this must have been a ton of work to implement and a young, small-team programming language has all the obvious issues like no debugger, confusing un-googleable error messages that don’t list filenames and line numbers, etc.; and then there’s the learning costs to users. Weirdly for a system inspired by functional programming, it’s dynamically typed, so it feels very much like the featureset and limited tooling/community of JavaScript circa 1998. In contrast to JavaScript, the nix programming language is only used by one project, so it’s unlikely to see anything like the improvements in JS in last 20 years. And while JavaScript would be an improvement over inventing a language, using Racket or Haskell to create a DSL would be a big improvement.

  These are two apparent missed opportunities, not fatal flaws. Again, I wasn’t able to learn nix to the level that I understand how and why it was designed this way, so I’m not setting forth a strongly-held opinion. They’re really strange, expensive decisions that I don’t see a compelling reason for, and they look like they’d be difficult to change. Probably they have already been beaten to death on a mailing list somewhere, but I’m too frustrated by how much time I’ve wasted to go looking.

  I’ve scheduled a calendar reminder for a year from now to see if the manual improves or if Luc Perkins’s book is out.


##### 1631: Trying Bazel.

- https://bazel.build/
- https://docs.bazel.build/versions/master/install-ubuntu.html
- Download to _~/Downloads_:
  ```{python }
  %pushd ~/Downloads
  %pwd
  ! wget https://github.com/bazelbuild/bazel/releases/download/0.18.1/bazel-0.18.1-installer-linux-x86_64.sh

  %popd
  ```

  ```
  --2018-11-07 16:49:24--  https://github.com/bazelbuild/bazel/releases/download/0.18.1/bazel-0.18.1-installer-linux-x86_64.sh
  Resolving github.com (github.com)... 192.30.253.112, 192.30.253.113
  Connecting to github.com (github.com)|192.30.253.112|:443... connected.
  HTTP request sent, awaiting response... 302 Found
  Location: https://github-production-release-asset-2e65be.s3.amazonaws.com/20773773/b15b6380-e1ca-11e8-9e94-54594b3c18dd?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20181107%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20181107T234924Z&X-Amz-Expires=300&X-Amz-Signature=133b0082019d323976896064493b0d396ecc7f486c335042065a9371a2e1f0f1&X-Amz-SignedHeaders=host&actor_id=0&response-content-disposition=attachment%3B%20filename%3Dbazel-0.18.1-installer-linux-x86_64.sh&response-content-type=application%2Foctet-stream [following]
  --2018-11-07 16:49:24--  https://github-production-release-asset-2e65be.s3.amazonaws.com/20773773/b15b6380-e1ca-11e8-9e94-54594b3c18dd?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20181107%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20181107T234924Z&X-Amz-Expires=300&X-Amz-Signature=133b0082019d323976896064493b0d396ecc7f486c335042065a9371a2e1f0f1&X-Amz-SignedHeaders=host&actor_id=0&response-content-disposition=attachment%3B%20filename%3Dbazel-0.18.1-installer-linux-x86_64.sh&response-content-type=application%2Foctet-stream
  Resolving github-production-release-asset-2e65be.s3.amazonaws.com (github-production-release-asset-2e65be.s3.amazonaws.com)... 52.216.233.203
  Connecting to github-production-release-asset-2e65be.s3.amazonaws.com (github-production-release-asset-2e65be.s3.amazonaws.com)|52.216.233.203|:443... connected.
  HTTP request sent, awaiting response... 200 OK
  Length: 166359985 (159M) [application/octet-stream]
  Saving to: ‘bazel-0.18.1-installer-linux-x86_64.sh’

  bazel-0.18.1-instal 100%[===================>] 158.65M  3.16MB/s    in 50s

  2018-11-07 16:50:14 (3.20 MB/s) - ‘bazel-0.18.1-installer-linux-x86_64.sh’ saved [166359985/166359985]
  ```

- Verify checksum:
  ```{python }
  ! wget https://github.com/bazelbuild/bazel/releases/download/0.18.1/bazel-0.18.1-installer-darwin-x86_64.sh.sha256
  ! cat bazel-0.18.1-installer-linux-x86_64.sh.sha256
  ! sha256sum bazel-0.18.1-installer-linux-x86_64.sh
  ```

  ```
  8073657ced2bb323dd2e7ba6e39011ca56b856cae475b476e9b77d30123582e5  bazel-0.18.1-installer-linux-x86_64.sh
  8073657ced2bb323dd2e7ba6e39011ca56b856cae475b476e9b77d30123582e5  bazel-0.18.1-installer-linux-x86_64.sh
  ```

- Execute for local user:
  ```{python }
  ! chmod +x bazel-0.18.1-installer-linux-x86_64.sh
  ! ./bazel-0.18.1-installer-linux-x86_64.sh --bin=$HOME/.local/bin --base=$HOME/.bazel
  ```

  ```
  Bazel installer
  ---------------

  Bazel is bundled with software licensed under the GPLv2 with Classpath exception.
  You can find the sources next to the installer on our release page:
     https://github.com/bazelbuild/bazel/releases

  # Release 0.18.1 (2018-10-31)

  Baseline: c062b1f1730f3562d5c16a037b374fc07dc8d9a2

  Cherry picks:

     + 2834613f93f74e988c51cf27eac0e59c79ff3b8f:
       Include also ext jars in the bootclasspath jar.
     + 2579b791c023a78a577e8cb827890139d6fb7534:
       Fix toolchain_java9 on --host_javabase=<jdk9> after
       7eb9ea150fb889a93908d96896db77d5658e5005
     + faaff7fa440939d4367f284ee268225a6f40b826:
       Release notes: fix markdown
     + b073a18e3fac05e647ddc6b45128a6158b34de2c:
       Fix NestHost length computation Fixes #5987
     + bf6a63d64a010f4c363d218e3ec54dc4dc9d8f34:
       Fixes #6219. Don't rethrow any remote cache failures on either
       download or upload, only warn. Added more tests.
     + c1a7b4c574f956c385de5c531383bcab2e01cadd:
       Fix broken IdlClassTest on Bazel's CI.
     + 71926bc25b3b91fcb44471e2739b89511807f96b:
       Fix the Xcode version detection which got broken by the upgrade
       to Xcode 10.0.
     + 86a8217d12263d598e3a1baf2c6aa91b2e0e2eb5:
       Temporarily restore processing of workspace-wide tools/bazel.rc
       file.
     + 914b4ce14624171a97ff8b41f9202058f10d15b2:
       Windows: Fix Precondition check for addDynamicInputLinkOptions
     + e025726006236520f7e91e196b9e7f139e0af5f4:
       Update turbine

  Important changes:

    - Fix regression #6219, remote cache failures

  ## Build informations
     - [Commit](https://github.com/bazelbuild/bazel/commit/1050764)
  Uncompressing......Extracting Bazel installation...
  WARNING: An illegal reflective access operation has occurred
  WARNING: Illegal reflective access by com.google.protobuf.UnsafeUtil (file:/home/kaben/.cache/bazel/_bazel_kaben/install/cdf71f2489ca9ccb60f7831c47fd37f1/_embedded_binaries/A-server.jar) to field java.lang.String.value
  WARNING: Please consider reporting this to the maintainers of com.google.protobuf.UnsafeUtil
  WARNING: Use --illegal-access=warn to enable warnings of further illegal reflective access operations
  WARNING: All illegal access operations will be denied in a future release
  WARNING: --batch mode is deprecated. Please instead explicitly shut down your Bazel server using the command "bazel shutdown".
  .

  Bazel is now installed!

  Make sure you have "/home/kaben/.local/bin" in your path. You can also activate bash
  completion by adding the following line to your :
    source /home/kaben/.bazel/bin/bazel-complete.bash

  See http://bazel.build/docs/getting-started.html to start a new project!```
  ```

- Warnings:
  ```{python }
  ! $HOME/.local/bin/bazel
  ```

  ```
  WARNING: An illegal reflective access operation has occurred
  WARNING: Illegal reflective access by com.google.protobuf.UnsafeUtil (file:/home/kaben/.cache/bazel/_bazel_kaben/install/cdf71f2489ca9ccb60f7831c47fd37f1/_embedded_binaries/A-server.jar) to field java.lang.String.value
  WARNING: Please consider reporting this to the maintainers of com.google.protobuf.UnsafeUtil
  WARNING: Use --illegal-access=warn to enable warnings of further illegal reflective access operations
  WARNING: All illegal access operations will be denied in a future release
  WARNING: --batch mode is deprecated. Please instead explicitly shut down your Bazel server using the command "bazel shutdown".
                                                            [bazel release 0.18.1]
  Usage: bazel <command> <options> ...

  Available commands:
    analyze-profile     Analyzes build profile data.
    aquery              Analyzes the given targets and queries the action graph.
    build               Builds the specified targets.
    canonicalize-flags  Canonicalizes a list of bazel options.
    clean               Removes output files and optionally stops the server.
    coverage            Generates code coverage report for specified test targets.
    cquery              Loads, analyzes, and queries the specified targets w/ configurations.
    dump                Dumps the internal state of the bazel server process.
    fetch               Fetches external repositories that are prerequisites to the targets.
    help                Prints help for commands, or the index.
    info                Displays runtime info about the bazel server.
    license             Prints the license of this software.
    mobile-install      Installs targets to mobile devices.
    print_action        Prints the command line args for compiling a file.
    query               Executes a dependency graph query.
    run                 Runs the specified target.
    shutdown            Stops the bazel server.
    sync                Syncs all repositories specifed in the workspace file
    test                Builds and runs the specified test targets.
    version             Prints version information for bazel.

  Getting more help:
    bazel help <command>
                     Prints help and options for <command>.
    bazel help startup_options
                     Options for the JVM hosting bazel.
    bazel help target-syntax
                     Explains the syntax for specifying targets.
    bazel help info-keys
                     Displays a list of keys used by the info command.
  ```


- Patch to suppress some of the warnings:
  ```{python }
  ! diff -ub $HOME/.bazel/bin/bazel.orig $HOME/.bazel/bin/bazel
  ```

  ```{patch }
--- /home/kaben/.bazel/bin/bazel.orig	2018-11-07 17:12:20.028015338 -0700
+++ /home/kaben/.bazel/bin/bazel	2018-11-07 17:40:22.196256531 -0700
@@ -85,4 +85,4 @@
     exit 1
 fi

-exec -a "$0" "${BAZEL_REAL}" "$@"
+exec -a "$0" "${BAZEL_REAL}" --host_jvm_args "--illegal-access=deny" "$@"
  ```

- Bash completion: add to _~/.bashrc_:
  ```{bash }
  BAZEL_DIR="${HOME}/.bazel"
  if [ -f "${BAZEL_DIR}/bin/bazel-complete.bash" ] ; then
    source "${BAZEL_DIR}/bin/bazel-complete.bash"
  fi
  ```


##### 1818: Stopping.
