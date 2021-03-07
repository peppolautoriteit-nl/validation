[![Gitpod ready-to-code](https://img.shields.io/badge/Gitpod-ready--to--code-blue?logo=gitpod)](https://gitpod.io/#https://github.com/peppolautoriteit-nl/validation)

validation
==========

This repository contains all files related to validation of the SI-UBL and NLCIUS XML files.

If you are just looking for the latest validation artefacts in xsl form, you can find them here:

* [SI-UBL Invoice all versions up to 1.2](xsl/si-ubl-inv-all.xsl)
* [SI-UBL 1.1 Invoice](xsl/si-ubl-1.1.xsl)
* [SI-UBL 1.2 Invoice (1.2.3)](xsl/si-ubl-1.2.xsl)
* [SI-UBL 1.2 Purchase Order](xsl/si-ubl-1.2-purchaseorder.xsl)
* [SI-UBL 2.0 Invoice and CreditNote (2.0.3.1)](xsl/si-ubl-2.0.xsl)
* [SI-UBL 2.0 G-Account extension (1.0.1)](xsl/si-ubl-2.0-ext-gaccount.xsl)
* [NLCIUS UN/CEFACT CII (1.0.3)](xsl/nlcius-cii-1.0.xsl)


Versioning
==========

Since this repository contains multiple versioned validation sets, the versioning of the repository through it tags is separate from the versions of the validation sets themselves.

Versioning of the validation artefacts use 4 numbers: major.minor.bugfix.release; Major, minor and bugfix releases are the version numbers taken from the specification files, where major numbers are incremented on backwards-incompatible changes, minor numbers are incremented on significant but backwards compatible changes, and bugfix numbers are incremented on small changes and clarifications. The release number itself is incremented for bugfixes and changes on the validation files themselves, if the specification has not been updated since the last release. If the release version is 0, it is omitted.

Release tags in the repository itself use a single version by date approach; any time one or more validation sets are updated into a release, the repository version changes to the current date, e.g. 2020-02-14. See the Changelog file for the mapping of repository releases and validation set releases. The links above always refer to the latest version of each set.

Directory overview
==================

The ready-to-use transformation stylesheets can be found in the xsl/ directory; there is a separate xsl file for each version of SI-UBL, and one big xsl-file that combines them all (si-ubl-inv-all.xsl). For SI-UBL 1.2, there is also a purchaseorder xsl.

The schematron/ directory contains all the source schematron files, also by version. The main sch files are present in this directory, and they reference files in subdirectories per version.

The rule_overviews/ directory contains a few assorted documents, and overview of the rules per version, generated from the xsl files.

The tools/ directory contains the tools to recreate the xsl files from the schematron files. For instance, to create a fresh SI-UBL-1.2 xsl file, you can use the command:
    ./tools/convert_linux.sh schematron/si-ubl-1.2.sch /tmp/si-ubl-1.2.xsl

The build_all_linux.sh script rebuilds all generated files in this repository, based on the schematron files.

Schematron File overview
========================

The schematron/ directory contains a number of files and subdirectories. The files in the directory itself are the main schematron files for the different document formats and versions. The subdirectories contain supporting files, which are included by the main top-level schematron files; these only contain parts of the specification, and are generally not intended for individual use.

For instance, the main directory contains the validation schematron file for SI-UBL 2.0, called 'si-ubl-2.0.sch'. This file includes several files from the si-ubl-2.0/ subdirectory, such as 'si-ubl-2.0-nlcius.sch' (which contains the specific rules from the NLCIUS, and nothing else), and several files from si-ubl-2.0/CenPC434 (which contain the general rules from the European Norm for core invoices, EN-16931).

The schematron files can be used directly by any software that supports it, or they can be used to (re)create the XSL files.

This is the list of schematron files included in this repository:

- [schematron/si-ubl-2.0.sch](schematron/si-ubl-2.0.sch) SI-UBL 2.0, Invoice and CreditNote. This implements all the rules of EN-16931 and NLCIUS for UBL. See [https://stpe.nl/documenten/](https://stpe.nl/documenten/) for more information (in Dutch).
- [schematron/si-ubl-2.0-ext-gaccount.sch](schematron/si-ubl-2.0-ext-gaccount.sch) This is the g-account extension on the NLCIUS, to be used in g-account scenarios, where part of the amount to be payed is to be payed to a separate blocked account. See [https://stpe.nl/documenten/](https://stpe.nl/documenten/) for more information (in Dutch).
- [schematron/nlcius-cii-1.0.sch](schematron/nlcius-cii-1.0.sch) NLCIUS CII Invoice. This is the UN/CEFACT CII D16B mapping that implements the rules of EN-16931 and NLCIUS.
- [schematron/si-ubl-1.2.sch](schematron/si-ubl-1.2.sch) SI-UBL 1.2, Invoice. The previous and now optional version of SI-UBL. This does not support the rules of the NLCIUS.
- [schematron/si-ubl-1.2-purchaseorder.sch](schematron/si-ubl-1.2-purchaseorder.sch) SI-UBL 1.2, Purchase orders. The previous and now optional version of SI-UBL.
- [schematron/si-ubl-1.1.sch](schematron/si-ubl-1.1.sch) SI-UBL 1.1. This version is out of support, but kept for historic purposes.
- [schematron/si-ubl-1.0.sch](schematron/si-ubl-1.0.sch) SI-UBL 1.0. This version is out of support, but kept for historic purposes.


SI-UBL 2.0.3.1
==============

This is the version of SI-UBL that is based on the NLCIUS 2.0.3, which is a CIUS on the European Norm (EN-16931) and adds Dutch country-specific rules.

Since this is based on EN-16931, there are major differences between SI-UBL 1.2 and SI-UBL 2.0. For more information about the new rules, see https://www.stpe.nl/media/stpe.nl-gebruiksinstructie-basisfactuur-v1.0.pdf

The schematron can be found [here](schematron/si-ubl-2.0.sch) and the generated xsl [here](xsl/si-ubl-2.0.xsl)

This schematron definition is based on the CenPC434 schematron, which can be found at https://github.com/CenPC434/validation .

The commit that was included at the time of the release of SI-UBL-2.0.3 was https://github.com/CenPC434/validation/commits/b6762416 (tag validation-1.3.2), with two additional proposed fixes, shown in https://github.com/tjeb/eInvoicing-EN16931/commit/dd021e64b079aa772c5383da087c7f94baefc71d and https://github.com/tjeb/eInvoicing-EN16931/commit/71df26a862e59fc7136e7cb78574d6486cd58a97

The related pull requests for these fixes upstream are https://github.com/ConnectingEurope/eInvoicing-EN16931/pull/226 and https://github.com/ConnectingEurope/eInvoicing-EN16931/pull/227

NLCIUS-CII 1.0.3
================

This implements the same base rules from NLCIUS, but for the document format UN/CEFACT CII D16B.

The validation includes all the rules as implemented by the CEN PC434 group, with additional checks for the NLCIUS rules.

The CEN rules are based on https://github.com/ConnectingEurope/eInvoicing-EN16931
commit b6762416a714fa78633af72966f130bddbeee568
(tag validation-1.3.2)



Test Files
==========

We have a number of test documents available in a separate repository, it can be found [here](https://github.com/SimplerInvoicing/testset)
