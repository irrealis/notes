---
title: "180825-1639-mdt_cpp-atom-hydrogen.Rmd"
---

Turns out it is possible to interpret C++ in markdown code fences via Hydrogen in Atom, using the Cling interpreter and kernel for Jupyter. The following prints "23" at the end of the code fence.

```{c++ }
#include <vector>
#include <iostream>

{
  std::vector<int> vi{17, 23, 42};
  std::cout << vi[1] << std::endl;
}
```

```{c++ }
#include <iostream>
std::cout << "Hi." << std::endl;
```

```{java }
System.out.println("Hi.")
```

```{julia }
print("Hi.")
```

```{python }
print("Hi.")
```

```{r }
print("Hi.")
```

```{javascript }
console.log("Hi.");
```

```ruby
puts "Hi."
```

This is very twitchy. To make it work:
- Build Cling.
  - https://github.com/root-project/cling
  - This is hard.
      - The Cling build script, _cpt.py_, appears to expect:
          - that it's running on a Debian distribution that I haven't identified,
          - that an unknown version of Python is available whose _shlex_ module behaves differently to the version on my computer,
          - and that it's running from an unidentified commit.
      - To get it working, I applied the following patch, and then executed the following command.
          - The command fails, but not before it produces _./cling-build/cling_0.5-1_amd64.deb_.
      - I then double clicked _./cling-build/cling_0.5-1_amd64.deb_ to install.
  - Wkpt: _kaben@ares:/mnt/Work/Repos/root-project/cling_
  - Patch:
    ```{diff }
    kaben@ares:/mnt/Work/Repos/root-project/cling$ git diff
    diff --git a/tools/packaging/cpt.py b/tools/packaging/cpt.py
    index ede9ecb8..fe0a136a 100755
    --- a/tools/packaging/cpt.py
    +++ b/tools/packaging/cpt.py
    @@ -71,19 +71,19 @@ def _perror(e):

     def exec_subprocess_call(cmd, cwd, showCMD=False):
         if showCMD: print(cmd)
    -    cmd = _convert_subprocess_cmd(cmd)
    +    #cmd = _convert_subprocess_cmd(cmd)
         try:
    -        subprocess.check_call(cmd, cwd=cwd, shell=False,
    +        subprocess.check_call(cmd, cwd=cwd, shell=True,
                                   stdin=subprocess.PIPE, stdout=None, stderr=subprocess.STDOUT)
         except subprocess.CalledProcessError as e:
             _perror(e)


     def exec_subprocess_check_output(cmd, cwd):
    -    cmd = _convert_subprocess_cmd(cmd)
    +    #cmd = _convert_subprocess_cmd(cmd)
         out = ''
         try:
    -        out = subprocess.check_output(cmd, cwd=cwd, shell=False,
    +        out = subprocess.check_output(cmd, cwd=cwd, shell=True,
                                           stdin=subprocess.PIPE, stderr=subprocess.STDOUT).decode('utf-8')
         except subprocess.CalledProcessError as e:
             _perror(e)
    @@ -808,7 +808,6 @@ exit 0
         f = open(os.path.join(prefix, 'debian', 'cling.install'), 'w')
         template = '''
     bin/* /usr/bin
    -docs/* /usr/share/doc
     include/* /usr/include
     lib/* /usr/lib
     share/* /usr/share
    ```
  - Build command:
    ```
    xlg -- ./tools/packaging/cpt.py --last-stable deb --with-workdir ./cling-build
    ```

- Once Cling was installed (to beneath _/usr/_), I tried the following instructions to install the Cling kernel:
    - https://github.com/root-project/cling/tree/master/tools/Jupyter
    - Tried to install the kernel:
      ```
      pyenv activate atom-3.7.0
      pushd /usr/share/cling/Jupyter/kernel
      pip3 install -e .
      ```
      This failed due to missing libraries. Thus...
      ```
      popd
      sudo cp ./cling-build/builddir/lib/libclingJupyter.so* /usr/lib
      pushd /usr/share/cling/Jupyter/kernel
      pip3 install -e .
      ```
      This was successful.
    - I then installed kernelspecs:
      ```
      jupyter-kernelspec install [--user] cling-cpp17
      jupyter-kernelspec install [--user] cling-cpp1z
      jupyter-kernelspec install [--user] cling-cpp14
      ```
      None of these worked. Three problems:
      - The kernelspecs don't specify the "c++" language.
        - Fixed by appending to each kernelspec:
          ```
          "language": "c++"
          ```
      - The kernelspecs don't specify full path to _jupyter-cling-kernel_.
        - Fixed by replacing with:
          ```
          "/home/kaben/.pyenv/shims/jupyter-cling-kernel"
          ```
      - Atom doesn't have the right Python environment.
        - Fixed using PyEnv:
          ```
          pushd /mnt/Work/Repos/irrealis/flashcards
          pyenv local atom-3.7.0
          cd /home/kaben/Dropbox/Apps/Editorial/Notes_GitHub
          pyenv local atom-3.7.0
          cd /home/kaben/Dropbox/Apps/Editorial
          pyenv local atom-3.7.0
          ```
          **Must repeat for every other directory containing Atom projects.**
