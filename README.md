# notes

My notebook. Publicly-viewable, but not very interesting to anyone other than me.

## Status:

- RR course completed.
- Non-private notes now under version control.

# To do:

- Top priorities:
    - Study for coding interviews. Setup related drills.
    - Long-term planning.
- Medium priorities:
    - Put notebook under version control.
    - Strategy to build Singularity images to a _SingularityImages/_ directory.
        - _SingularityImages/_ should not be backed up.
        - Move Singularity files to a _SingularityFIles/_ directory.
        - _SingularityFIles/_ should be backed up.
    - Examples of:
        - Packrat with SCIF.
        - Virtualenv with SCIF.
    - Learn more about how Nix/NixOS work. Become more comfortable. Transition to Nix-based containers.
- Low priorities:
  - Explore TopCoder: https://www.topcoder.com/
  - Explort NumFOCUS: https://numfocus.org/

# Brainstorming:

- Possible SCIF approach:
    - For an app in development, bind code and data dirs from the host to the app's code and data dirs in the container.
        - Use a shell script to do this from the host.
    - Revise project structure ideas accordingly,
        - Project structure should now more closely resemble a SCIF app.
