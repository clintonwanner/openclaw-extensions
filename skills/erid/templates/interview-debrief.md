# Interview Debrief Template

## Interview Details
- **Date:** {{INTERVIEW_DATE}}
- **Time:** {{INTERVIEW_TIME}}
- **Duration:** {{DURATION}} minutes
- **Format:** {{FORMAT}} (technical/behavioral/case/panel)
- **Round:** {{ROUND_NAME}} ({{ROUND_NUMBER}} of {{TOTAL_ROUNDS}})

## Interview Participants
### Interviewer(s)
1. **Name:** {{INTERVIEWER_1_NAME}}
   - **Role:** {{INTERVIEWER_1_ROLE}}
   - **LinkedIn:** {{INTERVIEWER_1_LINKEDIN}}
   - **Style/Demeanor:** {{INTERVIEWER_1_STYLE}}

2. **Name:** {{INTERVIEWER_2_NAME}}
   - **Role:** {{INTERVIEWER_2_ROLE}}
   - **LinkedIn:** {{INTERVIEWER_2_LINKEDIN}}
   - **Style/Demeanor:** {{INTERVIEWER_2_STYLE}}

### Additional Attendees
{{ADDITIONAL_ATTENDEES}}

## Role & Company Context
- **Company:** {{COMPANY_NAME}}
- **Role:** {{ROLE_TITLE}}
- **Department/Team:** {{TEAM_DEPARTMENT}}
- **Reporting Line:** {{REPORTING_TO}}
- **Team Size:** {{TEAM_SIZE}}
- **Key Challenges Mentioned:** {{KEY_CHALLENGES}}

## Interview Questions & Answers

### Technical Questions
| Question | My Answer | Performance | Notes |
|----------|-----------|-------------|-------|
| {{TECH_QUESTION_1}} | {{ANSWER_1}} | {{PERF_1}} | {{NOTES_1}} |
| {{TECH_QUESTION_2}} | {{ANSWER_2}} | {{PERF_2}} | {{NOTES_2}} |

### Behavioral Questions
| Question | My Answer | STAR Format Used? | Notes |
|----------|-----------|-------------------|-------|
| {{BEHAVIORAL_QUESTION_1}} | {{ANSWER_1}} | {{STAR_1}} | {{NOTES_1}} |
| {{BEHAVIORAL_QUESTION_2}} | {{ANSWER_2}} | {{STAR_2}} | {{NOTES_2}} |

### Leadership & Strategy Questions
| Question | My Answer | Key Points Made | Notes |
|----------|-----------|-----------------|-------|
| {{LEADERSHIP_QUESTION_1}} | {{ANSWER_1}} | {{POINTS_1}} | {{NOTES_1}} |
| {{LEADERSHIP_QUESTION_2}} | {{ANSWER_2}} | {{POINTS_2}} | {{NOTES_2}} |

### Company & Culture Questions
| Question Asked | My Question | Response Received | Insights Gained |
|----------------|-------------|-------------------|-----------------|
| {{COMPANY_QUESTION_1}} | {{MY_QUESTION_1}} | {{RESPONSE_1}} | {{INSIGHT_1}} |
| {{COMPANY_QUESTION_2}} | {{MY_QUESTION_2}} | {{RESPONSE_2}} | {{INSIGHT_2}} |

## Performance Assessment

### Strengths Demonstrated
1. **{{STRENGTH_1}}** - Evidence: {{EVIDENCE_1}}
2. **{{STRENGTH_2}}** - Evidence: {{EVIDENCE_2}}
3. **{{STRENGTH_3}}** - Evidence: {{EVIDENCE_3}}

### Areas for Improvement
1. **{{IMPROVEMENT_1}}** - What happened: {{DESCRIPTION_1}} | Better approach: {{BETTER_APPROACH_1}}
2. **{{IMPROVEMENT_2}}** - What happened: {{DESCRIPTION_2}} | Better approach: {{BETTER_APPROACH_2}}

### Key Messages Conveyed
1. **About my experience:** {{EXPERIENCE_MESSAGE}}
2. **About my leadership style:** {{LEADERSHIP_MESSAGE}}
3. **About my value proposition:** {{VALUE_PROPOSITION}}

## Interviewer Signals & Feedback

### Positive Signals Observed
- [ ] Engaged body language (leaning in, nodding)
- [ ] Asking follow-up questions
- [ ] Sharing company/team details voluntarily
- [ ] Discussing "next steps" or timeline
- [ ] Using "we" language (including you in future)
- [ ] Smiling/laughing at appropriate moments
- [ ] Taking notes during your answers

### Neutral/Negative Signals
- [ ] Limited eye contact
- [ ] Checking watch/phone
- [ ] Short, clipped answers
- [ ] Not asking follow-up questions
- [ ] Defensive body language (crossed arms)
- [ ] Rushing through questions

### Verbal Feedback Received
- **Direct praise:** {{DIRECT_PRAISE}}
- **Constructive feedback:** {{CONSTRUCTIVE_FEEDBACK}}
- **Areas of interest:** {{AREAS_OF_INTEREST}}
- **Concerns raised:** {{CONCERNS_RAISED}}

## Company & Role Insights

### Culture Assessment
- **Communication style:** {{COMM_STYLE}}
- **Decision-making:** {{DECISION_MAKING}}
- **Risk tolerance:** {{RISK_TOLERANCE}}
- **Innovation focus:** {{INNOVATION_FOCUS}}
- **Work-life balance signals:** {{WORK_LIFE_BALANCE}}

### Role Specifics Learned
- **Actual responsibilities:** {{ACTUAL_RESPONSIBILITIES}}
- **Budget authority:** {{BUDGET_AUTHORITY}}
- **Hiring authority:** {{HIRING_AUTHORITY}}
- **Key metrics:** {{KEY_METRICS}}
- **First 90-day expectations:** {{FIRST_90_DAYS}}

### Team Dynamics
- **Team composition:** {{TEAM_COMPOSITION}}
- **Skill gaps mentioned:** {{SKILL_GAPS}}
- **Current challenges:** {{CURRENT_CHALLENGES}}
- **Growth plans:** {{GROWTH_PLANS}}

## Compensation Discussion

### Topics Covered
- **Salary range mentioned:** {{SALARY_RANGE}}
- **Bonus structure:** {{BONUS_STRUCTURE}}
- **Equity/options:** {{EQUITY_DETAILS}}
- **Benefits discussed:** {{BENEFITS}}
- **Relocation:** {{RELOCATION}}

### My Position
- **My stated range:** {{MY_RANGE}}
- **Timing for discussion:** {{TIMING}}
- **Negotiation points identified:** {{NEGOTIATION_POINTS}}

## Next Steps & Follow-up

### Agreed Actions
1. **{{ACTION_1}}** - Responsible: {{RESPONSIBLE_1}} | Deadline: {{DEADLINE_1}}
2. **{{ACTION_2}}** - Responsible: {{RESPONSIBLE_2}} | Deadline: {{DEADLINE_2}}

### Timeline
- **Next interview round:** {{NEXT_ROUND_DATE}}
- **Decision timeline:** {{DECISION_TIMELINE}}
- **Start date discussed:** {{START_DATE}}

### Follow-up Items for Me
1. **Thank you email:** Send by {{THANK_YOU_DEADLINE}}
   - Key points to include: {{THANK_YOU_POINTS}}
2. **Additional materials requested:** {{ADDITIONAL_MATERIALS}}
3. **References:** {{REFERENCE_STATUS}}

### Questions to Follow Up On
1. {{QUESTION_1}}
2. {{QUESTION_2}}
3. {{QUESTION_3}}

## Overall Assessment

### Interview Score (1-10): {{SCORE}}
**Rationale:** {{SCORE_RATIONALE}}

### Interest Level (1-10): {{INTEREST}}
**Rationale:** {{INTEREST_RATIONALE}}

### Fit Assessment
- **Role fit:** {{ROLE_FIT}}%
- **Culture fit:** {{CULTURE_FIT}}%
- **Team fit:** {{TEAM_FIT}}%

### Red Flags Identified
1. {{RED_FLAG_1}}
2. {{RED_FLAG_2}}

### Green Flags Identified
1. {{GREEN_FLAG_1}}
2. {{GREEN_FLAG_2}}

## Action Items for ERID

### Database Updates
```bash
# Add interview record
erid interview --app-id {{APPLICATION_ID}} \
  --round "{{ROUND_NAME}}" \
  --date "{{INTERVIEW_DATE}}" \
  --interviewer "{{INTERVIEWER_NAMES}}" \
  --format {{FORMAT}} \
  --notes "{{BRIEF_SUMMARY}}"

# Update application stage if advancing
erid update-app --id {{APPLICATION_ID}} --stage interview

# Add follow-up actions
erid add-action --title "Send thank you to {{INTERVIEWER_NAMES}}" --due {{DUE_DATE}} --related-app-id {{APPLICATION_ID}}
erid add-action --title "Prepare for next round on {{NEXT_ROUND_DATE}}" --due {{PREP_DATE}} --related-app-id {{APPLICATION_ID}}
```

### Preparation for Next Round
**Topics to research:** {{RESEARCH_TOPICS}}
**People to research:** {{PEOPLE_TO_RESEARCH}}
**Questions to prepare:** {{QUESTIONS_TO_PREPARE}}
**Materials to review:** {{MATERIALS_TO_REVIEW}}

## Template Usage Notes

### When to Complete
- **Immediately after interview:** Fill in factual sections
- **Within 2 hours:** Complete performance assessment
- **Within 24 hours:** Finalize and add to ERID

### Tips for Effective Debriefs
1. **Be honest** about performance, not optimistic
2. **Note specific questions** that were challenging
3. **Record verbatim quotes** when possible
4. **Update after thank-you email** with any response
5. **Share with mentor/coach** for external perspective

### ERID Integration
This template aligns with the `interview_sessions` and `interview_questions` tables. Use the CLI commands above to sync debrief data into your ERID database for tracking and analysis across all interviews.