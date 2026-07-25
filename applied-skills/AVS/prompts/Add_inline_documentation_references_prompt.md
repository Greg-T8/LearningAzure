Update the following hybrid-format technical guide so that its technical claims contain inline links to supporting documentation where documentation is available.

Use the following Microsoft documentation collection as the primary starting point:

<https://learn.microsoft.com/en-us/azure/azure-vmware/>

Use other relevant Microsoft Learn documentation when the guide discusses related services such as:

* Azure Virtual WAN
* ExpressRoute
* VPN Gateway
* Azure Firewall
* Azure Firewall Manager
* Application Gateway
* Azure Bastion
* Azure DNS
* Azure DNS Private Resolver
* Active Directory Domain Services
* SQL Server
* Border Gateway Protocol
* IPsec and IKE

## Preserve the existing format

Retain the guide’s:

* Sections and subsections
* Brief framing paragraphs
* Hierarchical bullets
* Numbered procedures
* Tables
* Calculations
* Callouts
* Closing summaries and checklists

Do not convert bullets back into long-form prose.

Do not significantly expand the narrative portions of the document.

Do not reduce the level of technical detail.

Do not reorganize the guide unless a small structural change is necessary to correct a documented architectural distinction.

## Inline-link requirements

Add Markdown links directly after the sentence or clause they support.

Prefer:

1. The most specific Microsoft Learn page
2. The exact configuration or architecture article
3. A product overview only when no more specific page exists

Do not:

* Add one generic citation to the end of a long bullet containing several unrelated claims
* Use a source that only loosely relates to the statement
* Imply that a source supports a stronger claim than it actually makes
* Add documentation links to transcript-specific analogies
* Add links merely to increase citation density
* Repeat the same link after every sentence when one placement clearly supports a tightly related group of statements

When a bullet contains several independently verifiable claims, place links beside the individual claims they support.

## Documentation images

When reviewing the supporting Microsoft documentation, identify diagrams or
screenshots that materially improve the guide's explanation.

Include an image only when it directly supports the surrounding content, such as:

* Reference architecture diagrams
* Connectivity and routing diagrams
* Traffic-flow diagrams
* Component relationship diagrams
* Configuration screenshots that clarify a complex procedure

Do not add decorative images, product banners, generic service icons, or images
that merely repeat the surrounding text.

### Image retrieval and packaging

For each selected image:

1. Download the original image asset from the official documentation page.
2. Store it in an `images` directory accompanying the Markdown document.
3. Give the image a descriptive lowercase filename using hyphens.
4. Insert it using a relative Markdown path:

   ![Descriptive alt text](images/descriptive-filename.png)

5. Immediately below the image, include a source caption linked to the
   documentation article:

   *Source: [Microsoft Learn — Article title](documentation-page-url)*

6. Preserve the image's original aspect ratio.
7. Do not crop, alter, annotate, or recreate the image.
8. Do not use an image obtained from search-result previews or third-party sites.
9. Do not include an image unless its original Microsoft documentation page can
   be identified.
10. Avoid duplicate images, including images reused across multiple Microsoft
    documentation pages.

Place each image immediately after the paragraph, bullet group, or section that
it supports. Do not place all images in a separate gallery.

### Image manifest

At the end of the document, add an `Image Sources` table containing:

| Local file | Description | Microsoft documentation page | Original image URL |
|---|---|---|---|

If an image cannot be downloaded reliably, do not fabricate a local path.
Instead, retain the documentation link and state that the image was not packaged.

## Documentation validation

Evaluate each material statement as one of the following:

1. Directly supported by Microsoft documentation
2. Partially supported but stated too strongly
3. A transcript-derived scenario, analogy, or calculation
4. An architectural or operational interpretation
5. Unsupported or inconsistent with the available documentation

Retain supported content and add the appropriate inline link.

For partially supported or overstated content, preserve the original subject but add a concise correction immediately after it:

> **Documentation correction:** Microsoft documents that...

Keep corrections brief—normally one bullet or two to four sentences. Do not create long correction essays.

For content that is reasonable but not explicitly prescribed by Microsoft, use:

> **Architectural interpretation:**

or:

> **Operational recommendation:**

For content originating from the transcript rather than product documentation, use:

> **Transcript-derived scenario:**

> **Transcript-derived analogy:**

> **Transcript-derived calculation:**

For content that cannot be validated, use:

> **Not directly supported by the reviewed documentation:**

Do not attach a loosely related link to unsupported content.

## Handling conflicts and combined architectures

The transcript may combine behavior from different Azure architecture patterns, including:

* A Microsoft-managed Azure Virtual WAN hub
* A traditional customer-managed hub VNet
* A secured Virtual WAN hub using routing intent
* A hub VNet using route tables and user-defined routes

When this occurs:

* Preserve the original topic.
* Identify which architecture pattern the behavior applies to.
* Explain the distinction concisely.
* Link to documentation for each applicable pattern.
* Do not silently merge the patterns.
* Do not allow the correction to overwhelm the primary technical content.

## Calculations and examples

Retain transcript-derived calculations and examples.

Verify the arithmetic independently, but do not characterize a calculated value as a Microsoft-published estimate unless Microsoft explicitly publishes it.

Use this format where appropriate:

> **Transcript-derived calculation:** At the stated inputs, the theoretical result is...

Then separately identify:

* Protocol overhead
* Effective throughput
* Environmental variables
* Microsoft-documented constraints

## Link and source quality

Use official Microsoft documentation as the primary authority.

For VMware HCX behavior not described by Microsoft Learn, an official Broadcom or VMware source may be used only when necessary. Clearly distinguish it from Microsoft documentation.

Do not use:

* Search-result summaries
* Community posts as primary evidence
* Vendor marketing pages when technical documentation exists
* Third-party blogs for documented Microsoft product behavior

## Final quality review

Before completing the document, verify that:

* Every major documented claim has an appropriate inline reference where available.
* Unsupported claims are labeled rather than force-cited.
* Documentation corrections are concise and specific.
* The original technical detail has not been removed.
* The hybrid structure has been preserved.
* Bullet points remain the primary vehicle for detailed content.
* Paragraphs remain short and purposeful.
* Tables and numbered procedures have not been converted into prose.
* Links are placed beside the exact claims they support.
* The document remains readable as a technical guide rather than becoming a citation-heavy research report.

Update the final **Documentation and Interpretation Notes** section so that it summarizes only material corrections, unsupported claims, combined architecture patterns, and important interpretive recommendations. Do not repeat every inline callout in that closing section.
