# Executive Search Firm Outreach Template

## Template Variables
- `{{FIRM_NAME}}` - Search firm name
- `{{CONTACT_NAME}}` - Contact person name
- `{{MY_NAME}}` - Your name
- `{{MY_TITLE}}` - Your current/last title
- `{{MY_COMPANY}}` - Your current/last company
- `{{MY_EXPERIENCE}}` - Brief experience summary
- `{{TARGET_ROLES}}` - Target role types
- `{{DATE}}` - Current date

## Template 1: Cold Outreach (Search Firm Partner)

**Subject:** Introduction: {{MY_NAME}} - {{MY_TITLE}} at {{MY_COMPANY}}

Dear {{CONTACT_NAME}},

I hope this email finds you well. My name is {{MY_NAME}}, and I'm currently the {{MY_TITLE}} at {{MY_COMPANY}}. I'm reaching out because I'm exploring new executive opportunities in cybersecurity leadership and have long admired {{FIRM_NAME}}'s work in placing top security talent.

With {{MY_EXPERIENCE}} years of experience building and scaling security programs, I've led teams through [mention 1-2 key achievements]. I'm particularly interested in {{TARGET_ROLES}} roles where I can drive security strategy and transformation.

I would be grateful for 15-20 minutes of your time to introduce myself and learn more about {{FIRM_NAME}}'s approach to executive search in the cybersecurity space. I'm flexible to accommodate your schedule.

Thank you for your consideration.

Best regards,

{{MY_NAME}}
{{MY_TITLE}}
[LinkedIn Profile URL]
[Phone Number]

---

## Template 2: Warm Outreach (Referred Introduction)

**Subject:** Following up on [Referrer Name]'s introduction

Dear {{CONTACT_NAME}},

I hope you're having a productive week. [Referrer Name] suggested I reach out to you as I explore new executive opportunities in cybersecurity leadership. They spoke highly of your work at {{FIRM_NAME}} and thought we should connect.

As {{MY_TITLE}} at {{MY_COMPANY}}, I've [mention 1 key achievement relevant to the firm's focus]. I'm particularly interested in {{TARGET_ROLES}} opportunities where I can [specific value proposition].

Would you have 15 minutes for a brief introductory call next week? I'm happy to work around your schedule.

Looking forward to connecting.

Best,

{{MY_NAME}}
{{MY_TITLE}}
[LinkedIn Profile URL]

---

## Template 3: Follow-up After Initial Contact

**Subject:** Following up: {{MY_NAME}} - {{MY_TITLE}}

Dear {{CONTACT_NAME}},

Following up on our conversation [date/time of call], I wanted to thank you again for your time and insights about {{FIRM_NAME}}'s cybersecurity practice.

As discussed, my background includes [briefly reiterate 1-2 most relevant points]. I remain particularly interested in {{TARGET_ROLES}} opportunities, especially those involving [specific challenge or context mentioned].

Please keep me in mind for relevant searches, and don't hesitate to reach out if you'd like any additional information about my background.

Best regards,

{{MY_NAME}}
{{MY_TITLE}}

---

## Template 4: Response to Search Firm Inquiry

**Subject:** Re: {{FIRM_NAME}} Inquiry - {{ROLE_TITLE}} at {{COMPANY_NAME}}

Dear {{CONTACT_NAME}},

Thank you for reaching out regarding the {{ROLE_TITLE}} opportunity at {{COMPANY_NAME}}. The role sounds intriguing, particularly [mention specific aspect that aligns with your interests].

As {{MY_TITLE}} at {{MY_COMPANY}}, I've [mention 1-2 achievements directly relevant to the role requirements]. My experience with [specific technology, challenge, or domain] would be particularly valuable for [specific aspect of the role].

I've attached my resume for your review. I would welcome the opportunity to discuss this further at your convenience.

Best regards,

{{MY_NAME}}
{{MY_TITLE}}
[Phone Number]

---

## Best Practices for Outreach

### Timing
- **Best days:** Tuesday, Wednesday, Thursday
- **Best times:** 8-10 AM or 3-5 PM local time
- **Follow-ups:** 5-7 business days after initial outreach

### Personalization Tips
1. **Research the firm:** Mention a recent placement or article they published
2. **Research the contact:** Reference their LinkedIn background or recent posts
3. **Connect the dots:** Explain why your background aligns with their practice area
4. **Be specific:** Mention 1-2 target company types or challenges

### Email Structure
1. **Subject line:** Clear, professional, includes your name/title
2. **Opening:** Polite, mentions connection point
3. **Value proposition:** 2-3 sentences about your relevant experience
4. **Call to action:** Specific, low-commitment ask (15-20 minute call)
5. **Closing:** Professional, includes contact information

### Tracking in ERID
After sending:
1. Add firm if not already in system: `erid add-firm --name "{{FIRM_NAME}}"`
2. Create follow-up action: `erid add-action --title "Follow up with {{CONTACT_NAME}}" --due {{DATE+7}}`
3. Update relationship status if positive response: `erid update-firm --id <id> --relationship warm`

### Response Rate Expectations
- Cold outreach: 10-20% response rate
- Warm/referred: 30-50% response rate
- Follow-ups can increase response by 20-30%

### Template Variables for ERID CLI
```bash
# Generate personalized email
erid template outreach --firm-id <id> --template cold --output email.txt

# Track outreach in database
erid add-action --title "Email {{CONTACT_NAME}} at {{FIRM_NAME}}" --due tomorrow --related-firm-id <id>
```