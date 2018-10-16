validation
==========

UPDATE: On 2018-10-16 this repository has seen a big reorganization; we have split up the repository into subdirectories per function. The mayor changes are the restructuring of the directory layout, and lowercasing of the default files. If you know of any place that linked to files directly, please let us know.
Note: We have updated the convert_windows.bat file but not tested it.

This repository contains all files related to validation of the simplerinvoicing XML files.

The ready-to-use transformation stylesheets can be found in the xsl/ directory; there is a separate xsl file for each version of SI-UBL, and one big xsl-file that combines them all (si-ubl-inv-all.xsl). For SI-UBL 1.2, there is also a purchaseorder xsl.

The schematron/ directory contains all the source schematron files, also by version. The main sch files are present in this directory, and they reference files in subdirectories per version.

The tools/ directory contains the tools to recreate the xsl files from the schematron files. For instance, to create a fresh SI-UBL-1.2 xsl file, you can use the command:
    ./tools/convert_linux.sh schematron/si-ubl-1.2.sch /tmp/si-ubl-1.2.xsl

The build_all_linux.sh script rebuilds all generated files in this repository, based on the schematron files.

The documentation/ directory contains a few assorted documents, and overview of the rules per version, generated from the xsl files.


