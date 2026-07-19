# Application Insights Standard Availability Monitoring

Great job on selecting the correct answer! Your choice perfectly identifies the ideal tool for synthetic monitoring of public-facing endpoints across distributed geographical regions.

Here is a detailed breakdown of how **Application Insights standard availability tests** work and why they are the exact right fit for this scenario:

**1. Global Synthetic Monitoring**
Standard availability tests allow you to set up recurring web tests that monitor your application's availability and responsiveness from various points around the world [1]. They work by sending web requests to your application at regular intervals without requiring you to modify the application's underlying code [1]. The only major requirement is that the test endpoint must be an HTTP or HTTPS URL that is visible from the public internet [1, 2]. 

**2. Scale and Location Configurations**
As mentioned in your question, a single test can be configured to ping your application from up to **16 different geographic locations** [2, 3]. Microsoft recommends selecting a minimum of 5 locations to help you distinguish between a genuine application problem and a localized network routing issue [4]. You can set the test frequency to run as often as every **5 minutes** [2, 3]. An individual Application Insights resource can support up to 100 of these tests [2].

**3. Advanced Test Capabilities**
Beyond a simple ping, standard tests offer advanced validation capabilities. You can configure them to **parse dependent requests**, which means the test will also attempt to load images, scripts, style files, and other resources to ensure the entire page renders correctly [5]. They also support verifying **TLS/SSL certificate validity** and can perform proactive lifetime checks to fail the test a specified number of days before a certificate expires [4, 6, 7]. Additionally, they automatically follow up to 10 redirects and allow you to configure specific HTTP verbs, custom headers, and expected content matches in the response [2, 5, 6, 8].

**4. Preventing False Alarms (Retries and Alerting)**
To avoid triggering on-call alerts for minor network blips, it is highly recommended to enable retries [7]. With retries enabled, a specific location will only report a failure if **3 successive attempts fail** [2, 5]. Furthermore, when configuring alerts, you can set an **alert location threshold** [9]. For example, you can require that at least 3 out of 5 locations report a failure before an alert is actually triggered, ensuring you only receive notifications for legitimate, widespread outages [9].