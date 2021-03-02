# Draft country-specific rules for NL

This is a draft version of the country-specific rules for the Netherlands in Peppol BIS 3.

This directory contains 4 files:

- nl-rules-snippet.sch: A schematron pattern containing **only** the draft country-specific rules, implemented as errors. This is the authoritative version of the country-specific rule set.
- nl-rules-snippet-warning.sch: A schematron pattern containing **only** the draft country-specific rules, implemented as warnings. This can be used to add to your own validation rules, without causing additional errors.
- peppol-bis-3-with-nl.sch: The current PEPPOL BIS 3 validation file, with the addition of the draft country-specific rules, implemented as errors. This can be used to test your documents against the new draft validation rules.
- peppol-bis-3-with-nl-warnings.sch: The current PEPPOL BIS 3 validation file, with the addition of the draft country-specific rules, implemented as warnings. This can be used to test your documents against the new draft validation rules, without causing additional errors.

Do note that, like the official Peppol schematron files, these sets do NOT include the EN-16931 validation artifacts. Documents must be validated against those separately.


