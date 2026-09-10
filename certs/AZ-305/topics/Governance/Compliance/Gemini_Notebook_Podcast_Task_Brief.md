Restrict coverage to only the task(s) listed below.

Exam: AZ-305  
Skill: Design governance
Task(s): Recommend a solution for managing compliance

Create a long-form, advanced AZ-305 technical review podcast focused on architectural decision-making, scenarios, misconceptions, edge cases, and exam reasoning for the listed task(s). Do not cover other AZ-305 tasks, skills, domains, or objectives, even if present in the source material.

Assume the listener already understands basic Azure terminology. Spend minimal time on elementary definitions unless they are necessary to clarify an important distinction.

The priority is understanding WHY one design choice is correct and why another plausible choice is wrong.

## SOURCE HIERARCHY AND AUTHORITY

Base the entire podcast on the source named **Task Brief**. The Task Brief is the authoritative document for the podcast's content coverage, architectural narrative, task scope, decision model, and exam objectives. Do not let another source expand, redirect, or override the Task Brief.

Use the selected sources according to these roles:

1. **TASK BRIEF — authoritative source**

Use the Task Brief to determine:

- the AZ-305 domain, skill, and task being covered
- the scope boundary and adjacent topics that must not become primary coverage
- major design areas
- related technologies
- architectural relationships
- decision criteria
- the depth and sequence needed to explain the task
- broader AZ-305 concepts that provide context for the detailed topics

Every major segment, scenario, comparison drill, misconception, and final decision rule must support a topic, relationship, requirement, or boundary in the Task Brief.

2. **TASK MAP — scope cross-check, when available**

Use the Task Map to verify the task-to-domain and task-to-skill relationship and to cross-check coverage boundaries. It may help identify mapped subtopics, but it does not override the Task Brief's authority for this podcast.

3. **TASK FACT SHEET — supporting technical detail, when available**

Use the Task Fact Sheet for detailed facts, limits, prerequisites, supported scenarios, tradeoffs, and exam discriminators that belong to the Task Brief's scope. It may deepen the explanation but must not broaden the podcast beyond the Task Brief.

4. **MICROSOFT DOCUMENTATION — technical grounding**

Use selected Microsoft documentation to verify and deepen the discussion with:

- implementation behavior
- scope
- prerequisites
- inheritance
- limits
- exceptions
- supported and unsupported configurations
- current Microsoft recommendations

Use Microsoft documentation as the grounding authority for current technical behavior and supportability within the Task Brief's scope. Do not use it to introduce unrelated services, adjacent AZ-305 tasks, or topics that the Task Brief does not cover.

5. **STUDY GUIDE FOR EXAM — context source, when available**

Use the source or link named *Study guide for Exam* to confirm the domain, skill, and task context. Use it for alignment and context, not as a replacement for the Task Brief's detailed coverage.

6. **OTHER SOURCES — supporting detail only**

Use additional selected sources only when they provide useful supporting detail for a topic already covered by the Task Brief. They cannot override the Task Brief or expand the podcast's scope.

If sources disagree, preserve the Task Brief's scope and architectural intent. Use the most specific applicable supporting source to clarify a technical detail, and corroborate it against Microsoft documentation. If a conflict cannot be resolved from the provided sources, do not invent a resolution; state the gap briefly and avoid making the disputed detail decisive.

Before writing, identify the applicable Task Brief, Task Map, Task Fact Sheet, Microsoft documentation, Study guide for Exam, and other supporting sources. Treat similarly named files as the corresponding source type even when filenames use underscores, hyphens, or additional version text.

SCENARIO-BASED FORMAT

Organize most of the podcast around realistic Azure architecture scenarios.

For each important topic:

1. Present an architectural requirement or problem.
2. Have one host propose a plausible solution.
3. Have the other host challenge the proposal.
4. Identify competing Azure design choices.
5. Determine the best solution.
6. Explain exactly which requirement drives the choice.
7. Explain why the alternatives are weaker or incorrect.
8. Discuss relevant technical behavior, limitations, or exceptions.
9. Change one requirement and explain whether the answer changes.
10. Connect the lesson to the type of wording likely to appear on AZ-305.

Frequently ask questions such as:

- "What requirement actually decides this?"
- "Why isn't the obvious alternative correct?"
- "At what scope should this be implemented?"
- "What happens if this resource or configuration is moved?"
- "What is inherited?"
- "What isn't inherited?"
- "What happens automatically, and what requires explicit configuration?"
- "Is this a hard platform limit, a quota, or a design recommendation?"
- "What is the operational consequence of this decision?"
- "What security or governance consequence does this have?"
- "What would have to change in the scenario for the other answer to become correct?"
- "What AZ-305 keyword or requirement should trigger recognition of this design?"

COMPARISON DRILLS

Whenever the sources describe two or more concepts that could reasonably be confused, stop and perform a comparison drill.

For each comparison explain:

- when to choose A
- when to choose B
- the key technical difference
- the architectural consequence
- the exam clue that distinguishes them
- a scenario where A is correct
- a scenario where B is correct

Do not assume that similar Azure concepts are interchangeable.

MISCONCEPTIONS AND HIGH-VALUE DISTINCTIONS

Give additional attention to the distinctions, limitations, edge cases, and exam discriminators established by the Task Brief and its supporting sources, while keeping the Task Brief authoritative for scope and coverage.

For each important misconception or easily confused design choice:

- reconstruct the likely misconception
- explain why it sounds reasonable
- identify the precise Azure behavior that disproves it
- provide a memorable rule for distinguishing the correct answer
- test that rule against another scenario

DEPTH

Do not turn this into a rapid-fire quiz with shallow answers.

Each important scenario should include enough technical reasoning to teach the underlying architecture.

Maintain approximately the same depth throughout the podcast. Do not rush the final portion.

Before concluding, verify that every major Task Brief topic, requirement, boundary, and decision rule has been addressed and that every podcast segment remains grounded in the Task Brief.

If all in-scope Task Brief coverage has been addressed, continue with additional:

- scenario variations
- edge cases
- architecture tradeoffs
- "what changes if..." exercises
- incorrect-but-plausible solutions
- comparison drills

Do not add unrelated filler.

Finish with a rapid architectural decision round covering the highest-value distinctions from this exam task, followed by a final explanation of the overall decision model the listener should use when answering AZ-305 architecture questions.
