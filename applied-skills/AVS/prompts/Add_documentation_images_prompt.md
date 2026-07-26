## Documentation images

The input is a technical guide in Markdown format. Its sections may already contain links to relevant Microsoft Learn documentation. Use those existing documentation links as the primary starting point for identifying diagrams and screenshots that materially improve the guide.

### Use existing documentation links as image-discovery seeds

Process the guide section by section:

1. Identify every Microsoft Learn link already present in the current section, including links in paragraphs, bullet lists, tables, notes, and source references.

2. Treat those linked pages as the first and preferred image sources for that section. Open each linked page and inspect its figures, diagrams, topology illustrations, workflow images, and procedural screenshots.

3. Preserve URL fragments when present. A link to a specific heading or subsection indicates the intended documentation context and should be reviewed before unrelated parts of the article.

4. Evaluate each image against the surrounding section content. Select an image only when it directly explains or reinforces the specific architecture, behavior, relationship, or procedure discussed nearby.

5. When a linked Microsoft Learn page does not contain a suitable image, use it as a search seed:

   * Extract the article title, service name, feature name, and relevant heading.
   * Follow directly related Microsoft Learn links from that page when they are clearly relevant to the same concept.
   * Search only official Microsoft documentation for a more suitable diagram or screenshot.
   * Prefer documentation for the same service, feature, generation, SKU, deployment model, or configuration workflow described in the guide.

6. Do not begin with a broad web or image search when the section already contains relevant Microsoft Learn links. Exhaust the linked pages and their directly related Microsoft documentation first.

7. If several guide sections reference the same documentation page, inspect the page once, but place each selected image only where it provides the strongest explanatory value.

8. Do not assume that every linked page requires an image. It is acceptable for a section to remain text-only when no image adds substantial value.

While reviewing the supporting Microsoft documentation, identify diagrams and screenshots that materially improve the guide.

Include an image only when it directly clarifies:

* Architecture or topology
* Connectivity and traffic flow
* Routing relationships
* Component dependencies
* A configuration procedure that is difficult to explain through text alone

Do not include decorative images, product banners, generic service icons, or screenshots that merely repeat the surrounding text.

### Image retrieval and packaging

For each selected image:

1. Retrieve the original image asset from the official Microsoft Learn documentation page.

2. Save it in an `images` directory accompanying the Markdown document.

3. Assign it a descriptive lowercase filename using hyphens.

4. Reference it from the Markdown file using a relative path:

   `![Descriptive alternative text](images/descriptive-filename.png)`

5. Immediately below the image, add a source caption:

   `*Source: [Microsoft Learn — Article title](documentation-page-url)*`

6. Use the exact Microsoft Learn page where the image appears in the source caption, even when a different existing link in the guide was used as the original search seed.

7. Preserve the original image and aspect ratio.

8. Do not crop, annotate, recolor, redraw, or otherwise alter the image.

9. Do not use search-result thumbnails, cached previews, or third-party copies.

10. Do not include an image unless both its Microsoft documentation page and original image URL can be identified.

11. Avoid duplicate or substantially similar images.

12. Place each image immediately after the section, bullet group, table, or procedure it supports.

13. Limit images to those that provide substantial explanatory value.

If an image cannot be downloaded reliably, do not create a nonexistent local path. Retain or add a friendly link to the relevant Microsoft Learn documentation page instead.

### Deliverable format

Return a ZIP archive containing:

* The updated Markdown file
* An `images` directory
* Every image referenced by the Markdown file

Before completing the deliverable, verify that:

* Every relative image path resolves to an included file.
* Every image source caption points to the Microsoft Learn page where the image appears.
* No selected image is unrelated to the guide section where it is placed.
