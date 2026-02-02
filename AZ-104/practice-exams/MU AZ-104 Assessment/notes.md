# MeasureUp Assessment AZ-104: Microsoft Azure Administrator

## Overview

Notes and insights from the MeasureUp practice assessment for AZ-104.

I took this assessment on Friday, January 30th, after reviewing the Microsoft Learn content and the John Savill video course, but prior to completing the hands-on labs and practice exams.

## Assessment Results

<img src='.img/2026-01-30-06-23-36.png' width=700>

<img src='.img/2026-01-30-06-25-12.png' width=700>

---

## Wrong Answers Review

<img src='.img/2026-01-30-05-33-53.png' width=700>

<details>
<summary>Click to expand explanation</summary>

## Your Answer vs. The Correct Sequence

**Your selected order:**

1. Create a Microsoft Entra group and add users to the group ✓
2. Select the Microsoft Entra group for which you want to allow SSPR ✗
3. Register an authentication method for SSPR ✗
4. Enable SSPR with the Selected option ✗

## The Issue

The main problem is with **steps 2-4**. You're trying to select a group for SSPR (step 2) before SSPR is even enabled (step 4). Additionally, you should configure the authentication method requirements before enabling SSPR.

## The Correct Order Should Be

1. **Create a Microsoft Entra group and add users to the group** ✓
   - This satisfies the requirement to "add and remove users" by managing group membership

2. **Register an authentication method for SSPR**
   - This configures "one additional piece of personal information" that users must provide (like security questions, phone, email, etc.)

3. **Enable SSPR with the Selected option**
   - You use "Selected" (not "All") because you only want a subset of users to have SSPR access
   - This must be done before you can assign groups to SSPR

4. **Select the Microsoft Entra group for which you want to allow SSPR**
   - Now you can specify which group(s) should have SSPR enabled
   - Users can be added/removed from SSPR by managing group membership

## Key Takeaway

You must **configure the authentication requirements and enable SSPR** before you can **assign it to specific groups**. Think of it as: configure what → enable it → specify who gets it.

</details>

---

<img src='.img/2026-01-30-06-03-01.png' width=700>

<details>
<summary>Click to expand explanation</summary>

Looking at your selected answers, I can help you understand why this approach doesn't meet the requirements.

## Your Selected Answer

1. ✓ Assign the built-in Contributor role to the SalesDepartment group for the RG1 resource group
2. ✗ Assign the built-in Reader role to the SalesDepartment group at the subscription level

## The Problem with Your Answer

**The second selection violates the least privilege principle:**

When you assign **Reader at the subscription level**, the Sales team gets read access to **ALL** resource groups in the subscription, including:

- RG1 ✓ (needed)
- RG2 ✓ (needed)
- **RG3 ✗ (NOT allowed by requirements)**

The requirement explicitly states: "The Sales team should be able to read resources in RG1 and RG2 **only**."

## The Correct Answer Should Be

1. **Assign the built-in Contributor role to the SalesDepartment group for the RG1 resource group** ✓
   - Allows creating resources in RG1
   - Allows reading resources in RG1
   - Does NOT allow assigning permissions (Contributor lacks this ability)

2. **Assign the built-in Reader role to the SalesDepartment group for the RG2 resource group** ✓
   - Allows reading resources in RG2 only
   - Does NOT allow creating resources
   - No access to RG3

## Why This Meets All Requirements

✓ Read resources in RG1 and RG2 only (not RG3)  
✓ Create resources in only RG1  
✓ Cannot assign permissions (Contributor doesn't include this)  
✓ Cannot create resource groups (no subscription-level permissions)  
✓ Follows least privilege principle

## Key Takeaway

Avoid assigning roles at higher scopes (like subscription level) when you can achieve the same result at lower scopes (resource group level). Always grant the minimum access needed at the most specific scope possible.

</details>

---

<img src='.img/2026-01-30-06-20-49.png' width=700>

---

<img src='.img/2026-01-30-05-46-07.png' width=700>

---

<img src='.img/2026-01-30-05-58-51.png' width=700>

---

<img src='.img/2026-01-30-05-31-43.png' width=700>

---

<img src='.img/2026-01-30-05-50-54.png' width=700>

<img src='.img/2026-01-30-05-42-04.png' width=400>

---

<img src='.img/2026-01-30-06-01-29.png' width=700>

---

<img src='.img/2026-01-30-05-38-46.png' width=700>

---

<img src='.img/2026-01-30-06-12-43.png' width=700>

---

<img src='.img/2026-01-30-05-53-50.png' width=700>

---

<img src='.img/2026-01-30-05-30-07.png' width=700>

---

<img src='.img/2026-01-30-05-26-15.png' width=700>

---

<img src='.img/2026-01-30-06-20-01.png' width=700>

---

<img src='.img/2026-01-30-05-36-07.png' width=700>

---

<img src='.img/2026-01-30-05-41-40.png' width=700>

---

## Correctly Answered Questions

<img src='.img/2026-01-30-05-24-16.png' width=700>

---

<img src='.img/2026-01-30-05-24-56.png' width=700>

---

<img src='.img/2026-01-30-05-34-11.png' width=500>

---

<img src='.img/2026-01-30-05-55-46.png' width=700>

---

<img src='.img/2026-01-30-05-57-13.png' width=700>

---

<img src='.img/2026-01-30-05-59-35.png' width=700>

---

<img src='.img/2026-01-30-06-00-11.png' width=700>

---

<img src='.img/2026-01-30-06-03-32.png' width=700>

---

<img src='.img/2026-01-30-06-06-46.png' width=700>

---

<img src='.img/2026-01-30-06-08-51.png' width=700>

---

<img src='.img/2026-01-30-06-10-09.png' width=700>

---

<img src='.img/2026-01-30-06-15-31.png' width=700>

---

<img src='.img/2026-01-30-06-17-12.png' width=700>

---

<img src='.img/2026-01-30-06-17-46.png' width=700>

---

<img src='.img/2026-01-30-06-18-07.png' width=700>

---

<img src='.img/2026-01-30-06-21-46.png' width=700>

---

<img src='.img/2026-01-30-06-23-03.png' width=700>
