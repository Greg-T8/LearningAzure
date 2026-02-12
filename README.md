<!-- markdownlint-disable-next-line MD041 -->
<div align="center">

# <img src="./.assets/Azure_Advisor.svg" width="36" height="36" alt="Learning Azure" style="vertical-align: middle; margin-right: 10px;" /> Learning Azure

This repository documents my Azure learning journey, from certification prep to staying current with Azure updates.

[![AI-102](https://img.shields.io/badge/AI--102-In%20Progress-yellow)](AI-102/) [![AZ-104](https://img.shields.io/badge/AZ--104-In%20Progress-yellow)](AZ-104/) ![GitHub commit activity](https://img.shields.io/github/commit-activity/m/Greg-T8/LearningAzure) ![GitHub last commit](https://img.shields.io/github/last-commit/Greg-T8/LearningAzure)

[![AI-900](https://img.shields.io/badge/AI--900-Completed-green)](AI-900/)
</div>

---

## 📚 Certifications

Progress trackers, detailed study notes, practice exams, and hands-on labs:

- 📗 [**AZ-104**](AZ-104/README.md) — Azure Administrator Associate
- 📙 [**AI-102**](AI-102/README.md) — Azure AI Engineer Associate
- 📘 [**AI-900**](AI-900/README.md) — Azure AI Fundamentals (*completed 2/9/26*)

---

<!-- COMMIT_STATS_START -->
## 📈 Recent Activity (Last 7 Days)

| Date | AI-102 | AZ-104 | AI-900 | Total |
|------|--------|--------|--------|-------|
| Thu, Feb 12 | 🟣 2.4h | 🟣 2.8h |  | **5.2h** |
| Wed, Feb 11 | 🟢 1.5h | 🟣 4.1h |  | **5.6h** |
| Tue, Feb 10 | 🟢 1.8h | 🟣 2.1h |  | **3.9h** |
| Mon, Feb 09 | 🟢 1.1h | 🟣 2.9h | 🟣 2.4h | **6.4h** |
| Sun, Feb 08 |  | 🟣 2.9h | 🟢 1.0h | **3.9h** |
| Sat, Feb 07 |  | 🟣 2.7h | 🟡 0.6h | **3.3h** |
| Fri, Feb 06 |  | 🟣 3.7h |  | **3.7h** |
| **Weekly Total** | **6.8h** | **21.2h** | **4.0h** | **32.0h** |
| ***Running Total*** | ***5.7h*** | ***64.7h*** | ***21.7h*** | ***92.1h*** |

*Activity Levels: 🟡 Low (< 1hr) | 🟢 Medium (1-2hrs) | 🟣 High (> 2hrs)*

*Hours = time between first and last commit of the day in that certification folder*

*Last updated: February 12, 2026 at 06:48 CST*

<!-- COMMIT_STATS_END -->

---

## 🔄 Staying Current with Azure

Ongoing learning beyond certification prep, including tracking Azure updates and deep dives.

- 📝 [**Ongoing Learning Activity**](ongoing-learning/README.md)

---

## 📖 Learning Approach

My exam preparation follows a practice exam-driven methodology that emphasizes hands-on experience:

### Primary Learning Method

1. **Practice Exams** — Identify knowledge gaps by attempting practice exam questions
2. **Hands-on Labs** — For each question I get wrong or am unsure about, I build a dedicated environment tailored to that exam question using Terraform or Bicep
3. **Documentation** — Document the hands-on experience to reinforce learning and create reference materials

### Supplementary Learning

- **Video Training** — Conceptual overviews and expert perspectives through resources like [John Savill's YouTube channel](https://www.youtube.com/@NTFAQGuy)
- **Microsoft Learning Paths** — Structured learning content to supplement hands-on experience

---

## 🛠️ Development

### Markdown Linting

This repository uses [markdownlint-cli2](https://github.com/DavidAnson/markdownlint-cli2) to ensure consistent markdown formatting across all documentation.

**Prerequisites:**

- Node.js and npm installed

**Installation:**

```bash
npm install
```

**Run markdownlint on all folders:**

```bash
npm run lint:md
```

**Auto-fix fixable issues:**

```bash
npm run lint:md:fix
```

The tool will scan all markdown files (`.md`) across all folders in the workspace, using the configuration defined in `.markdownlint-cli2.jsonc` and `.markdownlint.yml`.
