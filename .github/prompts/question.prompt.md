---
name: question
description: Replace selected image line with formatted question from pasted screenshot
---

# Question Extraction

Replace the selected `<img>` line with a formatted exam question extracted from a pasted screenshot.

Uses the `question-formatter` skill for extraction rules and output structure.

1. Extract all text from the pasted screenshot image
2. Format using the `question-formatter` skill structure
3. Replace the selected image line via `replace_string_in_file`

Only replace the selected image tag — do not modify other parts of the file.
