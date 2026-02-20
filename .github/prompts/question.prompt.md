---
name: question
description: Replace selected image line with formatted question from pasted screenshot
---

# Question Extraction

Replace the selected `<img>` line with a formatted exam question extracted from a pasted screenshot.

Uses the `question-formatter` skill for extraction rules and output structure.

## Important: Image Source

The exam question content comes from the **image(s) pasted into this chat** — NOT from the `<img>` tag in the selected line. The selected `<img>` tag is only the replacement target; preserve its `src` path for the collapsed screenshot block.

## Steps

1. Extract all text from the **image(s) pasted into this chat message** (the chat attachments)
2. Format using the `question-formatter` skill structure
3. Replace the selected `<img>` line via `replace_string_in_file`

Only replace the selected image tag — do not modify other parts of the file.
