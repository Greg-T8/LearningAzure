# Microsoft Identity Platform Redirect URI Constraints and Security Best Practices

Great job on selecting the correct answer! You successfully identified a specific scaling and security boundary for application registrations within the Microsoft identity platform.

Here is a detailed breakdown of how redirect URIs function, why these limits exist, and other related constraints you should know for your architectural designs:

**1. The Role of the Redirect URI**
A redirect URI (also known as a reply URL) is the exact destination where the Microsoft authorization server sends the user—along with their authentication response, such as security tokens or authorization codes—after they successfully authenticate [1]. Because sensitive tokens are delivered to this address, exact URI matching acts as a critical security boundary to prevent credentials from being sent to the wrong place or intercepted by malicious actors [2].

**2. The 100 vs. 256 URI Limit**
As you noted, if your web application is configured to support **both organizational accounts and personal Microsoft accounts** (like Skype, Xbox, or Outlook.com), you are strictly limited to a maximum of **100 redirect URIs** [2]. However, if you restrict your application to support *only* organizational accounts, the platform gives you more flexibility, allowing you to register up to **256 redirect URIs** [2]. 

**3. Additional Restrictions for Personal Accounts**
Beyond the quantity limit, there are a few other strict rules applied to redirect URIs, particularly when personal Microsoft accounts are involved:
*   **Length limit:** Each individual redirect URI is limited to a maximum of **256 characters** [2].
*   **No Query Strings:** App registrations that support personal Microsoft accounts are explicitly prohibited from using query-string parameters in their redirect URIs [2].
*   **Domain formatting:** Redirect URIs do not support internationalized domain names [2].

**Architectural and Security Best Practices:**
When designing your authentication solution, Microsoft provides several security recommendations for managing redirect URIs:
*   **Keep the list small:** Regularly review your application and trim any unused or unnecessary URIs [3].
*   **Maintain domain ownership:** You must strictly maintain ownership of all URIs configured for your app. If a domain registration lapses and someone else takes it over, it could lead to your application being compromised [3]. 
*   **Avoid insecure formats:** You should avoid wildcard reply URLs and insecure schemes (like `http` or `URN`), and always default to using secure `https` URLs [3].