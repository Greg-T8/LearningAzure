# Add Comprehensive Inline Documentation References

Update the following hybrid-format technical guide so that every externally verifiable technical claim has an inline link to the most specific supporting documentation available.

Use web browsing and documentation search. Do not rely only on model memory or the first relevant page found.

Use this Microsoft documentation collection as the primary starting point:

<https://learn.microsoft.com/en-us/azure/azure-vmware/>

Use other relevant Microsoft Learn collections when the guide discusses related services, including Azure Virtual WAN, ExpressRoute, VPN Gateway, Azure Firewall, Azure Firewall Manager, Application Gateway, Azure Bastion, Azure Virtual Network, Network Security Groups, user-defined routes, Azure DNS, Azure DNS Private Resolver, Active Directory Domain Services, SQL Server, BGP, IPsec, and IKE.

For VMware-specific behavior not documented by Microsoft Learn, use official Broadcom or VMware technical documentation only when necessary.

## Mandatory research workflow

Process the guide section by section from beginning to end.

For each section or subsection:

1. Inventory every material technical claim, configuration requirement, limitation, numerical value, table value, product behavior, and externally verifiable recommendation.
2. Search using:

   * The section heading
   * The exact wording of the claim
   * The main product and feature names
   * Common synonyms or alternate feature names
   * The applicable architecture or generation
   * Likely article titles or subsection headings
3. Open candidate documentation and inspect the article title, table of contents, headings, tables, notes, limitations, known issues, and related links.
4. Prefer a deep link to the exact subsection that supports the claim.
5. Do not stop at a general overview when a dedicated architecture, design-consideration, configuration, limitation, routing, migration, security, or troubleshooting section may exist.
6. Keep an internal claim-to-source ledger containing the guide section, claim, support level, best source, exact supporting subsection, and proposed link text. Do not include this ledger in the final output.

### Mandatory coverage-gap pass

After the first pass, perform a second targeted search for every section that has:

* No documentation links
* Only a product overview link
* Only a generic service reference for a product-specific claim
* A callout stating that a claim is unsupported
* Several material claims supported by one loosely related link
* A table containing missing, inferred, unknown, or transcript-only values
* A distinctive feature name in the heading that was not used as a search term

Before labeling a claim unsupported, search the exact claim, its key nouns, the section heading, feature synonyms, and the applicable product generation. Review dedicated design-consideration, limitations, FAQ, known-issues, architecture, and configuration articles.

For example, a section discussing hidden or system-managed NSGs in AVS Generation 2 must locate and use:

[Delegated Subnets and Network Security Groups for Gen 2](https://learn.microsoft.com/en-us/azure/azure-vmware/native-network-design-consideration#delegated-subnets-and-network-security-groups-for-gen-2)

Do not use a generic Azure NSG overview as the sole source when an AVS-specific section directly documents the behavior.

## Preserve the guide

Retain the guide’s:

* Sections and subsections
* Brief framing paragraphs
* Hierarchical bullets
* Numbered procedures
* Tables
* Calculations
* Callouts
* Section takeaways
* Closing summaries and checklists

Do not:

* Convert bullets into long-form prose
* Significantly expand routine narrative passages
* Reduce technical detail
* Remove transcript-derived material merely because it is not documented
* Reorganize the guide except where a small structural change is required to correct an architectural distinction
* Replace the guide with a research report, citation list, or summary of changes

Return the complete updated guide, not a partial revision or list of recommendations.

## Friendly inline links

Add Markdown links directly after the sentence, clause, bullet, table value, or callout they support.

Use descriptive link text based on the official article title or exact subsection heading.

Preferred examples:

* `[Azure VMware Solution private cloud and cluster concepts](URL)`
* `[Route architecture for Azure VMware Solution Gen 2](URL)`
* `[Delegated Subnets and Network Security Groups for Gen 2](URL)`
* `[Hosts](URL#hosts)` when the subsection title is the clearest description

Do not use generic labels such as:

* `[Microsoft Learn]`
* `[Documentation]`
* `[Learn more]`
* `[Reference]`
* `[Source]`
* `[Here]`

Link rules:

1. Use the official article title when linking to the whole article.
2. Use the exact subsection heading when linking to an anchor.
3. Prefer canonical English `en-us` Microsoft Learn URLs.
4. Remove tracking parameters and unnecessary query strings.
5. Place each link beside the exact claim it supports.
6. Use the most specific source available.
7. Do not use one generic link for several unrelated claims.
8. Do not imply that a source supports a stronger claim than it does.
9. Do not add links to transcript-derived analogies merely to increase citation density.
10. Do not repeat the same link after every sentence when one placement clearly supports one tightly related group of statements.
11. Do not leave bare URLs in the guide body when a descriptive Markdown link can be used.

When a bullet contains several independently verifiable claims, link the individual clauses or sentences separately.

## Complete missing table values

Inspect every table for placeholders or inferred values, including:

* `Not specified in transcript`
* `Not provided`
* `Unknown`
* `TBD`
* `Not separately quantified`
* `Implied by profile name`
* Empty cells
* Similar wording indicating that the transcript did not contain the value

For every such cell:

1. Determine whether the value is an externally verifiable specification, limit, requirement, regional dependency, or documented behavior.
2. Search current official documentation for the exact value.
3. Replace the placeholder or inference with the authoritative documented value.
4. Include the applicable units and scope, such as per host, per cluster, per NIC, per region, or per generation.
5. Add a descriptive link in the cell or in an immediately adjacent source note that points to the exact supporting subsection or table.
6. Prefer an explicit documented value over an inference from a SKU or product name.
7. When a value varies by region, generation, architecture, or release, state the applicable scope.
8. When official sources conflict, use the most current directly applicable primary source and add a brief documentation note.
9. Only retain a missing value after a targeted search fails. In that case, use:
   `Not documented in the reviewed official sources`
   rather than:
   `Not specified in transcript`

The absence of a value from the transcript is not a reason to leave a table incomplete when official documentation supplies the value.

A table based primarily on one Microsoft table may use a descriptive source link in the table introduction or a source note if that source clearly supports all affected cells. Values from different sources must be linked separately.

## Source hierarchy

Use sources in this order:

1. The exact Microsoft Learn subsection that directly states the behavior or value
2. A dedicated Microsoft Learn architecture, design-consideration, configuration, limitation, migration, security, routing, known-issues, or troubleshooting article
3. A Microsoft Learn concepts article containing a directly applicable subsection or table
4. A product overview only when no more specific source exists
5. Official Broadcom or VMware technical documentation for VMware behavior Microsoft does not document

Do not use:

* Search-result summaries as evidence
* AI-generated summaries as evidence
* Community posts as primary evidence
* Vendor marketing pages when technical documentation exists
* Third-party blogs for documented Microsoft product behavior
* Generic Azure service documentation when a product-specific AVS page documents the exact integration or limitation

Search results may locate a source, but the final link must point to the source article itself.

## Documentation validation

Classify each material statement as:

1. Directly supported by official documentation
2. Partially supported but stated too strongly
3. Transcript-derived
4. An architectural or operational interpretation
5. Unsupported or inconsistent with available documentation

### Directly supported

Retain the content and add the most specific descriptive inline link.

### Partially supported or overstated

Preserve the subject and add a concise correction immediately after it:

> **Documentation correction:** Microsoft documents that...

Keep corrections brief—normally one bullet or two to four sentences—and link to the exact supporting subsection.

### Architectural or operational interpretations

Use:

> **Architectural interpretation:**

or:

> **Operational recommendation:**

Link the underlying documented facts, but do not imply that Microsoft explicitly recommends the interpretation unless the source says so.

### Transcript-derived material

Use:

> **Transcript-derived scenario:**

> **Transcript-derived analogy:**

> **Transcript-derived calculation:**

Do not attach a loosely related link to an analogy or scenario. Link separately documented inputs, limits, or product behavior where applicable.

### Unsupported material

Use:

> **Not directly supported by the reviewed documentation:**

only after completing both the initial research pass and the mandatory coverage-gap pass.

State exactly which portion could not be confirmed. Do not label an entire section unsupported when part of it is directly documented. Do not attach a generic or loosely related source to unsupported content.

## Combined architectures

The guide may combine behavior from:

* A Microsoft-managed Azure Virtual WAN hub
* A customer-managed hub VNet
* A secured Virtual WAN hub using routing intent
* A hub VNet using route tables and user-defined routes
* AVS Generation 1 ExpressRoute-based connectivity
* AVS Generation 2 native VNet connectivity
* Initial and current AVS Generation 2 internal network architectures

When this occurs:

* Preserve the original topic.
* Identify which architecture the behavior applies to.
* Explain the distinction concisely.
* Link to the exact documentation subsection for each pattern.
* Do not silently merge architectures.
* Do not apply a limitation from one generation or internal architecture to another without documentation.
* Keep corrections proportionate to the surrounding content.

## Calculations and examples

Retain transcript-derived calculations and examples.

Verify arithmetic independently, but do not describe a calculated value as Microsoft-published unless Microsoft explicitly publishes it.

Use this format where appropriate:

> **Transcript-derived calculation:** At the stated inputs, the theoretical result is...

Then separately identify:

* Protocol overhead
* Effective throughput
* Environmental variables
* Microsoft-documented constraints

Link documented inputs and limits with descriptive article or subsection names.

## Final quality review

Before completing the guide, perform these checks.

### Coverage audit

* Review every section and subsection for uncited material claims.
* Re-search sections supported only by generic overview pages.
* Re-search every unsupported callout.
* Confirm that product-specific sources were preferred over generic service pages.
* Confirm that each link supports the exact nearby claim.
* Confirm that tables, procedures, limitations, security behavior, and numerical values received the same research depth as prose.

### Link audit

* Ensure there are no `[Microsoft Learn]` links.
* Ensure there are no generic labels such as `[Documentation]`, `[Reference]`, `[Source]`, or `[Here]`.
* Verify that link text matches the official article title or subsection heading.
* Verify and use section anchors where available.
* Remove tracking parameters, unnecessary query strings, duplicate links, and bare URLs.

### Table audit

* Search for every occurrence of `Not specified in transcript`, `Not provided`, `Unknown`, `TBD`, `implied`, and similar placeholders.
* Replace placeholders with documented values when authoritative sources exist.
* Verify units, scope, and applicability.
* Replace SKU-name inference with explicit documented specifications.
* Label any unresolved value `Not documented in the reviewed official sources`.

### Fidelity audit

* Preserve all original substantive technical content.
* Preserve the hybrid structure.
* Keep bullets as the primary vehicle for detailed content.
* Keep paragraphs short and purposeful.
* Preserve tables, procedures, calculations, callouts, takeaways, and checklists.
* Keep documentation corrections concise.
* Ensure the result remains a readable technical guide rather than a citation-heavy research report.

Update the final **Documentation and Interpretation Notes** section so that it summarizes only:

* Material documentation corrections
* Claims that remained unsupported after targeted research
* Combined or easily confused architecture patterns
* Important interpretive or operational recommendations

Do not repeat every inline callout or provide a bibliography.

## Output requirement

Return the entire completed technical guide in Markdown format.

Do not return:

* A research plan
* The internal claim-to-source ledger
* A list of discovered links
* A summary of proposed changes
* A partial document
* A statement that the document could not be rewritten

The final output must be the updated guide itself, with descriptive inline links, completed table values where official documentation supplies them, and all original substantive content preserved.
