FROM gitpod/workspace-full

# Install custom tools, runtimes, etc.
# For example "bastet", a command-line tetris clone:
# RUN brew install bastet
#
# More information: https://www.gitpod.io/docs/config-docker/
RUN wget -O /tmp/z.$$ https://sourceforge.net/projects/saxon/files/Saxon-HE/10/Java/SaxonHE10-3J.zip/download && 
   unzip -d ~/saxonica /tmp/z.$$ &&
   rm /tmp/z.$$