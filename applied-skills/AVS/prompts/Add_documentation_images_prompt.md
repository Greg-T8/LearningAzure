## Documentation images

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

6. Preserve the original image and aspect ratio.

7. Do not crop, annotate, recolor, redraw, or otherwise alter the image.

8. Do not use search-result thumbnails, cached previews, or third-party copies.

9. Do not include an image unless both its Microsoft documentation page and original image URL can be identified.

10. Avoid duplicate or substantially similar images.

11. Place each image immediately after the section, bullet group, table, or procedure it supports.

12. Limit images to those that provide substantial explanatory value.

If an image cannot be downloaded reliably, do not create a nonexistent local path. Link to the relevant documentation page instead.

### Image manifest

At the end of the guide, add an `Image Sources` section:

| Local file | Description | Microsoft documentation page | Original image URL |
| ---------- | ----------- | ---------------------------- | ------------------ |

Include only images actually packaged with the guide.

### Deliverable format

Return a ZIP archive containing:

* The updated Markdown file
* An `images` directory
* Every image referenced by the Markdown file

Before completing the deliverable, verify that every relative image path resolves to an included file.
