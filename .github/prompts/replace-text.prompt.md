---
name: Replace Text
description: Replaces the text on the current line with "<<< Test Text >>>"
---

# Replace Text Prompt

You will be given the selected text (${selectedText}).

Rules:

- If the selection contains more than one line, DO NOT propose an edit. Respond with:
  "Select only the target line (Ctrl+L) and run the prompt again."
- If the selection is exactly one line, replace it so the line only contains:
  <<< Test Text >>>
- Make no other changes.
