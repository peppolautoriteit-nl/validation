validation
==========

UPDATE: On 2018-10-16 this repository has seen a big reorganization; we have split up the repository into subdirectories per function. The mayor changes are the restructuring of the directory layout, and lowercasing of the default files. If you know of any place that linked to files directly, please let us know.
Note: We have updated the convert_windows.bat file but not tested it.

This repository contains all files related to validation of the simplerinvoicing XML files.

If you are just looking for the latest validation artefacts in xsl form, you can find them here:

* [SI-UBL Invoice all versions up to 1.2](xsl/si-ubl-inv-all.xsl)
* [SI-UBL 1.1 Invoice](xsl/si-ubl-1.1.xsl)
* [SI-UBL 1.2 Invoice](xsl/si-ubl-1.2.xsl)
* [SI-UBL 1.2 Purchase Order](xsl/si-ubl-1.2-purchaseorder.xsl)
* [SI-UBL 2.0 Invoice and CreditNote (2.0.2)](xsl/si-ubl-2.0.2.xsl)

Note that we have removed the 'all-versions' schematron.

Directory overview
==================

The ready-to-use transformation stylesheets can be found in the xsl/ directory; there is a separate xsl file for each version of SI-UBL, and one big xsl-file that combines them all (si-ubl-inv-all.xsl). For SI-UBL 1.2, there is also a purchaseorder xsl.

The schematron/ directory contains all the source schematron files, also by version. The main sch files are present in this directory, and they reference files in subdirectories per version.

The rule_overviews/ directory contains a few assorted documents, and overview of the rules per version, generated from the xsl files.

The tools/ directory contains the tools to recreate the xsl files from the schematron files. For instance, to create a fresh SI-UBL-1.2 xsl file, you can use the command:
    ./tools/convert_linux.sh schematron/si-ubl-1.2.sch /tmp/si-ubl-1.2.xsl

The build_all_linux.sh script rebuilds all generated files in this repository, based on the schematron files.


SI-UBL 2.0.2
============

This is the version of SI-UBL that is based on the NLCIUS, which is a CIUS on the European Norm (EN-16931) and adds Dutch country-specific rules.

Since this is based on EN-16931, there are major differences between SI-UBL 1.2 and SI-UBL 2.0. For more information about the new rules, see https://www.stpe.nl/media/stpe.nl-gebruiksinstructie-basisfactuur-v1.0.pdf

The schematron can be found [here](schematron/si-ubl-2.0.2.sch) and the generated xsl [here](xsl/si-ubl-2.0.2.xsl)

This schematron definition is based on the CenPC434 schematron, which can be found at https://github.com/CenPC434/validation . The commit that was included at the time of the release of SI-UBL-2.0.2 was https://github.com/CenPC434/validation/commits/3cb9fda3, with one additional proposed fix, shown in https://github.com/tjeb/eInvoicing-EN16931/commit/88f9f0a42344ae38d65b2fcc5a1adabd24a2badc

Test Files
==========

We have a number of test documents available in a separate repository, it can be found [here](https://github.com/SimplerInvoicing/testset)
